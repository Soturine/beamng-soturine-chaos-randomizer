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
| selectors/policy/diagnostics/util | Pure selection, Chaos policy, structured logs, shared helpers |

## Settings schema

```lua
{
  schemaVersion = 3,
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
  defaultRestoreMode = "exact"
}
```

Schema 3 retains the schema-2 critical-parts migration, maps the temporary `dnaLimit` name to `dnaLibraryLimit`, forces autosave off, and bounds the library to 1–100 entries. Unknown keys are removed; numeric/enumerated settings are bounded.

## Adapter write contracts

Adapter calls use explicit contracts rather than interpreting `pcall` alone as success:

| Write | Synchronous contract | Completion contract |
| --- | --- | --- |
| `replaceVehicle` | receives the exact recorded target object and must return a vehicle object with `getID()`/`getId()`/ID evidence; `false`/`nil`/ambiguous ID reject | exact returned vehicle ID plus `onVehicleSpawned` and layered model/config read-back |
| `setPartsTreeConfig` | installed API normally returns `nil`; `false` rejects | `onVehicleSpawned`, expected path/candidate read-back |
| `setConfigVars` | installed API normally returns `nil`; `false` rejects | `onVehicleSpawned`, expected tuning values read-back |
| `setConfigPaints(..., false)` | installed API normally returns `nil`; `false` rejects | requested-field read-back immediately or through a two-second bounded update retry; no reload event |

Thrown exceptions retain their detail. Phase-specific codes include `vehicle_replace_rejected`, `parts_apply_rejected`, `tuning_apply_rejected`, and `paint_apply_rejected`. A synchronous rejection never waits for the normal timeout.

## Operation and lifecycle model

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

An expectation stores operation token, phase, expected hook, exact vehicle/model/config evidence, requested parts/tuning values, and start time. Replacement writes bind to the vehicle ID extracted from the returned object. A synchronous switch emitted before the call returns is queued and checked against that ID; it is never used to retarget the expectation. `onVehicleSpawned` is accepted only for the exact current target and current token. The post-event snapshot must satisfy the phase-specific expectation before the pipeline advances. A matching hook by itself is not success.

Config verification applies layers: exact model, normalized path, model-scoped registry key, minimal loaded-state signature, then explicit failure as `config_identity_unverified`. Paint confirmation is update-driven, interval-limited, attempt-limited, and does not use `onVehicleSpawned`.

Timeouts report the exact phase. Manual map/vehicle/mod-state changes cancel with a distinct lifecycle reason; stale/wrong-vehicle hooks are logged and ignored.

## Vehicle DNA transaction

A completed Random Config, Scramble, or Full Random result gets a fresh configuration capture and hierarchical scan. Only after normalization, schema validation, and fingerprint generation does `runtime.dna.pending` expose an explicit save. The pending entry is session-only; autosave is always false.

The selected persistence design is one bounded store because installed-source evidence proves JSON read/write and the helper's temp/rename mode, but not a complete portable directory/listing transaction:

```text
/settings/soturineChaosRandomizer/vehicleDNA/library.json
/settings/soturineChaosRandomizer/vehicleDNA/library.last-known-good.json
/settings/soturineChaosRandomizer/vehicleDNA/export.json
```

Before a primary write, main passes the already schema-validated in-memory library as the last-known-good value. The adapter writes the backup, writes the normalized candidate through `jsonWriteFile(..., atomicWrite=true)`, reads the primary back, and main revalidates it. Startup rejects an invalid primary and explicitly revalidates the backup. This is bounded recovery, not a crash-proof atomicity claim.

Restore uses one ordinary operation token, original snapshot, history commit, target ID, deadlines, and rollback. Its phases are `dna_preflight`, `dna_base_spawn`, `dna_parts`, `dna_tuning`, `dna_paint`, `dna_validation`, and `dna_final_verification`. Exact requires a fully proven preflight and full final field equality. Compatible applies only uniquely resolved available data, records every omission/clamp, confirms partial intent separately, and verifies the subset actually applied. Neither restore mode consumes RNG or consults recent/blacklist state for fallback selection.

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
10. Stop at the Chaos-derived limit and unconditional five-pass hard cap.

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

The UI calls only fixed public extension methods. An action click cancels the pending settings timer and sends `runAction(action, currentSettings)` as one serialized Lua call. Lua validates/applies the snapshot before beginning the operation. Pasted DNA is length-checked and parsed with `JSON.parse` before `serializeToLua`; raw import text never becomes Lua source or a method name. Exact/Compatible buttons run preflight first, and the Compatibility view owns the separate destructive confirmation. Server state events assign scope state without scheduling another settings write. Destroy cancels the pending timer.

The custom-element host is explicitly block-sized to 100% width/height because the directive retains `replace: false`.

## Determinism and packaging

Random choices use operation, pass, variable, and group substreams. Maps are sorted before choices. Results require identical game/content/settings/starting state/blacklist inputs.

The ZIP builder normalizes member order, timestamps, Unix regular-file mode, path separators, packaged text line endings, compression level, and checksum format. It never adds a wrapper directory or development files. A deterministic external release manifest binds VERSION/tag/commit/source-date, filename/bytes/entries/SHA, BeamNG target, schema/generator versions, and real automated/interactive counts. Repeated same-environment builds must be byte-identical; cross-platform identity requires comparing the real archives.

Runtime performance records index builds/cache hits and the last operation's duration, reload count, slot scan/planning time, slot count, candidate count, and depth. Diagnostics, history, passes, suspects, and paint confirmation are all bounded. Synthetic performance measurements are documented in [Performance](PERFORMANCE.md).
