# Changelog

All notable changes are documented here using [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

No additional changes.

## [0.2.0-alpha.1] - 2026-07-23

Content-hardening alpha artifact; interactive BeamNG validation remains Pending.

### Added

- Explicit object-return, normal-`nil`/event, false-rejection, thrown-error, and read-back adapter contracts.
- Phase-aware lifecycle expectations with token, vehicle/model/config, event, requested-state, elapsed-time, and exact timeout diagnostics.
- Stable depth/path/ID slot order, ancestor-change descendant deferral, fresh-tree candidate use, and detailed mutation-pass records.
- Separate model/config/part/tuning session blacklists; part keys include model, slot path, and candidate.
- Conservative suspect-batch attribution and public Advanced blacklist details.
- Evidence-based `official`, `mod`, `user`, and `unknown` classification plus exact Automation/trailer/prop classification.
- Explicit-only correlated tuning-group normalizer with group substreams and per-member range/step enforcement.
- Bounded developer stress API, cancellation, deterministic iteration seeds, and aggregate summary.
- Granular read/write/lifecycle/persistence/UI capabilities and optional-stage warnings.
- Synthetic license-safe fixtures for official/config-pack/full-mod/part-pack/wheel-pack/user/unknown/legacy/nested/electric/multi-differential/malformed/paint shapes.
- Regression cases for all content-hardening contracts and a small JavaScript boundary harness through static assertions.

### Changed

- Renamed **Keep Vehicle Drivable** to **Protect Critical Parts**, with schema migration and no drivability guarantee.
- Protected critical non-empty substitutions now preserve current/default when functional equivalence is unproven.
- Actions receive the displayed settings snapshot atomically; pending UI debounce is cancelled first.
- History snapshots stay temporary until immediately before the first destructive write and commit once across passes.
- Parts can continue when optional tuning or paint capabilities are unavailable.
- Unknown source labels are included only by Everything, not guessed as mods.
- Tuning variables without explicit correlation metadata use independent name-derived substreams.
- App host explicitly fills the UI container with `replace: false`.
- Selector icon reduced from 1810×869 / 1,111,288 bytes to 500×240 / 32,100 bytes while preserving the artwork.
- Package output reports version, commit, filename, entries, bytes, and SHA-256.
- CI uses current Node 24-based official actions pinned by full commit SHA.

### Fixed

- `false`/`nil` adapter results can no longer be reported as unconditional write success.
- Known synchronous write rejection no longer waits for the reload timeout.
- Parent and descendant candidates from one stale tree can no longer be applied together.
- A later parts/tuning/paint failure no longer penalizes a confirmed base configuration.
- Blacklisted part candidates are actually filtered by `mutationEngine.plan()`.
- Spawn/parts/tuning reloads cannot advance without phase-specific state verification.
- Immediate action clicks cannot use stale Chaos, seed, filter, or checkbox values.
- Pre-write scan/selection failure no longer leaves a no-op Undo entry.
- Successful automatic rollback removes its redundant history entry; failed rollback preserves evidence.
- ZIP member order, timestamps, permissions, paths, text line endings, checksum, icon constraints, and machine-path checks are enforced.

### Known limitations

- No interactive world/UI or representative third-party content result is claimed.
- Installed 0.38.6 tuning metadata revealed no proven correlation group, so real variables remain independent.
- Protect Critical Parts is conservative metadata protection, not a generic drivability validator.
- Cross-platform byte identity is claimed only after comparing the actual final CI and local archives.

## [0.1.0-alpha.1] - 2026-07-23

### Added

- BeamNG 0.38.6 adapter and modular GE Lua/UI App foundation.
- Seeded model/config selection, hierarchical parts, tuning, paint, rollback, Undo, diagnostics, tests, and deterministic package tooling.

No tag, GitHub Release, PR, or BeamNG Repository submission is implied by a changelog entry.

[Unreleased]: https://github.com/Soturine/beamng-soturine-chaos-randomizer/commits/main
