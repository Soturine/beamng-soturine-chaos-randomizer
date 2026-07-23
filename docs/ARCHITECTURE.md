# Architecture

Soturine's Chaos Randomizer is a GE Lua extension with a compact AngularJS UI App. The architecture keeps current BeamNG internals in one adapter and keeps randomization logic deterministic and testable outside the game.

## Goals and constraints

- Discover vehicles, configurations, and compatible installed parts dynamically.
- Operate on the current hierarchical `partsTree`; never force unrelated parts into a slot.
- Keep one operation active at a time and make every wait bounded and cancellable.
- Batch changes so a mutation pass causes at most one vehicle respawn.
- Preserve deterministic choices when seed, content, game version, and settings match.
- Treat BeamNG-returned tables as read-only and copy before filtering or mutation.
- Keep the default UI focused on three actions, one Chaos slider, and two safety checkboxes.
- Fail honestly when an internal API is missing or third-party content cannot load.

## Package layout

```text
lua/ge/extensions/soturineChaosRandomizer.lua       loadable entry point
lua/ge/extensions/soturineChaosRandomizer/          implementation modules
ui/modules/apps/soturineChaosRandomizer/             AngularJS UI App
settings/soturineChaosRandomizer/defaults.json       packaged defaults
```

The distribution ZIP starts with `lua/`, `ui/`, and `settings/`. Repository-only files such as tests, tools, documentation, and workflows are excluded.

The top-level extension file returns the implementation from `soturineChaosRandomizer/main.lua`. The UI explicitly loads `soturineChaosRandomizer`, matching BeamNG's underscore-based extension name rules without requiring a global startup script.

## Module boundaries

| Module | Responsibility | BeamNG API access |
| --- | --- | --- |
| `main.lua` | Public actions, orchestration, lifecycle hooks, progress/results, rollback coordination | Only through adapter |
| `apiAdapter.lua` | Current vehicle/config snapshots, registry access, slot metadata, mutation application, spawning, paint/tuning, VFS, UI events, persistence, version checks | All unstable/internal calls live here |
| `contentIndex.lua` | Normalize, filter, cache, classify, and blacklist registry content | None |
| `vehicleSelector.lua` | Equal-per-vehicle model choice and anti-repeat behavior | None |
| `configSelector.lua` | Per-model or global config choice and anti-repeat behavior | None |
| `rng.lua` | Seed normalization, isolated PRNG, choices, weights, shuffling, sub-seeds | None |
| `slotScanner.lua` | Flatten copied tree snapshots, signatures, new/changed path detection | None |
| `mutationPolicy.lua` | Convert Chaos and safety settings into all probabilities and limits | None |
| `mutationEngine.lua` | Plan immutable compatible part changes per bounded pass | None |
| `tuningRandomizer.lua` | Validate ranges, sample, clamp, and quantize final variables | None |
| `paintRandomizer.lua` | Generate supported coordinated/contrasting paint tables | None |
| `validator.lua` | Protect core/critical metadata and conservative drivability concepts | None |
| `operationState.lua` | Tokens, legal transitions, busy lock, deadlines, stale callback rejection | None |
| `history.lua` | Bounded complete-state snapshots and Undo stack | None |
| `settings.lua` | Defaults, validation, schema migration, setting updates | None; injected persistence functions |
| `diagnostics.lua` | Structured summaries and optional detailed records | None; injected log sink |

The UI does not call vehicle, JBeam, registry, VFS, or paint APIs. It calls only the public extension table and renders events sent by `main.lua`.

## Core data structures

### Settings

```lua
{
  schemaVersion = 1,
  chaos = 75,
  allowMissingParts = true,
  keepVehicleDrivable = false,
  contentFilter = "everything",
  includeAutomation = false,
  includeTrailers = false,
  includeProps = false,
  selectionFairness = "vehicle",
  historyLimit = 10,
  diagnosticLogging = false,
  manualSeed = ""
}
```

Unknown keys are discarded during migration. Numeric values are clamped and enumerations fall back to defaults.

### Indexed model

```lua
{
  key = "pickup",
  name = "D-Series",
  brand = "Gavril",
  type = "Truck",
  sourceKind = "official", -- official | mod | user | unknown
  sourceLabel = "BeamNG - Official",
  isAutomation = false,
  isTrailer = false,
  isProp = false,
  defaultConfig = "d15_v8_4wd",
  configs = { ... }
}
```

Classification first uses normalized registry metadata. Conservative text heuristics are isolated fallbacks. Unknown source ownership remains `unknown`.

### Indexed configuration

```lua
{
  modelKey = "pickup",
  key = "d15_v8_4wd",
  name = "Gavril D-Series D15 V8 4WD",
  path = "/vehicles/pickup/d15_v8_4wd.pc",
  sourceKind = "official",
  sourceLabel = "BeamNG - Official",
  userSaved = false,
  valid = true,
  failureCount = 0
}
```

### Normalized slot

```lua
{
  id = "pickup_engine",
  path = "/pickup_frame/pickup_engine/",
  depth = 2,
  currentPart = "pickup_engine_v8_5.5",
  candidates = { "pickup_engine_i6_4.1", "pickup_engine_v8_5.5" },
  coreSlot = true,
  required = true,
  defaultPart = "pickup_engine_v8_5.5",
  description = "Engine",
  allowTypes = { "pickup_engine" },
  denyTypes = {},
  parentPart = "pickup_frame",
  signature = "..."
}
```

The adapter derives slot metadata by matching each loaded child node to the slot definition on its loaded parent part. `slotScanner` receives only normalized copies.

### Operation

```lua
{
  token = "SCR-00000001",
  kind = "scramble",
  state = "mutating",
  startedAt = 0,
  deadline = 0,
  vehicleId = 1234,
  originalVehicleId = 1234,
  seed = "8F31-A902",
  rng = <operation-owned generator>,
  policy = { ... },
  pass = 1,
  previousSlots = {},
  changes = {},
  tuningChanges = {},
  paintChanges = 0,
  afterReload = "nextMutationPass",
  selectedModel = nil,
  selectedConfig = nil,
  originalState = { ... }
}
```

### History entry

```lua
{
  modelKey = "pickup",
  config = <deep copy of complete current config>,
  partsTree = <deep copy>,
  tuning = <deep copy>,
  paints = <deep copy>,
  selectedConfiguration = "...",
  seed = "8F31-A902",
  vehicleId = 1234,
  timestamp = 0,
  operationType = "scramble"
}
```

History is memory-only in the first alpha. Undo does not create another destructive history entry.

## Public API and UI events

The extension exposes a deliberately small surface:

```text
randomConfig(options)
scramble(options)
fullRandom(options)
undo()
reindex()
updateSettings(partialSettings)
requestState()
```

The UI receives `SoturineChaosRandomizerState` payloads containing:

- busy flag and current state;
- progress label and normalized progress;
- validated settings;
- current seed;
- last result or error;
- index counts;
- Undo availability;
- recent history summaries;
- compatibility flags.

All buttons are disabled while busy. A second call while an operation is active returns a clear `busy` result rather than replacing the operation.

## Deterministic seed behavior

`rng.lua` owns its state and never calls or seeds global `math.random`. Text seeds are normalized with a stable 32-bit hash and displayed as an uppercase `XXXX-XXXX` value. Empty manual seeds are derived from adapter-provided time/entropy and then normalized before the first random choice.

The RNG supports:

- unsigned 32-bit output;
- float and integer ranges;
- probability checks;
- array choice;
- weighted choice;
- Fisher-Yates shuffle on a copy;
- operation sub-seeds.

Arrays and maps are sorted before choices whenever their source iteration order is not guaranteed. Equal seeds reproduce choices only with identical BeamNG version, settings, and enabled content.

## Chaos policy

All probabilities originate in `mutationPolicy.lua`:

```text
chaos                 = clamp(value / 100, 0, 1)
partMutationChance    = 0.05 + 0.95 * chaos
parentMutationChance  = 0.05 + 0.80 * chaos
nestedMutationChance  = 0.10 + 0.90 * chaos
extremeTuningChance   = chaos ^ 2
paintMutationChance   = 0.20 + 0.80 * chaos
maxMutationPasses     = min(5, 1 + floor(chaos * 4))
emptySlotChance       = allowMissing
  and max(0, (chaos - 0.25) / 0.75) * 0.35
  or 0
```

The module also owns tuning spread and paint contrast. Mutation code consumes the resulting policy and contains no independent Chaos equations.

## Event-driven operation flow

### Random Config

```text
idle
  -> indexing (only if cache is absent)
  -> selecting
  -> capture history
  -> spawning
  -> waitingForVehicle
  -> completed | rollingBack | failed | cancelled
```

The action selects a complete registered configuration and does not run part, tuning, or paint mutation.

### Scramble

```text
idle
  -> capture history
  -> scanning current partsTree
  -> plan pass on copied compatible candidates
  -> validating plan
  -> apply one partsTree batch
  -> waitingForReload
  -> scan new/changed slots
  -> repeat while changed and below policy/hard cap
  -> scan final tuning metadata
  -> apply tuning batch
  -> waitingForReload when tuning changed
  -> apply supported paints
  -> completed
```

The first pass may inspect every loaded slot. Later passes inspect only paths whose slot definition/candidate signature is new or changed. The process stops when stable, when no change is planned, or when the policy/hard pass limit is reached.

### Full Random

```text
idle
  -> index/select model and base config
  -> capture history
  -> replace vehicle
  -> waitingForVehicle
  -> run Scramble pipeline on loaded model
  -> completed
```

The base configuration is always valid for the selected model according to the current registry.

## Mutation rules

For every eligible normalized slot, `mutationEngine.lua`:

1. copies the candidate array;
2. filters invalid strings and session-blacklisted choices;
3. protects core and required slots;
4. asks `validator.lua` whether drivability protection should retain the current/default part;
5. applies the Chaos-derived mutation probability for the slot depth/pass;
6. considers an empty candidate only when allowed and safe;
7. removes the current choice from the selectable pool when an alternative exists;
8. chooses with the operation RNG;
9. changes the copied tree node and records the decision.

Unknown third-party slots remain eligible because candidate compatibility comes from BeamNG, not from a hardcoded part taxonomy. Name heuristics are used only by conservative optional drivability protection.

## Best-effort drivability validation

The validator never claims to prove that a vehicle will drive. It enforces conservative rules when enabled:

- never empty the main/root or `coreSlot` nodes;
- preserve slots with explicit required metadata;
- protect likely propulsion, energy storage, transmission path, drivetrain, steering, suspension, hub, wheel, and tire concepts when metadata is incomplete;
- prefer a non-empty current/default candidate for protected concepts;
- allow unknown optional slots to mutate normally.

Heuristics examine slot descriptions, allowed types, part metadata, and slot IDs in that order. They are isolated and logged. This approach accommodates unconventional vehicles better than assuming one combustion engine, one fuel tank, two differentials, or four wheels.

## Tuning and appearance

Tuning is scanned after the final parts reload. Only finite numeric variables with a valid range are considered. Hidden, degenerate, malformed, and unsupported variables are preserved.

- Low Chaos blends samples toward the declared/current default.
- Medium Chaos mixes centered and uniform samples.
- High Chaos increasingly selects values near declared extremes.
- Every result is clamped and quantized to a positive usable step.

Paint generation uses the number of existing supported paint slots. Low Chaos shares a coordinated hue family; high Chaos increases hue separation and material contrast. Numeric paint fields remain within documented/current ranges. Paint-design slots are already eligible as normal compatible part slots.

## State, concurrency, and cancellation

Legal states are:

```text
idle, indexing, selecting, spawning, waitingForVehicle, scanning,
mutating, waitingForReload, tuning, painting, validating,
completed, rollingBack, cancelled, failed
```

Every operation has a monotonically increasing token. Deferred callbacks and vehicle hooks compare the active token and expected state. Stale callbacks do nothing.

The active wait stores a deadline. `onUpdate` performs only a constant-time deadline check; it does not poll for completion. Timeout enters controlled rollback. Vehicle switch, vehicle destruction, mission end, and a mismatched expected vehicle cancel or roll back safely. Every terminal path releases the busy lock and publishes state to the UI.

## Error handling and rollback

Adapter functions return one of:

```lua
true, value
false, { code = "unsupported_api", message = "...", context = {...} }
```

Protected calls are limited to API boundaries. Logic errors are not silently swallowed.

Before a destructive action, `main.lua` captures a complete state. Rollback replaces the target model using the captured configuration table, waits for the normal spawn hook, and reports complete or partial restoration. If a third-party model or part disappeared, the error remains visible and the history entry is retained for diagnosis.

Failures are counted per session. A model/config/candidate crosses a small threshold before being blacklisted, and the blacklist is cleared by extension reload or explicit reindex. Retries are bounded.

## Indexing and caching

The index is built on extension initialization or first use through the current vehicle/config registries. It never opens installed mod ZIP files. Detailed JBeam part data is loaded only for the current vehicle.

Cache invalidation occurs on:

- explicit `Reindex Content`;
- extension reload;
- supported mod-manager lifecycle hooks when available;
- a registry operation reporting stale/missing content.

Selection uses sorted stable arrays, a small recent-choice queue, and the session blacklist. Equal-per-vehicle first chooses a model and then one of its configs. Equal-per-configuration chooses from the global config array.

## Settings persistence

Packaged defaults live at `/settings/soturineChaosRandomizer/defaults.json`. User changes are written to `/settings/soturineChaosRandomizer/settings.json`, which BeamNG resolves into the user data layer. A missing or malformed user file falls back to validated defaults. Schema migration happens before any value reaches the UI or policy module.

## Diagnostics

All logs use `SoturineChaosRandomizer`. Normal mode records lifecycle, results, and actionable failures. Diagnostic mode additionally records game/extension version, index size/time, selection, seed, pass signatures, mutation counts, tuning/paint counts, validation actions, timeouts, rollback, API failures, and blacklist changes.

Diagnostic records never include authentication data or arbitrary personal paths. Environment paths appear only in developer documentation, not runtime export.

## Performance strategy

- Build the content index once and use current registries.
- Sort only normalized metadata required for deterministic selection.
- Scan detailed slot/part data only for the active vehicle.
- Batch tree changes into one respawn per bounded pass.
- Compare compact slot signatures before another pass.
- Apply tuning once after the final tree and paints once after tuning.
- Use hooks for completion and `onUpdate` only for deadlines.
- Do not emit per-slot UI events; publish pass/result summaries.
- Drop temporary candidate arrays after planning.
- Keep a hard five-pass cap even if future policy changes.

## Testing seams

Every module except the adapter and orchestrator can run under the shipped BeamNG Lua console with fixture tables. Automated tests cover deterministic RNG, policy boundaries, immutable candidates, slot filtering, tuning distributions, state transitions/timeouts/stale callbacks, history, blacklist thresholds, settings migration, and package paths.

The adapter is verified by static source inspection and must be validated in game. `docs/TESTING.md` records automated checks separately from in-game results so packaging success is never presented as gameplay validation.

## Compatibility evolution

When BeamNG changes an internal function, only `apiAdapter.lua` should need direct API edits. The adapter performs capability checks and reports a compatibility summary to the UI. If the required hierarchical part API is unavailable, Scramble and Full Random are disabled with a clear reason while safe independent functions can remain available.
