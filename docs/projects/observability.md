# Observability

<span class="pill wip">in progress</span> · Prometheus · Loki · Tempo · OpenTelemetry · Grafana

!!! info "Status: in progress"
    This project is being built next. The scope below is committed; screenshots and
    dashboards-as-code will land here as it's completed. Nothing on this page claims to be
    running yet.

## Planned scope

- **kube-prometheus-stack** (Prometheus, Alertmanager, Grafana) via GitOps.
- **Loki** (logs) + **Tempo** (traces), fed by an **OpenTelemetry Collector** — the shop
  services already emit OTLP and Prometheus metrics, ready to wire in.
- **Grafana dashboards as code** (provisioned, not click-ops) with RED/USE panels.
- **SLOs/SLIs** with **multi-window burn-rate alerts** → Slack.
- **Blackbox exporter** synthetic probes.

## Why it pairs with the rest

Every service in [Microservices + CI/CD](microservices.md) exposes `/metrics` and optional
OTLP tracing plus deliberate `FAILURE_RATE` / `LATENCY_MS` knobs — so alerts can be
demonstrated on purpose, and the same signals drive [Progressive Delivery](progressive-delivery.md).
