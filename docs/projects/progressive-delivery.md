# Progressive Delivery

<span class="pill planned">planned</span> · Argo Rollouts · canary · blue/green · auto-rollback

!!! info "Status: planned"
    Scheduled after Observability (it depends on those metrics). This page describes intended
    scope only — it does not claim a running system.

## Planned scope

- **Argo Rollouts** controller + dashboard.
- Convert the `catalog` service to a **Rollout** with both **canary** and **blue/green** variants.
- **AnalysisTemplate** querying Prometheus (success rate + p95 latency).
- **The money demo:** ship a deliberately "bad" version (via the built-in `FAILURE_RATE` knob)
  → analysis breaches threshold → **automatic rollback**, captured on video.

## Why it's last

It builds directly on the observability signals and the chaos knobs already present in the
shop services, so it's the natural capstone of the platform story.
