# Architecture

Soturine's Chaos Randomizer is a GE Lua extension with a compact AngularJS UI App. BeamNG-internal calls stay in `apiAdapter.lua`; deterministic logic and fixtures run without the game environment.

## Package boundary

```text
lua/ge/extensions/soturineChaosRandomizer.lua
lua/ge/extensions/soturineChaosRandomizer/*.lua
ui/modules/apps/soturineChaosRandomizer/*
settings/soturineChaosRandomizer/defaults.json
LICENSE
NOTICE
VERSION
```

Repository documentation, tools, tests, workflows, and fixtures do not enter the mod ZIP.

## Modules

| Module | Responsibility |
| --- | --- |
| `main.lua` | Public API, state-machine orchestration, failure attribution, rollback, lifecycle routing, stress scheduling |
| `apiAdapter.lua` | Only boundary for BeamNG registry, vehicle, JBeam, parts, tuning, paint, VFS, log, and UI calls |
| `capabilities.lua` | Derive actions and user-visible warnings from granular API capabilities |
| `lifecycle.lua` | Phase-specific wait expectations and post-event state verification |
| `vehicleTargetTracker.lua` / `vehicleStabilizer.lua` | Bounded multi-candidate target binding, rebind, player polling, stable-frame/scan proof |
| `partBatchRecovery.lua` / `vehicleRecovery.lua` | Localized part rollback/quarantine and failed-load recovery ladder/circuit breaker |
| `configVerification.lua` | Layered model/path/registry/signature configuration identity proof |
| `contentIndex.lua` | Normalize mounted registry content, evidence-based source/type classes, filters, separated session blacklists |
| `slotScanner.lua` | Copy/flatten hierarchical trees, stable depth/path/ID order, signatures, changed paths |
| `mutationEngine.lua` | Plan one coherent compatible-parts batch and defer descendants of changed ancestors |
| `validator.lua` | Evidence graph, dynamic safety profiles, required/core and baseline-role validation |
| `tuningRandomizer.lua` | Normalize variables, independent sampling, explicit-group sampling, clamp, quantize |
| `paintRandomizer.lua` | Generate bounded paint layers from the current paint count |
| `paintVerification.lua` | Normalize supported paint fields and drive bounded tolerant read-back |
| `history.lua` / `historyTransaction.lua` | Bounded snapshots and the one-time first-write commit point |
| `failureAttribution.lua` | Map an operation phase to the only eligible blacklist namespace |
| `stressRunner.lua` | Validate bounded developer-stress options and aggregate outcomes |
| `operationState.lua` | Busy lock, legal transitions, deadlines, tokens, terminal cleanup |
| `settings.lua` | Defaults, schema migration, validation, persistence-ready state |
| `rng.lua` | Isolated Park-Miller generators, stable seeds, deterministic substreams |
| `vehicleDNA.lua` / `vehicleDNANormalizer.lua` | Create a schema-owned entry from fresh final captures and normalized loaded state |
| `vehicleDNASchema.lua` / `vehicleDNAFingerprint.lua` | Validate schema v1, bounds, field fingerprints, and canonical JSON-safe values |
| `vehicleDNAStorage.lua` / `vehicleDNAImport.lua` | Pure bounded library operations and hostile-input sanitization |
| `vehicleDNACompatibility.lua` | Read-only model/config/slot/tuning/paint/dependency/environment preflight |
| `vehicleDNARestore.lua` | Parent-first compatible/exact restore planning without RNG fallback |
| `vehicleDNAPassBudget.lua` | Depth-derived pass limit, deadline, no-progress, and repeated-state guards |
| `vehicleDNALocks.lua` / `vehicleDNAMutations.lua` | Persisted normalized lock profiles, deterministic strengths/seeds, and bounded lineage |
| `vehicleDNACompare.lua` / `vehicleDNAGallery.lua` | Bounded normalized field comparison and managed/fallback thumbnail policy |
| `vehicleDNAPackage.lua` | Deterministic stored ZIP writer plus fail-closed archive/manifest validation |
| `pngValidator.lua` | Bounded PNG chunk/order/length/CRC and trailing-data validation |
| selectors/policy/diagnostics/util | Pure selection, Chaos policy, structured logs, shared helpers |

## Settings schema

```lua
{
  schemaVersion = 4,
  chaos = 75,
  allowMissingParts = true,
  protectCriticalParts = false,
  contentFilter = "everything",
  includeAutomation = false,
  includeTrailers = false,
  includeProps = false,
  selectionFairness = "vehicle",
  historyLimit = 10,
  diagnosticLogging = false,
  manualSeed = "",
  dnaLibraryLimit = 100,
  autoSaveDNA = false,
  defaultRestoreMode = "exact",
  lockProfile = {kind = "soturineVehicleDNALockProfile", profileVersion = 2}
}
```

Schema 4 retains every schema-1/2/3 migration, maps the temporary `dnaLimit` name to `dnaLibraryLimit`, forces autosave off, bounds the library to 1–100 entries, and normalizes profile-version-2 lock objects. Model-dependent vehicle/configuration/slot/part locks record their bound model and optional bound configuration; unresolved binding blocks creative selection instead of silently dropping the lock.

## Adapter write contracts

Adapter calls use explicit contracts rather than interpreting `pcall` alone as success:

| Write | Synchronous contract | Completion contract |
| --- | --- | --- |
| `replaceVehicle` / spawn | `false` rejects; a returned ID/object is candidate evidence and replacement can begin without a previous active vehicle | callbacks, player-0 polling, model/config/part evidence, then five stable frames and two coherent scans on the final target |
| `setPartsTreeConfig` | installed API normally returns `nil`; `false` rejects | `onVehicleSpawned`, expected path/candidate read-back |
| `setConfigVars` | installed API normally returns `nil`; `false` rejects | `onVehicleSpawned`, expected tuning values read-back |
| `setConfigPaints(..., false)` | installed API normally returns `nil`; `false` rejects | requested-field read-back immediately or through a two-second bounded update retry; no reload event |

Thrown exceptions retain their detail. Phase-specific codes include `vehicle_replace_rejected`, `parts_apply_rejected`, `tuning_apply_rejected`, and `paint_apply_rejected`. A synchronous rejection never waits for the normal timeout.

## Operation and lifecycle model

Version 0.6.0 adds an explicit authoritative lifecycle above the legacy engine
transition names. Phases cover capture, selection, spawn issue, target identity,
simulation-resume wait, tree stabilization, parts plan/write/reload/verify and
isolation, tuning plan/write/reload/verify, paint write/verify, final validation,
cancel, operation rollback, previous/completed-good/official recovery, and
terminal completed/partial/cancelled/failed. `busy` is derived from the current
non-terminal phase.

Every operation owns `operationId`, `operationToken`, `operationGeneration`,
`phaseGeneration`, and `targetGeneration`. Any timer/callback/continuation or
mutation write validates that context plus its expected vehicle ID/model/config
immediately before acting. Cancel, recovery, phase replacement, and new targets
invalidate the relevant generation. Stale work is ignored and counted.

The transaction keeps independent values for `operationOriginalSnapshot`,
`operationCandidateBase`, `operationMutationPlan`, `operationCurrentTarget`,
`operationRecoveryTarget`, `lastReadableSnapshot`, and
`lastCompletedGoodSnapshot`. Recovery deletes the old mutation plan and pending
parts/tuning/paint work, closes ledgers, creates a recovery-only target, and can
never transition back into Scramble. Completed-good is committed only after
successful final validation and Busy release; an original, base spawn,
unaccepted Partial, or recovery-in-progress is not automatically good.

`timeSource.lua` exposes real monotonic time, simulation time, both deltas, raw
delta, frame counter, pause state, and slow-motion ratio. Real deadlines and
polls share the monotonic source. A phase that requires Vehicle-Lua/physics
progress enters `waiting_for_simulation_resume` without a false timeout or
automatic pause change. `progressWatchdog.lua` counts only phase, target, tree,
and confirmed-write evidence. The update scheduler always continues pause
observation, timeout/watchdog, Spawn/AI housekeeping, UI publication, and
recovery bookkeeping while target tracking is active.

The state machine keeps generic engine states (`spawning`, `waitingForVehicle`, `mutating`, `waitingForReload`, and so on), while each active wait carries a specific reason:

```text
waitingForVehicleReplace
waitingForPartsReload
waitingForTuningReload
waitingForRollbackReplace
waitingForUndoReplace
waitingForDNABaseSpawn
waitingForDNAPartsReload
waitingForDNATuningReload
```

An expectation stores operation token, phase, expected hook, original player vehicle, model/config evidence, requested parts/tuning values, and start time. The target tracker treats returned IDs, synchronous/asynchronous callbacks, and player-0 polls as bounded candidates. It can rebind from destroyed/intermediate IDs to the final matching player vehicle; no single callback is success. Model/config/part state must remain coherent for five frames and two scans. Candidate/event limits, stale tokens, and the normal phase timeout prevent indefinite tracking.

Config verification applies layers: exact model, normalized path, model-scoped registry key, minimal loaded-state signature, then explicit failure as `config_identity_unverified`. A registry-only cross-model check can return `target_inspection_required`; the orchestrator loads the saved base within the existing transaction and repeats preflight against the confirmed target before any final claim. Paint confirmation is update-driven, interval-limited, attempt-limited, and does not use `onVehicleSpawned`.

Timeouts report the exact phase. A model/config-consistent internal ID chain continues, while a proven unrelated player switch cancels with a distinct lifecycle reason. Stale tokens and wrong auxiliary candidates are logged and ignored. Transient part-tree gaps are rescanned; persistent absence requires two coherent scans.

## Vehicle DNA transaction

A completed Random Car (`randomConfig`), Scramble, or Full Random result gets a fresh configuration capture and hierarchical scan. Only after normalization, schema validation, and fingerprint generation does `runtime.dna.pending` expose an explicit save. The pending entry is session-only; autosave is always false.

The selected persistence design is one bounded store because installed-source evidence proves JSON read/write and the helper's temp/rename mode, but not a complete portable directory/listing transaction:

```text
/settings/soturineChaosRandomizer/vehicleDNA/library.json
/settings/soturineChaosRandomizer/vehicleDNA/library.last-known-good.json
/settings/soturineChaosRandomizer/vehicleDNA/share/export.vdna.json
/settings/soturineChaosRandomizer/vehicleDNA/share/export.vdna.zip
/settings/soturineChaosRandomizer/vehicleDNA/inbox/import.vdna.zip
/settings/soturineChaosRandomizer/vehicleDNA/thumbnails/<safe-id>.png
```

Before a primary write, main passes the already schema-validated in-memory library as the last-known-good value. The adapter writes the backup, writes the normalized candidate through `jsonWriteFile(..., atomicWrite=true)`, reads the primary back, and main revalidates it. Startup rejects an invalid primary and explicitly revalidates the backup. This is bounded recovery, not a crash-proof atomicity claim.

Restore uses one ordinary operation token, original snapshot, history commit, target ID, deadlines, and rollback. Its phases are `dna_preflight`, `dna_base_spawn`, `dna_parts`, `dna_tuning`, `dna_paint`, `dna_validation`, and `dna_final_verification`. Exact requires a fully proven preflight and full final field equality. Compatible applies only uniquely resolved available data, records every omission/clamp, confirms partial intent separately, and verifies the subset actually applied. Neither restore mode consumes RNG or consults recent/blacklist state for fallback selection.

Creative operations snapshot the normalized current lock profile. Category/slot/part, tuning-name, and paint-field decisions use independent derived substreams, so an unrelated lock does not shift unlocked choices. Reroll Unlocked and every mutation first restore and strictly verify the selected parent's normalized `final` model/configuration/slots/tuning/paints. Only then does the child mutation begin. Wild may select another eligible model when no model-bound lock exists; a model-dependent lock restricts the fair selection pool to its bound model/configuration. Saved parents remain immutable and lineage is capped at 32 generations.

## Hierarchical mutation passes

1. Copy and scan the real loaded `partsTree`.
2. Sort slots by depth, path, then ID.
3. Use current candidates only for that snapshot.
4. When a slot changes, mark it as an ancestor change.
5. Before any probability/RNG call, defer each descendant with `deferred_due_to_ancestor_change`.
6. Continue planning independent siblings into the same coherent batch.
7. Commit history once, immediately before the first write.
8. Apply one tree and wait for the verified reload.
9. Re-scan the real tree; union new/changed paths with still-present deferred paths.
10. Stop through the bounded depth-derived pass budget, no-progress/repeated-state guards, retry budget, or operation timeout. Trees deeper than twelve levels remain supported within the maximum guard.

The per-pass diagnostics include slots scanned, ancestor paths changed, descendants deferred, blacklisted candidates rejected, protection blocks, actual changes, and reload reason.

## Safety evidence graph

Required/core slots can never be emptied, regardless of the setting. The adapter records source and functional evidence separately for every compatible candidate. `validator.lua` constructs nodes for selected parts, hierarchy edges, required/core roles, explicit powertrain/energy-storage sections, and conservative exact-token fallbacks. Candidate replacement is accepted under `protectCriticalParts` only when it preserves the current part's proven roles; otherwise current/default is retained with a reason.

Profile selection uses exact model type plus loaded functional evidence: standard road, electric, hybrid-like, Automation, trailer, prop, special, or unknown. Validation preserves baseline-proven applicable roles and required-role counts. It never globally requires fuel, battery, a gearbox, four wheels, steering, propulsion, or one differential. Trailer and prop concepts can be not applicable. Results are `safe`, `uncertain`, `unsafe`, or `not_applicable`; only unsafe fails and rolls back. Uncertain does not claim drivability.

## Failure model and session blacklists

Errors can record:

```lua
{
  phase = "parts",
  code = "parts_reload_timeout",
  message = "...",
  modelKey = "...",
  configKey = "...",
  slotPath = "...",
  candidate = "...",
  tuningVariable = "...",
  paintLayer = 1,
  seed = "0000-0001",
  operationToken = "SCR-00000001",
  attempt = 2,
  timestamp = 0,
  context = {}
}
```

Namespaces are separate:

```text
model:<modelKey>
config:<modelKey>/<configKey>
part:<modelKey>:<slotPath>:<candidate>
tuning:<modelKey>:<variable>
```

Only an unconfirmed base spawn can penalize its configuration. A parts failure after base confirmation targets the applied part batch. A single-candidate failure adds strong evidence. A multi-candidate batch adds `1 / batchSize` suspicion and a bounded fingerprint. Repeated appearances in different failed batches can suppress selection and reach the blacklist threshold; successful confirmed use subtracts suspicion. The store is capped at 128 records, eight fingerprints each, and a 900-second inactive TTL. Reindex and mod-state hooks clear failures, suspects, and blacklists.

Part-batch recovery adds session-only quarantine keyed by model/configuration/slot/candidate. It keeps a pre-batch snapshot, permits at most two retries per slot, eight per pass, four localized rollbacks, twelve operation retries, and 128 quarantined candidates. A verified localized rollback continues with an alternative; rollback failure enters total transaction rollback.

Vehicle-load recovery first tries the previous full snapshot, then the session
`lastCompletedGoodSnapshot`, then ranked safe official configurations. The
separate `lastReadableSnapshot` is diagnostic evidence and is not automatically
a recovery candidate. Three consecutive failures open an official-only circuit
breaker. Locks do not constrain recovery. Every terminal path clears the
tracker, timers, pending writes, and transient recovery/creative fields and
releases derived Busy state.

## Full Random transaction

Full Random owns one token, seed, original snapshot, history commit, and terminal result across selection, replacement, layered config confirmation, all bounded part passes, optional tuning, optional paint, and final safety validation. It cannot finish after the base spawn. The result reports base version/source, selected-part changes/removals, nested passes, tuning values, paint layers, warnings, safety status, and seed. Any destructive middle-stage failure enters the same rollback transaction, and a confirmed rollback removes its history entry.

## Tuning groups

Installed 0.38.6 processing provides display `category`/`subCategory`, not a proven correlation contract. Names and categories are never used to infer a group.

The normalizer recognizes a group only when metadata explicitly supplies both:

```lua
correlationGroup = "group-id"
correlationStrategy = "shared_normalized_sample"
```

Each explicit group gets a seed-derived substream and one normalized sample, then every member applies its own min/max, clamp, and step. Ungrouped variables receive independent name-derived substreams. Current installed content is therefore expected to remain ungrouped unless a reliable producer adds that explicit contract.

## History and rollback

The full original state is captured before scanning/selection but remains only in `active.originalState`. `historyTransaction.commit` pushes it once immediately before the first replace/parts/tuning/paint write. Pre-write failures create no Undo entry; later passes reuse the same entry; Undo never pushes.

A successful automatic rollback removes the now-redundant history entry. A failed/unconfirmed rollback keeps it as diagnostic and possible manual Undo evidence.

## Granular capabilities

Raw capability fields are:

```text
vehicleRegistry, vehicleReplace,
partsRead, partsWrite,
tuningRead, tuningWrite,
paintRead, paintWrite,
settingsPersistence, uiEvents, lifecycleConfirmation
settingsRead, settingsWrite,
dnaRead, dnaWrite, dnaExportFile, dnaBackup
```

Derived actions also expose `dnaList`, `dnaDelete`, and `dnaImportText` independently of optional fixed-path file export. A missing export-file capability never disables basic save/list/copy behavior. Parts read/write plus lifecycle confirmation are essential for Scramble. Tuning and paint are optional stages with public warnings.

## Developer stress runner

Stress is disabled by default and has no normal-panel control. It schedules at most one normal state-machine operation at a time from `onUpdate`; it never runs a synchronous iteration loop.

Limits: default 10, maximum 50 iterations, maximum 300 seconds, per-operation timeout 5–60 seconds, manual cancellation, stop-on-failure option, and cancellation on map/vehicle/mod changes. Iteration seeds are deterministic substreams. The summary contains attempts, successes, failures, timeouts, rollbacks, phase counts, blacklist counts, average/slowest duration, and failure seeds.

## UI boundary

Production modules are kept separate from the UI bridge and central mutation
algorithm: `lineupManager`/`lineupSchema`/`lineupStorage` own inert sequential
collections; `spawnDirector` plus `spawnApiAdapter` own placements/read-back;
`managedVehicleRegistry` owns multi-target generations; and `aiAdapter`,
`aiDirector`, `routePlanner`, and `destinationMarker` own capability-gated
in-game driving. Lineup invokes the existing Full Random orchestrator rather
than duplicating parts/tuning/paint logic. Spawn and AI accept only Ready
managed generations.

The UI has fixed Randomize, Locks, Garage, Compare, and Share destinations and calls only allowlisted public extension methods. Random Car is presentation for the unchanged `randomConfig` enum. Collapsed/compact/standard/expanded modes affect layout only; contextual creative buttons are absent when no DNA is selected. An action click cancels the pending settings timer and sends `runAction(action, currentSettings)` as one serialized Lua call. Lua validates/applies the snapshot before beginning the operation. Pasted DNA is length-checked and parsed with `JSON.parse` before `serializeToLua`; raw import text never becomes Lua source or a method name. Exact/Compatible buttons run preflight first, and Garage compatibility owns the separate destructive confirmation. Server state events assign scope state without scheduling another settings write. Destroy cancels both settings and search timers.

Periodic public state contains paginated summaries, bounded reports, metrics, and lock counts—not full DNA, export text, thumbnail bytes, or full details. Explicit details, comparison, lock resolution, and JSON export use dedicated one-off events.

The custom-element host is explicitly block-sized to 100% width/height because the directive retains `replace: false`.

## Determinism and packaging

Random choices use operation, pass, variable, group, retry, competitor, spawn,
AI, and creative substreams. Maps are sorted before choices. Generator 6 uses
`SCR6-...` seeds because 0.6.0 coverage/Lineup decisions change output. Schema 1
generator-4/5 snapshots remain restorable and retain their version; they are
never reinterpreted as generator 6. Results require identical
game/content/settings/starting state/quarantine inputs.

The ZIP builder normalizes member order, timestamps, Unix regular-file mode, path separators, packaged text line endings, compression level, and checksum format. It never adds a wrapper directory or development files. A deterministic external release manifest binds VERSION/tag/commit/source-date, filename/bytes/entries/SHA, BeamNG target, schema/generator versions, and real automated/interactive counts. Repeated same-environment builds must be byte-identical; cross-platform identity requires comparing the real archives.

Runtime performance records index builds/cache hits, Garage/compatibility/thumbnail/compare/export/import timings, storage bytes/elements, and the last operation's duration, reload count, slot scan/planning time, slot count, candidate count, and depth. Diagnostics, history, passes, lineage, compare, packages, images, suspects, and paint confirmation are all bounded. Synthetic performance measurements are documented in [Performance](PERFORMANCE.md).
