# v0.6.3 release audit

Status: implementation audit in progress. This document is updated as evidence
is produced; it is not a release approval.

## Git and historical preservation

| Item | Initial audit |
| --- | --- |
| Local `main` | `6907473205decf71433a24d72075358011e0da24` |
| `origin/main` | `6907473205decf71433a24d72075358011e0da24` |
| Worktree | clean before the 0.6.3 branch was created |
| Working branch | `fix/v0.6.3-live-lifecycle` |
| `v0.6.2` object type | annotated tag |
| `v0.6.2^{}` | `6907473205decf71433a24d72075358011e0da24` |
| 0.6.2 release | existing experimental prerelease; untouched |

## Initial inventory

The baseline contains 134 tracked production, documentation, test, workflow,
and tooling files, totalling 26,012 text lines and 1,606,612 bytes in the local
inventory. Generated `dist/`, Python cache, and test cache content is ignored.

### Production surfaces

| Surface | Inventory |
| --- | --- |
| GELua entry point | `lua/ge/extensions/soturineChaosRandomizer.lua` |
| GELua implementation modules | 62 files under `lua/ge/extensions/soturineChaosRandomizer/` |
| Main orchestrator | `main.lua`: 5,615 lines, 88 public exports |
| BeamNG adapter | `apiAdapter.lua`: 1,004 lines, 58 public exports |
| UI | `app.js` 668 lines; `app.css` 112 lines; `app.html`; `app.json`; PNG and SVG assets |
| Settings | defaults JSON, settings schema 6 |
| Vehicle DNA | schema 1 plus storage, package, gallery, compatibility, restore, mutation, import, locks, compare, and fingerprint modules |
| Packaging | deterministic Python packager, validator, SHA-256, and release manifest |
| Workflows | CI, package/prerelease, and cross-platform beta-readiness |

### Module dependency findings

- The entry point requires `main.lua`; `main.lua` composes the gameplay modules.
- 61 of 62 implementation modules have a production require path.
- `tuningRandomizer.lua` has no production consumer. Production uses
  `tuningPipeline.lua`; the orphan is retained only by tests and must be removed
  or made the pipeline sampler before packaging.
- BeamNG-internal calls are concentrated in `apiAdapter.lua`,
  `spawnApiAdapter.lua`, `aiAdapter.lua`, and `destinationMarker.lua`.
- `main.lua` declares extension dependencies but has no direct BeamNG API call;
  it should not need a source-contract exception.

### Main public domains

The 88 `main.lua` exports cover operation lifecycle, Random Car, Scramble, Full
Random, Undo, settings and locks, diagnostics and stress, legacy lineup/Race,
managed vehicle spawning, placement, AI, and Vehicle DNA/Garage operations.
The legacy `lineup*` names are a compatibility surface that must be preserved
while new internal documentation uses Race terminology.

### API boundary finding

`apiAdapter.getCurrentVehicleData()` incorrectly requires
`getPlayerVehicleData` before it can use the independent
`getVehicleData(vehicleId)` capability. `processTargetTracking()` also passes
the returned replacement ID into `getVerificationState()`, even before a
concrete target has been confirmed. This turns a candidate ID into immutable
ownership and reproduces the structural failure described in the 0.6.2 live
report.

### Baseline tests by category

| Category | Executed | Passed | Failed | Notes |
| --- | ---: | ---: | ---: | --- |
| Behavioral and mocked Lua | 319 | 319 | 0 | 4,031 assertions; includes mocked pipeline and state contracts |
| Lua requirement mappings | 440 | 440 | 0 | mappings, not independent executions |
| Python host wrappers | 50 | 50 | 0 | includes Lua launcher, static, JSON, workflow, and package checks |
| JavaScript syntax | 1 | 1 | 0 | `node --check`; not a rendered UI test |
| Lua compiler syntax | 0 | 0 | 0 | blocked locally: no `luac`; CI installs Lua 5.1 |
| Live BeamNG | 0 | 0 | 0 | pending; mandatory release gate |

## Initial root-cause conclusion

The probable root cause is confirmed and refined:

1. `bindReplacementTarget()` writes the returned ID into `active.vehicleId`,
   `runtime.state.vehicleId`, `active.wait.vehicleId`, the operation target,
   and expected continuation context before validating the logical target.
2. `vehicleTargetTracker.verifyIdentity()` then rejects any different player ID
   before model/config correlation.
3. `processTargetTracking()` reads only that fixed ID, preventing discovery of
   a legitimate recreated player object.
4. `onVehicleSpawned` is already represented as a candidate in parts of the
   tracker, but the early authoritative writes negate that design.
5. Parts/tuning reload waits reuse concrete ownership instead of explicitly
   releasing it and rebinding the same logical target.
6. Timeout handling enters recovery without one final unbound, coherent player
   read, allowing a correct visible target to be discarded.

The 0.6.3 fix therefore needs an explicit logical target, bounded candidate
records, atomic validated rebind, ownership reset for every reload, and a final
pre-recovery convergence read. Longer timeouts or pause manipulation are not
acceptable fixes.

