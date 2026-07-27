# Roadmap

This roadmap describes direction, not release evidence. Completed version history is recorded in [CHANGELOG.md](CHANGELOG.md).

## Now

- Publish v0.6.4 as an Experimental prerelease with reproducible ZIP, manifest,
  SHA-256, and immutable annotated tag.
- Execute the exact 110-case v0.6.4 plan against the downloaded release asset
  on BeamNG.drive `0.38.6.0.19963`.
- Capture logs/screenshots for Random Car, Full Random, Scramble, paused
  lifecycle, ID churn, multi-tank fuel, optional/mod parts, and repeated tab
  resizing.
- Promote no live-validated claim until every mandatory row is executed and
  Passed against that exact asset.

## Next

- Reduce `main.lua` orchestration safely through controller extraction backed by state-machine tests and the v0.6.4 lifecycle evidence model.
- Expand live coverage across representative vehicle, config, part, and controller mods.
- Add localization infrastructure after UI strings and layouts stabilize.
- Improve performance baselines with real idle, Chaos, Race, AI, deep-tree, and many-mod captures.
- Revalidate BeamNG Repository submission requirements and listing assets.

## Later

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
