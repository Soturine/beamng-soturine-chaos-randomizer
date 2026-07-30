# Roadmap

This roadmap describes direction, not release evidence. Completed version history is recorded in [CHANGELOG.md](CHANGELOG.md).

## Now

- Publish v0.6.8 as an Experimental prerelease with reproducible ZIP, manifest,
  SHA-256, annotated tag, and central BeamNG 0.39 compatibility metadata.
- Execute the exact 60-case v0.6.8 plan against the downloaded release asset.
- Capture logs/screenshots for registry warm-up, technical identity, spawn
  denial/cardinality, instability correlation, migration, conflicts, safety,
  explicit AI lane state, and repeated HUD host resize/remount cycles.
- Promote no live-validated claim until every mandatory row is executed and
  Passed against that exact asset.

## Next

- P1: evaluate a Runtime UI-native Vue rewrite without removing the verified
  legacy Angular host until feature parity and migration are proven.
- P1: adopt new BeamNG 0.39 Lua/vehicle-controller APIs, editor integrations,
  FFV improvements, and Automated Performance Class only behind capability and
  live evidence.
- P1: revalidate drivetrain, forced-induction, N2O, fuel-tank, controller-init,
  and reset behavior in gameplay; automated safety coverage is not live proof.
- Reduce `main.lua` orchestration safely through controller extraction backed by state-machine tests and the v0.6.8 lifecycle evidence model.
- Expand live coverage across representative vehicle, config, part, and controller mods.
- Add localization infrastructure after UI strings and layouts stabilize.
- Improve performance baselines with real idle, Chaos, Race, AI, deep-tree, and many-mod captures.
- Revalidate BeamNG Repository submission requirements and listing assets.

## Later

- P2: consider Runtime UI-only packaging after the legacy host is officially
  unnecessary and all layouts/input modes have owner evidence.
- Stabilize extension APIs intended for third-party integrations.
- Add migration tooling if a future Vehicle DNA or Race schema requires a major revision.
- Explore additional placement and AI workflows only where BeamNG exposes a bounded, target-safe contract.
- Expand accessibility, controller, high-DPI, ultrawide, and reduced-motion validation.

## 1.0 exit criteria

- No known P0 lifecycle, ownership, recovery, Busy, fuel, or data-integrity defect.
- Repeated clean-profile testing with an exact packaged artifact on a documented current BeamNG build.
- Broad official and representative mod coverage with honest degradation evidence.
- Stable settings, Vehicle DNA, Race, and public compatibility policy.
- Reproducible release assets, immutable history, green CI, and complete live evidence.
- User, maintainer, architecture, testing, compatibility, security, and troubleshooting documentation kept current.
