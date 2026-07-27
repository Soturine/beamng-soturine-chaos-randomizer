# Release audit — 0.6.3

Status: **candidate preparation in progress; tag and release blocked by live validation**.

## Historical preservation

| Item | Audit result |
| --- | --- |
| Baseline/current original `main` | `6907473205decf71433a24d72075358011e0da24` |
| `origin/main` at branch creation | same baseline |
| `v0.6.2` | annotated tag resolving to baseline; untouched |
| 0.6.2 GitHub release/assets | existing experimental prerelease; untouched |
| History policy | no force push, tag move, release overwrite, or public rewrite |

## Inventory and boundaries

- 76 current production files across `lua/`, `ui/`, and `settings/`.
- 68 implementation Lua modules below the extension directory.
- `main.lua`: 5,935 lines and 88 public exports at this audit point.
- Direct unstable BeamNG access is restricted to `apiAdapter.lua`, `spawnApiAdapter.lua`, `aiAdapter.lua`, and `destinationMarker.lua`; `main.lua` was removed from the exception.
- Production require reachability is tested from the BeamNG entrypoint and the documented legacy Lineup entrypoint.
- No secrets, credentials, or packaged absolute machine paths are permitted.

## Root cause and implementation

The 0.6.2 failure was confirmed structurally: replacement-return IDs were promoted before coherent player/model/config validation, then fixed-ID polling rejected legitimate object recreation. Reload phases also retained concrete ownership, and timeout recovery lacked a final unbound read.

The candidate now:

- separates logical target intent from bounded concrete candidates;
- treats returned IDs and callbacks as evidence, not authority;
- discovers player 0 coherently and rechecks the player ID after exact-ID data reads;
- atomically rebinds only current, stable, coherent, model/config-compatible candidates;
- releases concrete ownership for spawn/reload/rollback/DNA waits;
- performs final unbound parts/tuning verification before recovery;
- rejects stale generations and repeated recovery fingerprints;
- prevents terminal phases from becoming Busy again;
- discovers tuning until fixed point/cycle/limit;
- verifies a 10% floor only for classified combustion fuel storages;
- restores real slider fill, the v0.6.1 fox bytes, and content-based UI sizing.

## Architecture audit

- Removed dead `tuningRandomizer.lua`; its useful explicit correlation behavior moved into `tuningPipeline.lua` and tests now exercise production code.
- Extracted shared `crc32.lua` with standard vectors.
- Extracted only common coverage target binding into `coverageContext.lua`; slot/tuning/paint classifications remain separate.
- Made `raceManager.lua` canonical with `compat/legacyLineupFacade.lua` preserving historical imports.
- Added bounded performance percentile collection.
- Retained `main.lua` orchestration to avoid a high-risk broad controller rewrite during a P0 lifecycle release.

## Validation gates

| Gate | Status |
| --- | --- |
| Automated source/Lua/JS/schema/workflow suites | Passed: 54 Python methods/808 subtests, 347 Lua cases/7,897 assertions, 17 JS cases |
| Orphan and BeamNG boundary gates | Implemented |
| Version/app/release-note consistency | Passed for 0.6.3 |
| Reproducible ZIP, manifest, SHA-256 | Pending final candidate build |
| Exact-ZIP clean-profile install | Pending |
| 110-case live plan | 0 executed / 110 Pending |
| Tag `v0.6.3` | Not created; blocked |
| GitHub prerelease | Not created; blocked |

The candidate may be committed, pushed, and handed off with an artifact. It must stop before tag/release until [LIVE_TEST_REPORT.md](LIVE_TEST_REPORT.md) records the exact artifact passing mandatory cases.
