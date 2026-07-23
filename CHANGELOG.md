# Changelog

All notable changes are documented here using [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

No additional changes.

## [0.4.0-alpha.1] - 2026-07-23

Vehicle-DNA-and-persistence alpha artifact; interactive BeamNG, restart, corruption-recovery, representative-content, and multi-PC evidence remains Pending.

### Added

- Versioned Vehicle DNA schema v1 with normalized final slots, tuning, supported paint fields, base identity, generation context, categorized dependencies, safety evidence, and deterministic change-detection fingerprints.
- Explicit Save Vehicle DNA flow and bounded persistent Garage with rename, favorite, delete, pagination, JSON copy/import, controlled file export, and last-known-good recovery.
- Separate read-only compatibility preflight, transactional Restore Exact, explicitly confirmed Restore Compatible, and generator-versioned Replay Seed operations.
- Parent-first restore passes, DNA-specific lifecycle phases, safety validation, strict/subset final read-back, one history transaction, and rollback on divergence.
- Generator version 4 seeds in `SCR4-XXXX-XXXX` form while preserving legacy `XXXX-XXXX` parsing and generator sequences.
- Release manifest, tag/VERSION validation, verified prerelease workflow, and a non-publishing Windows/Ubuntu beta-readiness comparison workflow.
- Vehicle DNA, schema, and multi-PC/beta-gate documentation plus expanded schema/storage/import/compatibility/pipeline/UI/package regressions.

### Changed

- Settings schema is now 3 with a 100-entry DNA limit, autosave fixed off, and Exact as the default restore mode.
- The UI uses compact Randomize, Garage, and Compatibility views; destructive restores happen only after a visible preflight and confirmation.
- Persistence capabilities are split into settings read/write and DNA read/write/list/delete/import/export/backup behavior.
- Package output now includes a deterministic external `release-manifest.json` with real automated counts and zero invented interactive passes.

### Security

- Pasted imports are capped, parsed as JSON data before bridge serialization, canonicalized, schema/fingerprint validated, and denied arbitrary paths, method names, code execution, network access, non-finite numbers, cycles, and unbounded structures.
- DNA IDs and names never become storage paths; file export uses one adapter-controlled path under the documented settings directory.

### Known limitations

- No BeamNG world/UI session, exact restart restore, last-known-good recovery in game, third-party content, or cross-PC transfer result is claimed.
- Exact preflight blocks as `unverified` when the target slot tree cannot be inspected without first changing the active vehicle.
- Fingerprints are deterministic change detectors, not cryptographic signatures, mod-file hashes, or equality proof.
- `0.4.0-beta.1` is prepared but must not be versioned, tagged, or published until the documented interactive gate passes.

## [0.3.0-alpha.1] - 2026-07-23

Safety-and-compatibility alpha artifact; interactive BeamNG and representative third-party content validation remains Pending.

### Added

- Evidence-based safety graph with standard-road, electric, hybrid-like, Automation, trailer, prop, special, and unknown profiles plus `safe`, `uncertain`, `unsafe`, and `not_applicable` results.
- Layered loaded-config verification using model, normalized filename, registry identity, and minimal stable state signature.
- Per-candidate part source metadata and separate previous/selected source diagnostics.
- Bounded deferred paint confirmation, tolerant field normalization, and requested-field-only read-back comparison.
- Full mocked `main.lua` success, failure, timeout, cancellation, rollback, Undo, and stress pipeline coverage.
- Deterministic large-registry/deep-tree performance fixtures, profiling tool, metrics, budgets, and compatibility matrix.

### Changed

- Full Random is explicitly one seed/token/history transaction and completes only after spawn, parts, optional tuning/paint, and final safety validation.
- External mod configurations use confirmed mounted-path ownership rather than inheriting their parent model's source.
- Multi-candidate failures accumulate bounded suspicion with independent batch fingerprints; successful use reduces suspicion.
- Selected part provenance comes from the selected candidate, not the previously installed part.
- Advanced UI reports bounded suspect counts/details and clarifies all three action semantics.

### Fixed

- Vehicle replacement passes the exact recorded target object, then binds switch expectations to the ID extracted from the returned object; unrelated or ambiguous switches neither retarget the operation nor start an unsafe rollback.
- Rollback and Undo reject unrelated restore targets and validate their original vehicle context.
- Legitimate paint defaults, extra fields, equivalent color objects, float normalization, and delayed cache updates no longer create immediate false failures.
- Config packs on official models and full-mod configs with confirmed path ownership are classified consistently.
- Required/core and baseline-proven functional safety roles are checked after reload and before final success without assuming four wheels, fuel, one differential, or a conventional gearbox.
- Undo now enters its legal spawn state before waiting for restore confirmation.

### Known limitations

- No interactive world/UI, Automation export, trailer, prop, electric vehicle, multi-differential vehicle, or third-party mod result is claimed.
- Safety evidence cannot prove generic drivability; insufficient unusual layouts remain `uncertain`.
- Installed 0.38.6 tuning metadata still provides no proven real correlation-group contract.

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
- Cross-platform byte identity applies to this artifact after comparing the actual CI/Linux and Windows ZIPs.

## [0.1.0-alpha.1] - 2026-07-23

### Added

- BeamNG 0.38.6 adapter and modular GE Lua/UI App foundation.
- Seeded model/config selection, hierarchical parts, tuning, paint, rollback, Undo, diagnostics, tests, and deterministic package tooling.

No tag, GitHub Release, PR, or BeamNG Repository submission is implied by a changelog entry.

[Unreleased]: https://github.com/Soturine/beamng-soturine-chaos-randomizer/commits/main
