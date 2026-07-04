SHELL := /usr/bin/env bash

REGISTRY     ?=
TAG          ?= dev
PREFIX       := $(if $(REGISTRY),$(REGISTRY)/,)
IMAGE        := $(PREFIX)portfolio-site:$(TAG)
KIND_CLUSTER ?= eks-platform

.DEFAULT_GOAL := help

.PHONY: help
help: ## Show this help
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	  | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-14s\033[0m %s\n", $$1, $$2}'

.PHONY: venv
venv: ## Create the local mkdocs venv
	@test -d .venv || python3 -m venv .venv
	@.venv/bin/pip install -q -r requirements.txt

.PHONY: serve
serve: venv ## Live-preview the site at http://localhost:8000
	.venv/bin/mkdocs serve

.PHONY: build-site
build-site: venv ## Build the static site into ./site
	.venv/bin/mkdocs build --strict

.PHONY: image
image: ## Build the container image
	docker build -t $(IMAGE) .

.PHONY: scan
scan: ## Trivy gate (fixable HIGH/CRITICAL) on the image
	trivy image --severity HIGH,CRITICAL --ignore-unfixed --exit-code 1 $(IMAGE)

.PHONY: sbom
sbom: ## Generate an SPDX SBOM for the image
	syft $(IMAGE) -o spdx-json > sbom.spdx.json

.PHONY: helm-lint
helm-lint: ## Lint + render the chart for kind and EKS
	helm lint deploy/helm/site
	helm template site deploy/helm/site -f deploy/helm/site/values-kind.yaml >/dev/null
	helm template site deploy/helm/site -f deploy/helm/site/values-eks.yaml >/dev/null

.PHONY: tf-check
tf-check: ## terraform fmt/validate + tfsec (no AWS creds)
	terraform -chdir=terraform fmt -check
	terraform -chdir=terraform init -backend=false -input=false >/dev/null
	terraform -chdir=terraform validate
	tfsec terraform --concise-output

.PHONY: dev
dev: image ## Build, load into kind, helm install (ISOLATED kubeconfig)
	@echo ">> using an isolated kubeconfig (.kube-demo); your ~/.kube/config is untouched"
	kind export kubeconfig --name $(KIND_CLUSTER) --kubeconfig .kube-demo
	kind load docker-image $(IMAGE) --name $(KIND_CLUSTER)
	KUBECONFIG=.kube-demo helm upgrade --install portfolio-site deploy/helm/site \
	  -n portfolio --create-namespace -f deploy/helm/site/values-kind.yaml \
	  --set image.registry="" --set image.tag=$(TAG)
	@echo ">> add '127.0.0.1 portfolio.localtest.me' if needed, then open http://portfolio.localtest.me"

.PHONY: undev
undev: ## Remove the local release
	KUBECONFIG=.kube-demo helm uninstall portfolio-site -n portfolio || true
