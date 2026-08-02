# Roadmap

This roadmap describes direction, not release evidence. Completed version history is recorded in [CHANGELOG.md](CHANGELOG.md).

## Required release sequence

- **v0.6.8 = P0: essential BeamNG 0.39 compatibility.**
- **v0.6.9 = P1: performance, profiling, and efficiency.** This release is
  limited to bounded profiling, frame budgets, low-GC iteration, reusable
  buffers, dimension/catalog caches, incremental indexing, UI diffs,
  aggregated diagnostics, adaptive polling, and capability-driven AI readback.
- **v0.7.0 = P2: Angular to Vue migration, internationalization, and
  architectural modernization.** The verified Angular compatibility host stays
  packaged through v0.6.9; Vue migration and full localization do not begin in
  the P1 release.
- **Post-v0.7.0 = fresh full audit after the BeamNG 0.39.x hotfixes.** Repeat
  research and compatibility validation then, when hotfixes, documentation,
  APIs, and field reports are expected to be more complete.

## Now

- Publish v0.6.9 as an Experimental prerelease with reproducible ZIP, manifest,
  SHA-256, annotated tag, and central BeamNG 0.39 compatibility metadata.
- Execute the exact v0.6.9 performance plan against the downloaded release
  asset; synthetic benchmarks remain separate from live FPS/frame-time proof.
- Preserve every v0.6.8 Chaos, Garage, Race, Race Policy, compatibility,
  ownership, cardinality, and lifecycle contract while implementing P1 only.
- Promote no live performance or compatibility claim until every mandatory row
  is executed and Passed against that exact asset.

## Next

- P2 in v0.7.0: migrate the HUD from the Angular compatibility host to native
  Runtime UI Vue only after feature parity, state migration, teardown, layout,
  input, and live owner evidence are complete.
- Add internationalization infrastructure together with that architectural
  modernization; v0.6.9 does not start a partial string migration.
- Reduce `main.lua` orchestration safely through controller extraction backed by state-machine tests and the v0.6.8 lifecycle evidence model.
- Expand live coverage across representative vehicle, config, part, and controller mods.
- Revalidate BeamNG Repository submission requirements and listing assets.

## Later

- Run the documented post-v0.7.0 full audit against the then-current BeamNG
  0.39.x build, documentation, APIs, hotfixes, and compatibility reports.
- Consider Runtime UI-only packaging after the legacy host is officially
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
