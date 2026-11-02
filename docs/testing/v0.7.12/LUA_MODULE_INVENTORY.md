# Lua module inventory - v0.7.12

Measured on the v0.7.12 tree with a static analyzer (require graph, `M.x =` exports and
whole-repository name search over Lua, Vue/JS and tests). `prod`/`tests` count direct
`require` consumers; main.lua's public functions are reached by name through
`uiCommandHandlers` and the extension table, so its "unreferenced" exports are UI
commands and the public console API, not dead code. Grep alone never proved deadness:
every removal below was also checked for dynamic lookups, hooks, Vehicle Lua strings
and persisted data.

Classification: KEEP (single clear responsibility, used), MERGE/MERGED, REMOVE/REMOVED,
REFACTOR (kept, but carries tracked structural debt). No module was merged into
main.lua: it sits at Lua's 200 top-level locals limit and owns no pure logic worth adding.

| Module | Lines | prod | tests | Responsibility | Decision | Evidence |
| --- | ---: | ---: | ---: | --- | --- | --- |
| `adaptivePolling.lua` | 58 | 1 | 2 | fast/slow poll cadence for AI supervision | KEEP | required by 1 production module(s) |
| `aiAdapter.lua` | 192 | 1 | 1 | Vehicle Lua AI commands, mode probe, path recorder commands | KEEP | required by 1 production module(s); 174 -> 192 lines |
| `aiDirector.lua` | 168 | 1 | 1 | per-vehicle AI assignment, status, stuck/arrival observation | KEEP | required by 1 production module(s); 154 -> 168 lines |
| `aiModeConfirmation.lua` | 52 | 1 | 1 | expected vs observed Vehicle Lua ai.mode state machine | KEEP | fixed: real ai.mode mapping; dead unavailable() removed; 56 -> 52 lines |
| `apiAdapter.lua` | 1596 | 3 | 1 | GE API boundary: vehicle data, part manager, storage, occupancy | REFACTOR | ~1.6k lines mixing vehicle data, storage and DNA I/O; split by boundary later; 1530 -> 1596 lines |
| `baselineSemantics.lua` | 103 | 1 | 1 | baseline vs mutation comparison rules | KEEP | required by 1 production module(s) |
| `candidateIsolation.lua` | 68 | 1 | 1 | split failing part batches into smaller groups | KEEP | required by 1 production module(s) |
| `capabilities.lua` | 95 | 1 | 1 | derive capability states from raw API presence | KEEP | required by 1 production module(s) |
| `coherentStateGate.lua` | 140 | 1 | 1 | accept a readback only when all sources agree | KEEP | required by 1 production module(s) |
| `compatibility.lua` | 67 | 1 | 1 | running build vs declared target/minimum | KEEP | required by 1 production module(s) |
| `configSelector.lua` | 40 | 1 | 1 | anti-repeat deterministic pick of models and configurations | MERGED | absorbed vehicleSelector.lua (same algorithm) in 0.7.12; 24 -> 40 lines |
| `configVerification.lua` | 165 | 10 | 2 | config path identity and signatures | KEEP | required by 10 production module(s) |
| `contentIndex.lua` | 593 | 1 | 3 | official/mod/user/Automation classification and pools | KEEP | required by 1 production module(s); 595 -> 593 lines |
| `coverageContext.lua` | 36 | 3 | 0 | operation/generation binding shared by coverage ledgers | KEEP | required by 3 production module(s) |
| `coverageLimits.lua` | 69 | 1 | 1 | hard stops for passes, nodes, route length | KEEP | required by 1 production module(s) |
| `crc32.lua` | 37 | 3 | 1 | CRC32 for DNA packages and PNG checks | KEEP | required by 3 production module(s) |
| `criticalRepair.lua` | 95 | 1 | 1 | restore critical slots after a failed pass | KEEP | required by 1 production module(s) |
| `destinationMarker.lua` | 83 | 1 | 1 | AI destination marker draw/state | KEEP | required by 1 production module(s) |
| `diagnostics.lua` | 142 | 1 | 2 | bounded diagnostic records and log levels | KEEP | required by 1 production module(s) |
| `dimensionCache.lua` | 179 | 1 | 1 | cached vehicle bounding dimensions by generation | KEEP | required by 1 production module(s) |
| `energyStorageGuard.lua` | 216 | 1 | 1 | fuel/battery floor checks after mutation | KEEP | required by 1 production module(s) |
| `engineFluidGuard.lua` | 172 | 1 | 1 | oil/coolant evidence evaluation | KEEP | required by 1 production module(s) |
| `failureAttribution.lua` | 13 | 1 | 1 | map a failing phase to the item to blame | KEEP | required by 1 production module(s) |
| `formationEnum.lua` | 38 | 4 | 1 | formation codes and runtime names | KEEP | required by 4 production module(s) |
| `frameBudget.lua` | 91 | 2 | 1 | per-frame work budget | KEEP | required by 2 production module(s) |
| `history.lua` | 60 | 1 | 1 | bounded Undo history | KEEP | required by 1 production module(s) |
| `historyTransaction.lua` | 33 | 1 | 1 | commit/rollback of the Undo entry for one operation | KEEP | required by 1 production module(s) |
| `incrementalIndexer.lua` | 89 | 1 | 1 | time-sliced content index rebuild | KEEP | required by 1 production module(s) |
| `lifecycle.lua` | 92 | 1 | 1 | operation wait reasons and phase lifecycle | KEEP | required by 1 production module(s) |
| `lineupPersistence.lua` | 116 | 1 | 1 | saved lineup library storage | KEEP | required by 1 production module(s) |
| `lineupSchema.lua` | 194 | 3 | 1 | lineup schema validation and statuses | KEEP | required by 3 production module(s) |
| `main.lua` | 9969 | 1 | 0 | extension entry: runtime state, operations, UI handlers, hooks | REFACTOR | ~9.9k lines at the 200-local limit; decomposition stays tracked debt (ROADMAP v0.8.0); 9862 -> 9969 lines |
| `managedVehicleRegistry.lua` | 320 | 3 | 1 | Race-owned vehicle handles, generations, readiness | KEEP | required by 3 production module(s) |
| `mutationEngine.lua` | 226 | 2 | 3 | part tree mutation planning | KEEP | required by 2 production module(s) |
| `mutationPolicy.lua` | 49 | 2 | 3 | Balanced / Maximum Chaos policy from settings | KEEP | required by 2 production module(s) |
| `operationOutcome.lua` | 174 | 1 | 1 | terminal outcome and confidence axes | KEEP | required by 1 production module(s) |
| `operationState.lua` | 335 | 1 | 1 | operation state machine and transitions | KEEP | required by 1 production module(s); 336 -> 335 lines |
| `paintCoverageLedger.lua` | 114 | 1 | 1 | paint coverage accounting | KEEP | required by 1 production module(s) |
| `paintRandomizer.lua` | 76 | 1 | 1 | seeded paint generation | KEEP | required by 1 production module(s) |
| `paintVerification.lua` | 143 | 4 | 1 | paint normalisation and readback comparison | KEEP | required by 4 production module(s); 144 -> 143 lines |
| `partBatchRecovery.lua` | 151 | 1 | 1 | batch rollback bookkeeping | KEEP | required by 1 production module(s) |
| `pathIdentity.lua` | 55 | 2 | 1 | normalised slot/part path identity | KEEP | required by 2 production module(s) |
| `performanceMetrics.lua` | 181 | 1 | 1 | opt-in timing telemetry | KEEP | required by 1 production module(s) |
| `pngValidator.lua` | 88 | 1 | 1 | thumbnail PNG validation | KEEP | required by 1 production module(s) |
| `progressWatchdog.lua` | 273 | 1 | 1 | stall/pause detection for operations | KEEP | required by 1 production module(s) |
| `raceAttemptCoordinator.lua` | 183 | 1 | 1 | Race retry attempts and generations | KEEP | required by 1 production module(s) |
| `raceFocusGuard.lua` | 29 | 1 | 1 | return focus to the player after background work | KEEP | required by 1 production module(s) |
| `raceFormationFrame.lua` | 77 | 1 | 1 | formation origin/heading frame | KEEP | required by 1 production module(s) |
| `raceManager.lua` | 1058 | 2 | 1 | lineup lifecycle, slots, cleanup classification | KEEP | required by 2 production module(s) |
| `racePlacement.lua` | 136 | 1 | 1 | one-click reposition of existing Race cars | KEEP | required by 1 production module(s) |
| `racePreview.lua` | 350 | 1 | 1 | formation preview data and render state | KEEP | required by 1 production module(s) |
| `racePreviewRenderer.lua` | 161 | 2 | 1 | debugDrawer preview drawing and binding probe | KEEP | required by 2 production module(s) |
| `raceScheduler.lua` | 94 | 1 | 1 | bounded slot scheduler progress audit | KEEP | required by 1 production module(s) |
| `registryCache.lua` | 104 | 1 | 2 | persisted catalog cache | KEEP | required by 1 production module(s) |
| `registryReadiness.lua` | 84 | 1 | 1 | vehicle registry readiness backoff | KEEP | required by 1 production module(s) |
| `rng.lua` | 127 | 3 | 3 | seeded RNG with named substreams | KEEP | required by 3 production module(s); 128 -> 127 lines |
| `routePlanner.lua` | 97 | 1 | 1 | NavGraph destination/route planning | KEEP | required by 1 production module(s) |
| `runtime/cooperativeScheduler.lua` | 106 | 1 | 1 | cooperative time-sliced jobs | KEEP | required by 1 production module(s) |
| `runtime/domainOperations.lua` | 869 | 1 | 1 | operation ownership, callbacks, cleanup authority | KEEP | required by 1 production module(s); 895 -> 869 lines |
| `runtime/operationContext.lua` | 387 | 1 | 1 | per-operation candidate and target binding | KEEP | required by 1 production module(s) |
| `runtime/safetyModel.lua` | 131 | 1 | 1 | VALID / INVALID_CONFIRMED / UNKNOWN classification | KEEP | required by 1 production module(s) |
| `runtime/stabilityLimits.lua` | 70 | 1 | 1 | operation timeouts and wall-clock limits | KEEP | required by 1 production module(s); 78 -> 70 lines |
| `safetyGate.lua` | 94 | 1 | 1 | accept/reject a result by safety evidence | KEEP | required by 1 production module(s) |
| `settings.lua` | 141 | 1 | 1 | settings defaults, validation, migration | KEEP | required by 1 production module(s) |
| `slotCoverageLedger.lua` | 220 | 1 | 1 | slot coverage accounting | KEEP | required by 1 production module(s) |
| `slotScanner.lua` | 123 | 1 | 3 | flatten slot tree with metadata | KEEP | required by 1 production module(s) |
| `spawnApiAdapter.lua` | 338 | 2 | 1 | spawn/teleport/delete/dimension boundary | KEEP | required by 2 production module(s); 323 -> 338 lines |
| `spawnDirector.lua` | 473 | 1 | 2 | formation planning and placement | KEEP | required by 1 production module(s) |
| `spawnOutcome.lua` | 141 | 2 | 1 | spawn transaction identity resolution | KEEP | required by 2 production module(s) |
| `stressRunner.lua` | 105 | 1 | 1 | developer stress diagnostics | KEEP | required by 1 production module(s) |
| `timeSource.lua` | 129 | 1 | 1 | real/sim time and pause sampling | KEEP | required by 1 production module(s) |
| `transactionalJSON.lua` | 62 | 1 | 1 | write-verify-backup JSON storage | KEEP | required by 1 production module(s) |
| `treeConvergence.lua` | 51 | 1 | 1 | detect parts tree convergence | KEEP | required by 1 production module(s) |
| `tuningCoverageLedger.lua` | 194 | 2 | 1 | tuning coverage accounting | KEEP | required by 2 production module(s) |
| `tuningPipeline.lua` | 196 | 1 | 1 | tuning plan and verification | KEEP | required by 1 production module(s) |
| `uiCommandRouter.lua` | 72 | 1 | 1 | allow-listed UI command dispatch with replay cache | KEEP | required by 1 production module(s) |
| `uiPreferences.lua` | 140 | 2 | 1 | persisted UI preferences | KEEP | required by 2 production module(s) |
| `uiProtocol.lua` | 114 | 3 | 1 | UI envelope/command validation | KEEP | required by 3 production module(s); 115 -> 114 lines |
| `uiPublisher.lua` | 94 | 1 | 2 | dirty-section UI publishing | KEEP | required by 1 production module(s); 100 -> 94 lines |
| `uiStateProjector.lua` | 33 | 1 | 1 | full/diff UI envelopes | KEEP | required by 1 production module(s) |
| `userDataMigration.lua` | 35 | 1 | 1 | migration report records | KEEP | required by 1 production module(s) |
| `util.lua` | 124 | 78 | 2 | shared pure helpers | KEEP | required by 78 production module(s); 131 -> 124 lines |
| `validator.lua` | 527 | 3 | 1 | functional evidence and critical-slot validation | KEEP | required by 3 production module(s); 543 -> 527 lines |
| `vehicleBufferPool.lua` | 64 | 1 | 2 | reused buffers for world vehicle scans | KEEP | required by 1 production module(s) |
| `vehicleDNA.lua` | 140 | 1 | 1 | DNA capture model | KEEP | required by 1 production module(s) |
| `vehicleDNACompare.lua` | 91 | 1 | 1 | field-by-field DNA diff | KEEP | required by 1 production module(s) |
| `vehicleDNACompatibility.lua` | 249 | 2 | 1 | local content compatibility of a DNA | KEEP | required by 2 production module(s) |
| `vehicleDNAFingerprint.lua` | 109 | 7 | 1 | DNA fingerprints | KEEP | required by 7 production module(s) |
| `vehicleDNAGallery.lua` | 71 | 4 | 1 | garage gallery projection | KEEP | required by 4 production module(s) |
| `vehicleDNAImport.lua` | 64 | 1 | 1 | bounded DNA JSON import | KEEP | required by 1 production module(s) |
| `vehicleDNALocks.lua` | 372 | 3 | 1 | lock profiles | KEEP | required by 3 production module(s) |
| `vehicleDNAMutations.lua` | 68 | 1 | 1 | DNA mutation strengths | KEEP | required by 1 production module(s) |
| `vehicleDNANormalizer.lua` | 72 | 2 | 1 | DNA normalisation | KEEP | required by 2 production module(s) |
| `vehicleDNAPackage.lua` | 235 | 1 | 1 | DNA zip packages | KEEP | required by 1 production module(s); 236 -> 235 lines |
| `vehicleDNAPassBudget.lua` | 52 | 1 | 1 | restore pass budget | KEEP | required by 1 production module(s) |
| `vehicleDNARestore.lua` | 106 | 1 | 1 | restore planning | KEEP | required by 1 production module(s) |
| `vehicleDNASchema.lua` | 225 | 6 | 1 | DNA schema and limits | KEEP | required by 6 production module(s) |
| `vehicleDNAStorage.lua` | 318 | 1 | 2 | DNA library storage | KEEP | required by 1 production module(s); 323 -> 318 lines |
| `vehicleIdentity.lua` | 53 | 1 | 1 | local/network identity and authority model | KEEP | required by 1 production module(s) |
| `vehicleIterator.lua` | 81 | 2 | 1 | deterministic world vehicle iteration | KEEP | required by 2 production module(s) |
| `vehicleRecovery.lua` | 291 | 1 | 1 | recovery candidate chain | KEEP | required by 1 production module(s) |
| `vehicleStabilizer.lua` | 107 | 2 | 1 | post-spawn stabilisation wait | KEEP | required by 2 production module(s) |
| `vehicleTargetTracker.lua` | 525 | 1 | 1 | target identity tracking across respawns | KEEP | required by 1 production module(s) |
| `lua/ge/extensions/soturineChaosRandomizer.lua` | 2 | 0 | 0 | extension loader shim (BeamNG extension name) | KEEP | required by BeamNG extension naming |
| `lua/vehicle/extensions/soturineChaosRandomizerFluidProbe.lua` | 56 | 0 | 0 | Vehicle Lua engine-fluid probe | KEEP | entry point |
| `lua/vehicle/extensions/soturineChaosRandomizerPathRecorder.lua` | 58 | 0 | 0 | Vehicle Lua path recorder (new in 0.7.12) | KEEP | new: Recorded route contract |
| `vehicleSelector.lua` | 19 -> 0 | - | - | - | MERGED | duplicate of configSelector's anti-repeat pick |

Totals: 106 modules / 27928 lines before (v0.7.11), 106 modules / 28124 lines after. Line counts include
the new split-screen guards, AI mode probe and Recorded route; the reduction is in
dead or duplicated code, not in features.
