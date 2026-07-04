# DevOps / Platform Engineering

I build and run **production-grade Kubernetes platforms** — infrastructure as code,
GitOps delivery, gated CI/CD pipelines, supply-chain security, and observability.

This site is itself an exhibit: it's containerized, Helm-packaged, delivered by the same
**ArgoCD** GitOps flow it documents, and gated by the same **Trivy → SBOM → Cosign** pipeline.

<div class="metrics" markdown>
<div class="metric"><div class="n">27 MB</div><div class="l">smallest distroless image</div></div>
<div class="metric"><div class="n">0</div><div class="l">HIGH/CRITICAL CVEs (Trivy-gated)</div></div>
<div class="metric"><div class="n">$0</div><div class="l">to run the demos</div></div>
<div class="metric"><div class="n">3</div><div class="l">CI systems, one pipeline</div></div>
<div class="metric"><div class="n">GitOps</div><div class="l">ArgoCD app-of-apps</div></div>
<div class="metric"><div class="n">IaC</div><div class="l">Terraform, validated + planned</div></div>
</div>

## The platform, end to end

```mermaid
flowchart LR
  TF["Terraform<br/>VPC · EKS · Karpenter · IRSA"] --> CL[("Cluster<br/>kind / EKS")]
  CL --> ARGO["ArgoCD (app-of-apps)"]
  ARGO --> ADDONS["cert-manager · ingress/ALB<br/>ExternalDNS · Karpenter"]
  ARGO --> APPS["workloads (shop, this site)"]
  APPS -. metrics/traces .-> OBS["Prometheus · Loki · Tempo"]
  CI["CI: build → Trivy → SBOM → Cosign → push"] -->|image tag bump| ARGO
```

## Projects

<div class="grid cards" markdown>

-   :material-kubernetes: **EKS Platform — Terraform + GitOps** <span class="pill done">shipped</span>

    ---

    Modular Terraform (VPC · EKS v21 · Karpenter · IRSA), multi-env (dev/staging/prod),
    S3 remote state, and an ArgoCD app-of-apps. Proven with `validate` + `tflint` + `tfsec`
    and demoed live on kind.

    [:octicons-arrow-right-24: Case study](projects/eks-platform.md)

-   :material-source-branch: **Microservices + CI/CD** <span class="pill done">shipped</span>

    ---

    One app, three languages (Go · Python · Node), distroless images, and the **same
    pipeline in GitHub Actions, GitLab CI, and Jenkins** — Trivy-gated, SBOM'd, Cosign-signed.

    [:octicons-arrow-right-24: Case study](projects/microservices.md)

-   :material-chart-line: **Observability** <span class="pill wip">in progress</span>

    ---

    kube-prometheus-stack, Loki, Tempo, OpenTelemetry, dashboards-as-code, and SLO
    burn-rate alerts on the workloads above.

    [:octicons-arrow-right-24: Planned scope](projects/observability.md)

-   :material-swap-horizontal: **Progressive Delivery** <span class="pill planned">planned</span>

    ---

    Argo Rollouts canary + blue/green with Prometheus analysis and automated rollback.

    [:octicons-arrow-right-24: Planned scope](projects/progressive-delivery.md)

</div>

!!! note "How this runs at $0 (and what that means)"
    Live demos run on a local **kind** cluster. The **EKS** delivery is real
    Terraform/Helm/ArgoCD — `validate`d, `plan`-verified and security-scanned — but the EKS
    control plane has no free tier, so I don't leave one running. I demo on kind (and briefly,
    ephemerally, on AWS when I need real-cluster screenshots). **The same manifests apply to a
    real cluster unchanged.** Nothing here claims a permanently-live EKS environment; that's a
    deliberate cost choice, not a gap.
