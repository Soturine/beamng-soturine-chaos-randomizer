# Roadmap

This roadmap describes direction, not release evidence. Completed version history is recorded in [CHANGELOG.md](CHANGELOG.md).

## Now

- Finish the 0.6.3 candidate audit and keep all automated categories green.
- Build the reproducible candidate ZIP and publish its manifest and SHA-256.
- Execute the exact live plan against that ZIP on BeamNG.drive `0.38.6.0.19963`.
- Resolve any remaining 22%, 57%, wrong-target, recovery-loop, fuel, or UI regressions found live.
- Tag and publish 0.6.3 only after the live release gate passes.

## Next

- Reduce `main.lua` orchestration safely through controller extraction backed by state-machine tests.
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
