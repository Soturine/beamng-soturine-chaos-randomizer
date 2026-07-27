# Feature Audit 0.6.2

This is the public-surface audit for the final v0.6.2 source. “Automated” means a Lua fixture or static contract passed; it is not a live BeamNG gameplay result. Every gameplay/UI row remains **Pending** until it is executed against the exact release ZIP. Internal `lineup*` names are retained only for schema, storage, and API compatibility; the public workflow is **Race Cars → Placement → Drive**.

## Chaos and operation controls

| Feature | Public action | Backend entry point | Dependencies | Automated tests | Interactive status | Known issue | Documentation |
|---|---|---|---|---|---|---|---|
| Random Car | Random Car | `randomConfig`, `runAction("randomConfig")` | Registry, replace/spawn, lifecycle confirmation | `v062_random_car_without_pause`, target/readback and anti-repeat fixtures | Pending | Third-party replacements can still end in an explicit degraded/failure result; live pause independence is unverified | [README](../README.md), [Lifecycle](MOD_VEHICLE_LIFECYCLE.md) |
| Scramble | Scramble | `scramble`, `runAction("scramble")` | Active target, parts read/write; tuning/paint optional | `v062_scramble_without_pause`, `v062_scramble_target_isolation`, R40–R45 | Pending | Requires a readable active vehicle; persistent nil parts terminates rather than guessing | [README](../README.md), [Full Coverage](FULL_COVERAGE.md) |
| Full Random | Full Random | `fullRandom`, `runAction("fullRandom")` | Random Car capabilities plus Scramble pipeline | `v062_full_random_without_pause`, `v062_full_random_target_isolation`, R40–R45 | Pending | Complete unpaused live pipeline has not been exercised | [README](../README.md), [Lifecycle](MOD_VEHICLE_LIFECYCLE.md) |
| Undo | Undo | `undo`, `runAction("undo")` | Session history and target-bound replace/write APIs | Existing history/rollback fixtures | Pending | Bounded to project-owned session history; failed rollback may retain diagnostic history | [Architecture](ARCHITECTURE.md) |
| Cancel | Cancel safely | `cancelCurrentOperation` | Housekeeping update and active operation token | `v062_cancel_target_tracking`, `v062_cancel_parts_reload`, `v062_busy_all_terminals` | Pending | Cannot make a third-party callback arrive; it must terminate safely and report the reason | [Lifecycle](MOD_VEHICLE_LIFECYCLE.md), [Troubleshooting](TROUBLESHOOTING.md) |
| Diagnostics | Details / Copy diagnostics | `requestState`, `copyDiagnostics` | UI events; clipboard is optional | `v062_diagnostics_available`, instrumentation/reason-code fixtures | Pending | Clipboard may degrade to a prepared payload; personal paths are redacted | [Troubleshooting](TROUBLESHOOTING.md) |
| Recovery action | Spawn safe vehicle | `spawnSafeVehicle` | Official registry candidate and replace/spawn | Recovery-tier and fallback fixtures | Pending | Best-effort fallback, not a repair for broken third-party content | [Lifecycle](MOD_VEHICLE_LIFECYCLE.md) |
| Quarantine action | Retry quarantined configurations | `retryQuarantinedConfigurations` | Session recovery/quarantine store | `v062_failed_candidate_quarantine` | Pending | Clears only project session quarantine; it does not modify installed mods | [Troubleshooting](TROUBLESHOOTING.md) |

## Settings, locks, and developer controls

| Feature | Public action | Backend entry point | Dependencies | Automated tests | Interactive status | Known issue | Documentation |
|---|---|---|---|---|---|---|---|
| General/Safety/Advanced | Update settings | `updateSettings` | Settings validation and optional persistence | `v062_safety_flag_mapping`, settings migration suite | Pending | Capability availability can override a requested optional stage | [README](../README.md), [Safety](SAFETY_MODEL.md) |
| Seed | Random/fixed mode; clear fixed seed | `updateSettings` | Generator 6 `SCR6` seed parser and entropy boundary | `v062_random_seed_changes`, `v062_fixed_seed_reproduces`, `v062_clear_seed` | Pending | Fixed output also depends on content, settings, starting state, and generator version | [README](../README.md), [Replay](REPLAY_SEMANTICS.md) |
| Lock profile | Apply complete lock profile | `updateLockProfile`, `getVehicleDNALocks` | Lock schema/profile v2 | R69–R73 and lock suite | Pending | Persistence is opt-in and old profiles are not silently activated | [Locks](LOCKS.md) |
| Vehicle/config locks | Lock vehicle / configuration | `lockVehicle`, `lockConfiguration` | Current target/base identity | Lock preflight and compatibility fixtures | Pending | Model-bound locks restrict eligible selection; unavailable target disables them | [Locks](LOCKS.md) |
| Part locks | Lock category/slot/part/current parts; unlock slot | `lockCategory`, `lockSlot`, `unlockSlot`, `lockPart`, `lockCurrentParts` | Fresh tree and normalized slot paths | Lock resolution, stale-path, and hierarchy fixtures | Pending | Missing/ambiguous paths are reported, never remapped by name alone | [Locks](LOCKS.md) |
| Tuning/paint locks | Lock tuning / paint | `lockTuning`, `lockPaint` | Public tuning metadata and supported paint fields | Lock-domain/substream fixtures | Pending | Unsupported fields remain unavailable rather than simulated | [Locks](LOCKS.md) |
| Presets/reroll | Apply preset / Reroll unlocked | `applyLockPreset`, `rerollUnlocked` | Current lock profile, selected DNA/current target | `v062_reroll_target_isolation`, mutation/lock suite | Pending | Reroll first restores and verifies its parent; live restore remains Pending | [Locks](LOCKS.md), [Mutations](MUTATIONS.md) |
| UI mode | Collapse / expand | `setUICompactMode` | BeamNG UI App resize bridge | R75–R90 static contracts | Pending | Rendering at required DPI/scales needs screenshots | [UI Design](UI_DESIGN.md) |
| Reindex | Reindex Content | `reindex`, `runAction("reindex")` | Mounted vehicle registry | Content-index and failure-store fixtures | Pending | Clears session blacklists/suspects and may be expensive on large mod sets | [README](../README.md) |
| Developer stress | Start / cancel / inspect stress | `runDeveloperStress`, `cancelDeveloperStress`, `getDeveloperStressState` | Developer mode; ordinary serialized pipeline | Stress bounds/cancellation fixtures | Pending | Hidden from normal UI and not a substitute for live test execution | [Testing](TESTING.md) |

## Race Cars and Placement

| Feature | Public action | Backend entry point | Dependencies | Automated tests | Interactive status | Known issue | Documentation |
|---|---|---|---|---|---|---|---|
| Race generation | Generate Cars | `createChaosLineup` | Full Random pipeline, race storage/checkpoint | R04, R46–R53 | Pending | Live 2/4-car terminal behavior is unverified | [Race](RACE.md) |
| Race metadata | Rename competitor | `renameLineupCompetitor` | Current race state | Race schema/storage fixtures | Pending | Display-only; does not mutate DNA | [Race](RACE.md) |
| Race failure decision | Retry / Fallback / Skip / Stop | `resolveLineupFailure` | Terminal/non-terminal competitor state | R50–R53 | Pending | Fallback is explicit and bounded; no automatic infinite retry | [Race](RACE.md) |
| Race transfer | Export / Import race data | `exportChaosLineup`, `importChaosLineup` | Data-only legacy-compatible race schema/storage | Schema/import/export fixtures and X07 | Pending | Internal `.lineup.json` compatibility name remains | [Race](RACE.md), [Compatibility](COMPATIBILITY.md) |
| Placement preview | Preview | `previewLineupSpawn` | Ready competitor/DNA, raycast/custom point and heading capabilities | Placement transform/safety fixtures, R54 | Pending | Visual marker/raycast behavior needs live verification | [Spawn Director](SPAWN_DIRECTOR.md) |
| Placement spawn | Spawn one / next / all | `startLineupSpawn` | Ready input, one-at-a-time spawn, coherent readback | Ownership/generation/spawn fixtures, R54/R58 | Pending | Modded ID changes may degrade or terminate explicitly | [Spawn Director](SPAWN_DIRECTOR.md) |
| Placement cancellation | Cancel placement | `cancelLineupSpawn` | Active placement token | Cancellation/terminal-state fixtures | Pending | Already verified spawned cars remain; unverified one becomes DNS/Failed | [Spawn Director](SPAWN_DIRECTOR.md) |
| Managed vehicle removal | Remove managed car | `removeManagedVehicle` | Confirmed managed handle/generation | Isolated removal fixtures | Pending | Removes only the selected managed handle | [Spawn Director](SPAWN_DIRECTOR.md) |
| Managed vehicle recovery | Respawn / Respawn damaged | `respawnManagedVehicle` | Saved DNA and managed ownership | Respawn/rebind/stale-generation fixtures | Pending | Generic damage thresholds are not inferred | [Spawn Director](SPAWN_DIRECTOR.md), [AI Director](AI_DIRECTOR.md) |

## Drive / AI Director

| Feature | Public action | Backend entry point | Dependencies | Automated tests | Interactive status | Known issue | Documentation |
|---|---|---|---|---|---|---|---|
| Destination | Place / confirm / clear destination | `placeAIDestination`, `confirmAIDestination`, `clearAIDestination` | Raycast marker and reachable NavGraph | Destination/path/no-path fixtures | Pending | Unreachable or missing NavGraph disables the action with a reason | [AI Director](AI_DIRECTOR.md), [NavGraph](NAVGRAPH_AND_ROUTES.md) |
| Route | Add/edit route points | `addAIRoutePoint`, `editAIRoute` | NavGraph and route planner | Route editing/loop/reverse/clear fixtures | Pending | Visual GPS is not proof of a reachable NavGraph path | [NavGraph](NAVGRAPH_AND_ROUTES.md) |
| AI start | Start all | `startManagedAI` | Confirmed managed targets plus selected mode capability | `v062_start_stop_ai`, AI scheduling/isolation fixtures | Pending | Actual driving, traffic, arrival, and collision recovery remain unverified | [AI Director](AI_DIRECTOR.md) |
| AI group control | Pause / resume / stop / reset all | `pauseManagedAI`, `resumeManagedAI`, `stopManagedAI`, `resetManagedAI` | Managed registry and Vehicle Lua command boundary | Group-control/cleanup fixtures | Pending | “Pause” is an AI command, not a simulation pause toggle | [AI Director](AI_DIRECTOR.md) |
| AI recording | Start / stop recording | `setAIRecording` | Audited Vehicle Lua recording commands | Capability/command fixtures | Pending | Recording does not make Recorded/Scripted playback supported | [AI Director](AI_DIRECTOR.md) |

## Garage, Vehicle DNA, Compare, and Share

| Feature | Public action | Backend entry point | Dependencies | Automated tests | Interactive status | Known issue | Documentation |
|---|---|---|---|---|---|---|---|
| Save | Save Vehicle DNA | `saveVehicleDNA` | Clean terminal readback and DNA storage | `v062_save_dna`, schema/storage/fingerprint suite | Pending | Never automatic; unavailable after an unverified result | [Vehicle DNA](VEHICLE_DNA.md) |
| Browse | Page/filter/sort library | `setVehicleDNAPage`, `setVehicleDNAQuery` | Bounded DNA storage | Pagination/query/storage limits | Pending | Public state exposes summaries, not full entries | [Vehicle DNA](VEHICLE_DNA.md) |
| Delete/duplicate | Delete / Duplicate | `deleteVehicleDNA`, `duplicateVehicleDNA` | Writable DNA storage | Storage mutation/limit fixtures | Pending | Delete requires UI confirmation; duplicate gets a new ID | [Vehicle DNA](VEHICLE_DNA.md) |
| Rename/classify | Rename, favorite, pin, rate, tags, collection, notes | `renameVehicleDNA`, `setVehicleDNAFavorite`, `setVehicleDNAPinned`, `setVehicleDNARating`, `setVehicleDNATags`, `setVehicleDNACollection`, `setVehicleDNANotes` | Writable DNA storage and bounded metadata | Metadata normalization/storage fixtures | Pending | Metadata does not change final-state fingerprints | [Vehicle DNA](VEHICLE_DNA.md), [Gallery](GALLERY.md) |
| Details | Open details | `getVehicleDNADetails` | DNA read capability | Bounded-details fixture/static bridge test | Pending | Full data is emitted only on explicit request | [Vehicle DNA](VEHICLE_DNA.md) |
| Compare | Compare selected entries | `compareVehicleDNA` | Two stored valid entries | `v062_compare_dna`, compare limits/fields suite | Pending | Reports stored fields; it is not live vehicle-byte equivalence | [Vehicle DNA](VEHICLE_DNA.md) |
| Text import/export | Import pasted JSON / Prepare JSON | `importVehicleDNA`, `exportVehicleDNA`, `exportVehicleDNAJson` | JSON parse, schema, bounded UI bridge | R62/R63 plus injection/size/schema fixtures | Pending | Export-file support is independent of inert JSON preparation | [Sharing](SHARING.md) |
| Package share | Export package / validate and confirm import | `exportVehicleDNAPackage`, `importVehicleDNAPackage`, `confirmVehicleDNAPackageImport` | Controlled inbox/export path, package and schema validation | `v062_share_dna`, package/ZIP/CRC/hash fixtures | Pending | No network transport; imported compatibility is recomputed locally | [Sharing](SHARING.md) |
| Thumbnail | Capture / remove thumbnail | `captureVehicleDNAThumbnail`, `removeVehicleDNAThumbnail` | Screenshot and controlled-file capabilities | PNG/path/size/fallback fixtures | Pending | Capability may be degraded or unavailable; visual quality is unverified | [Gallery](GALLERY.md) |
| Preflight | Compatibility preflight | `preflightVehicleDNA` | Mounted registry and target inspection | Compatibility/resolution fixtures | Pending | A different model may require target inspection before a final report | [Compatibility](COMPATIBILITY.md) |
| Exact restore | Restore exact | `restoreVehicleDNA` | Preflight, target-bound full pipeline and rollback | `v062_restore_snapshot`, restore/readback suite | Pending | All fields must match or the transaction fails/rolls back | [Vehicle DNA](VEHICLE_DNA.md) |
| Compatible restore | Restore compatible | `restoreVehicleDNA` | Same plus explicit partial authorization | Compatibility/deviation/rollback suite | Pending | Never chooses a random substitute; omissions are explicit | [Vehicle DNA](VEHICLE_DNA.md) |
| Replay | Replay saved result | `replayVehicleDNA` | Supported schema/generator and target-bound restore | Replay/fingerprint/compatibility suite | Pending | Old generators remain restorable but are not reinterpreted as generator 6 | [Replay](REPLAY_SEMANTICS.md) |
| Replay generation | Replay generation / Pure seed replay | `replayVehicleDNAGeneration`, `pureSeedReplayVehicleDNA` | Generator compatibility, saved or current policy | `v062_replay_generation`, deterministic seed/substream suite | Pending | Pure seed replay can reselect the base and varies with environment | [Replay](REPLAY_SEMANTICS.md) |
| Mutations | Small / Medium / Wild | `mutateVehicleDNA` | Verified parent, locks, derived mutation domains | `v062_dna_lineage`, `v062_mutation_target_isolation` | Pending | Wild can change model only when model-bound locks permit | [Mutations](MUTATIONS.md) |

## Adapters, capabilities, and runtime hooks

| Feature | Public action | Backend entry point | Dependencies | Automated tests | Interactive status | Known issue | Documentation |
|---|---|---|---|---|---|---|---|
| Vehicle adapter | Indirect through Chaos/Garage | `apiAdapter` | BeamNG registry, exact-ID state reads, replace/parts/tuning/paint APIs | Target-coherence, nil-parts, write-precondition and readback fixtures | Pending | BeamNG internal APIs can change between builds; target is 0.38.6.0.19963 | [Research](RESEARCH_NOTES_0.6.2.md), [Architecture](ARCHITECTURE.md) |
| Placement adapter | Indirect through Placement | `spawnApiAdapter` | Raycast, world transforms, spawn and object enumeration | Transform/raycast/ownership fixtures | Pending | Visual preview and mod ID churn require live testing | [Spawn Director](SPAWN_DIRECTOR.md) |
| AI adapter | Indirect through Drive | `aiAdapter` | Vehicle Lua queue and NavGraph APIs | Command allowlist, path and capability fixtures | Pending | Scripted/Recorded playback is explicitly unsupported | [AI Director](AI_DIRECTOR.md) |
| Capability model | Disabled-control explanations | `capabilities` | Runtime API inspection | `v062_capability_explanation`, `v062_degraded_capability_disables_action` | Pending | Availability is build/map/vehicle-specific | [Compatibility](COMPATIBILITY.md) |
| Extension lifecycle | Load/update/unload/map/mod/vehicle events | `onExtensionLoaded`, `onUpdate`, `onClientEndMission`, `onExtensionUnloaded`, `onModActivated`, `onModDeactivated`, `onVehicleSpawned`, `onVehicleSwitched`, `onVehicleDestroyed` | GE extension lifecycle | R07–R18, R91–R94 | Pending | Callback ordering is evidence only; live third-party behavior is unverified | [Lifecycle](MOD_VEHICLE_LIFECYCLE.md) |

## Audit result

All named public entry points exported by `main.lua` are covered above. Automated fixtures and static contracts pass for the implementation surface; the audited gameplay/UI status is **partial (implemented and automated, live Pending)** rather than “functional”. No row is Failed or Blocked by current v0.6.2 execution evidence because no v0.6.2 live execution occurred. Historical v0.6.1 failures remain in the separate [v0.6.1 report](INTERACTIVE_TEST_REPORT_0.6.1.md).

The mechanically checked export inventory is:

`runAction`, `randomConfig`, `scramble`, `fullRandom`, `undo`, `reindex`, `updateSettings`, `updateLockProfile`, `getVehicleDNALocks`, `lockVehicle`, `lockConfiguration`, `lockCategory`, `lockSlot`, `unlockSlot`, `lockPart`, `lockCurrentParts`, `lockTuning`, `lockPaint`, `applyLockPreset`, `rerollUnlocked`, `requestState`, `setUICompactMode`, `copyDiagnostics`, `spawnSafeVehicle`, `retryQuarantinedConfigurations`, `runDeveloperStress`, `cancelDeveloperStress`, `cancelCurrentOperation`, `getDeveloperStressState`.

`createChaosLineup`, `renameLineupCompetitor`, `resolveLineupFailure`, `exportChaosLineup`, `importChaosLineup`, `previewLineupSpawn`, `startLineupSpawn`, `cancelLineupSpawn`, `removeManagedVehicle`, `respawnManagedVehicle`, `placeAIDestination`, `confirmAIDestination`, `clearAIDestination`, `addAIRoutePoint`, `editAIRoute`, `startManagedAI`, `pauseManagedAI`, `resumeManagedAI`, `stopManagedAI`, `resetManagedAI`, `setAIRecording`.

`saveVehicleDNA`, `setVehicleDNAPage`, `deleteVehicleDNA`, `renameVehicleDNA`, `setVehicleDNAFavorite`, `setVehicleDNAPinned`, `setVehicleDNARating`, `setVehicleDNATags`, `setVehicleDNACollection`, `setVehicleDNANotes`, `duplicateVehicleDNA`, `setVehicleDNAQuery`, `getVehicleDNADetails`, `compareVehicleDNA`, `importVehicleDNA`, `exportVehicleDNA`, `exportVehicleDNAJson`, `exportVehicleDNAPackage`, `importVehicleDNAPackage`, `confirmVehicleDNAPackageImport`, `captureVehicleDNAThumbnail`, `removeVehicleDNAThumbnail`, `preflightVehicleDNA`, `replayVehicleDNA`, `replayVehicleDNAGeneration`, `pureSeedReplayVehicleDNA`, `mutateVehicleDNA`, `restoreVehicleDNA`.

`onExtensionLoaded`, `onVehicleSpawned`, `onVehicleSwitched`, `onVehicleDestroyed`, `onClientEndMission`, `onModActivated`, `onModDeactivated`, `onUpdate`, `onExtensionUnloaded`.
