# Post-v0.7.0 audit plan

This is a future methodology. It was not executed during v0.7.0.

## Trigger

Begin after the relevant BeamNG 0.39.x hotfix cycle has produced updated
release notes, documentation, installed runtime source, and enough field
evidence to compare against v0.7.0.

## Inputs

- current official release and hotfix notes;
- current official modding, Runtime UI, vehicle, physics, and AI documentation;
- installed loader, bridge, Vue, UINav, AppHost, registry, spawn, part, tuning,
  paint, powertrain, and AI source contracts;
- v0.7.0 live reports and logs from the exact release asset;
- representative official, repository, Automation, trailer, prop, wheel, and
  configuration mods;
- known issues and credible modder/user reports as secondary evidence.

## Workstreams

1. Rebuild the compatibility/API change inventory.
2. Re-run registry, technical identity, spawn/cardinality, ownership, rollback,
   quarantine, migration, safety, physics, and determinism audits.
3. Re-audit native Vue discovery, bridge, UINav, lifecycle, sizing, input,
   accessibility, i18n, and memory behavior.
4. Re-run Garage 500 and Race 12 performance matrices and compare FPS, 1% low,
   frame time, UI latency, Lua p50/p95/p99, hook/byte rates, and memory.
5. Review architecture boundaries, `main.lua` growth, dead code, duplicated
   adapters, stale compatibility paths, and regression coverage.
6. Classify every finding by evidence, severity, ownership, reproducibility,
   and release risk.

## Decision rule

Choose v0.7.1 for bounded corrective compatibility/UI fixes that preserve the
protocol and data contracts. Choose v0.8.0 when findings require a broader
public protocol, schema, generator, lifecycle, or product-scope change. Do not
choose from calendar timing or unverified reports.

The audit output must include research notes, a requirements matrix, exact live
environment, automated and live reports, regression risks, migration impact,
and a documented version recommendation.
