# Root-cause analysis — v0.6.6

Status: implementation diagnosis complete; live validation pending owner execution.

## Evidence boundary

The owner evidence in [OWNER_EVIDENCE.md](OWNER_EVIDENCE.md) proves that removing
BeamLR and `scripts/driver_assistance_angelo234` stopped the old 22%/57% hard
freeze and pause/unpause dependency. It does not prove the release fixes the
remaining internal failures. The conclusions below come from source tracing,
mocked lifecycle execution, and the installed BeamNG 0.38.6 source. They remain
subject to the live matrix.

## Confirmed causes

| Suspected cause | Finding | Concrete code evidence and correction |
| --- | --- | --- |
| Critical protection loses to Allow Missing | Confirmed | `validator.buildGraph` treated empty slots too coarsely and `validateGraph` compared aggregate roles without an exact evidence-backed path. `validator.canEmpty`, `protectedSelection`, and `validateGraph` now make documented core/required and structurally proven functional paths authoritative before optional-missing policy. |
| Brittle critical names | Confirmed | `validator.fallbackEvidence` was carrying too much safety authority. `apiAdapter.metadataForCandidate` now derives roles from loaded JBeam sections through `validator.evidenceFromPart`; names are marked heuristic fallback and cannot alone trigger structural aggregate loss. |
| Mixed or early post-reload evidence | Confirmed | `vehicleTargetTracker` could accept the last single deadline read. `coherentStateGate` now requires matching operation/target generation, concrete ID, config, readiness, parts/tuning/powertrain/energy as applicable, no newer reload, and two identical consecutive fingerprints. |
| Wrong generation or vehicle ID | Confirmed | candidate callbacks and player polling were advisory but the returned ID was not authoritative enough. `vehicleTargetTracker.verifyIdentity` rejects an unrelated polled ID after a returned binding while permitting callback-correlated recreation; stale generations are rejected before observation. |
| Ambiguous baseline | Confirmed | operation fields mixed original, candidate base, readable recovery and completed-good meanings. `baselineSemantics.lua` separates original player, selected candidate, clean candidate, last accepted generated result, and current attempt. |
| Whole recovery for a local failure | Confirmed | final safety failure called `failActive(..., true)` and the recovery ladder before an exact dependency repair. `attemptCriticalRepair` and `criticalRepair.plan` now restore the failed path or nearest missing dependency ancestor, reload once, and preserve unrelated parts/tuning/paint. |
| Optional absence escalated | Confirmed | missing parts and failed functional roles shared generic errors. `buildGraph` now records `optional_missing_allowed`, `optional_missing`, `mod_metadata_required_unproven`, and `core_infrastructure_missing` separately. Only proven functional/core loss is fatal. |
| Rolling shell treated as broken car | Confirmed | absence of an engine could be read as broken drivability. `candidateClassification` now requires explicit shell/config evidence and returns one of the seven requested classes. Race does not implicitly opt into shells. |
| Oil not verified | Confirmed | fuel storage was guarded, but engine oil was not read from the vehicle VM. The new vehicle extension probes combustion devices and reports thermal `oilMass`, `miniumSafeOilMass`/`minimumSafeOilMass`, coolant exposure, disabled state, and oil-critical damage to the generation-bound GE callback. |
| Fuel and oil conflated | Disproved in the fuel guard, confirmed in final safety coverage | `energyStorageGuard` already isolated combustion fuel. The missing behavior was a separate engine-thermal probe. `engineFluidGuard` remains independent from energy storage and excludes temperature/pressure variables. |
| Oil read before initialization | Confirmed risk | one read was insufficient. `ensureEngineFluidSafety` performs at most eight event-driven requests and requires two identical samples. Unavailable data is an honest partial result with no oil-safety claim; proven zero/below-safe/disabled is rejected. |
| Race mutates player N times | Confirmed | `startNextLineupCompetitor` invoked Full Random against the current player and retained DNA, while physical vehicles were created later by Placement. It now starts with no mutation target, calls `spawnNewVehicle`, enters only that owned vehicle for player-global part APIs, retains its unique managed ID, and re-enters the original player before advancing. |
| Concrete IDs not rebound | Confirmed | competitor storage lacked complete ownership fields. Each competitor now has immutable `competitorId`/`requestedIndex` and mutable operation/generation/current-ID/spawn/randomization/validation/placement/terminal fields. Registry validation rejects duplicate concrete IDs. |
| Placement gated forever | Confirmed | availability depended on a summary that did not represent retained physical vehicles. `raceManager.placementAvailability` counts ready managed handles and supplies explicit reasons for no lineup, generation busy, placement busy, and no retained targets. Placement repositions existing IDs with stable read-back. |
| Shared Race operation context | Confirmed | competitor sequencing reused the global player mutation path without an owned target boundary. Each sequential operation now receives its competitor index, target generation, attempt seed, player ID, owned-target flag, staging transform and previous settings before operation creation. |

## Engine-fluid API finding

The installed 0.38.6 source exposes combustion engine thermal evidence under
`powertrain.getDevicesByType("combustionEngine")` and
`engine.thermals.debugData.engineThermalData`. The source spells the minimum
field `miniumSafeOilMass` in the relevant thermal implementation. No supported
public runtime oil-mass setter was found. The implementation therefore does not
invent one: it prevents unsafe exposed tuning values, verifies the actual VM
state, and fails into verified recovery when unsafe. A full reload/reset of a
safe accepted configuration is the supported restoration boundary.

Relevant official documentation:

- [BeamNG Lua virtual machines](https://documentation.beamng.com/modding/programming/virtualmachines/)
- [BeamNG logging](https://documentation.beamng.com/beamng_tech/tools/logging/)
- [JBeam debug tools](https://documentation.beamng.com/modding/vehicle/intro_jbeam/debugtools/)

## Result semantics

`finishOperation` now records one of `success`, `partial_success`,
`success_with_critical_repair`, `cancelled`, `preserved_previous_result`,
`full_rollback`, or `failed`. An accepted partial is eligible to become the
last accepted generated result. Full rollback remains the final bounded path
after surgical repair cannot produce coherent functional evidence.
