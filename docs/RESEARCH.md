# BeamNG.drive 0.38.6 API Research

Research date: 2026-07-23

The installed game source is the compatibility authority for this milestone. It was re-read before implementation; prior project documentation was not treated as a substitute for current source. No installed content ZIP was manually opened for indexing or fixture creation.

## Environment

| Item | Inspected value |
| --- | --- |
| Operating system | Windows 10 build 19045 |
| BeamNG executable | `0.38.6.0.19963` |
| Steam build | `23007233` |
| Shipped console runtime | Lua 5.1, BeamNG `0.38.6.0` |
| Interactive 0.38 profile/world | Not available during this implementation |

The 0.4 audit revalidated `integrity.json` (`0.38.6.0`, buildbot build `19963`) and Steam manifest build `23007233` on 2026-07-23; no newer installed build was present.

Machine-specific install, user-profile, and repository paths are intentionally omitted. Installed-source references below are paths relative to the BeamNG installation.

## 0.4.0-alpha.2 re-audit

The hotfix re-audit was performed from clean repository commit
`dffb86c0e4447eb509081e94b64b66aeacf8d01f` before code changes. The installed
executable still reports `0.38.6.0.19963`; Steam app manifest `284160` still
reports build `23007233`. The adapter therefore remains targeted at the same
audited build, but every newly used optional API is capability-gated.

Evidence is classified as follows throughout this milestone:

| Classification | Meaning for this project |
| --- | --- |
| Source inspected | Contract or call shape was read in the installed BeamNG source. |
| Automated | Pure or mocked behavior ran in the repository harness. |
| Mocked | A BeamNG boundary was replaced by a controlled test double. |
| Packaged artifact | The exact deterministic ZIP/checksum/manifest passed package validation. |
| Interactive passed | Observed in a real BeamNG world/UI session with a recorded log. |
| Interactive pending | Not observed live; source or mocks do not upgrade this status. |

Baseline re-run before changes: `36` Python tests passed with `260` reported
subtests under `pytest`. Interactive passed remains `0`; the alpha.2 gate expands
the matrix from `55` to `60` pending cases, all requiring a real session.

### Additional optional APIs revalidated

- `lua/ge/extensions/render/renderViews.lua` exposes
  `takeScreenshot(options, callback)`. It creates a Lua-owned render view,
  applies caller-provided camera and bounded resolution, hides UI/markers,
  writes through `saveToDisk`, destroys the view, restores visibility, and then
  invokes the callback. `career/modules/inventory.lua` demonstrates a
  `500 x 281` vehicle capture with an explicit filename and callback. This is
  sufficient for an optional adapter capability, but no capture is claimed
  interactive until its completion and file bounds are observed live.
- `lua/ge/screenshot.lua` exposes general screenshots but chooses the normal
  screenshots folder and may include environment/account metadata. It is not
  used for Vehicle DNA gallery capture.
- Installed source calls the global `setClipboard(text)` and ImGui clipboard
  helpers. A fixed adapter wrapper may expose text copy when present; imported
  data never supplies a method name or command. Browser-side clipboard remains
  a progressive enhancement rather than a required contract.
- Installed `ui/apps.lua` confirms discovery through
  `FS:findFiles('/ui/modules/apps/', 'app.json', ...)`, JSON app metadata, and
  UI hooks. This revalidates the current UI App packaging shape only; resize,
  focus, controller behavior, and screen-reader output remain interactive
  pending.
- Installed source contains `FS:findFiles`, `FS:directoryCreate`,
  `FS:copyFile`, `FS:removeFile`, and `FS:renameFile` call sites. The project
  will use only constant controlled roots, normalized basenames, allowlisted
  extensions, bounded entry counts/sizes, and capability detection. Source
  presence alone is not treated as a portable multi-file transaction.
- `core_modmanager.getModFromPath` remains the ownership evidence for a mounted
  configuration/part. Empty identifiers and empty optional slots are not
  dependencies, and `unknown` remains `unknown` without provenance.

No installed mod ZIP or content ZIP was opened manually. No screenshot,
thumbnail, mod asset, JBeam, texture, sound, or third-party file was copied into
the repository or fixtures.

## 0.5.0-alpha.2 lifecycle and metadata re-audit

The lifecycle hotfix re-audit was performed from clean repository commit
`ba584da4d7055f26167c4770caf2efe4b6f9245b` before code changes. The installed
executable remains `0.38.6.0.19963`, Steam build `23007233`, and integrity
buildbot `19963`. No installed mod or content ZIP was opened.

The following installed-source behavior is authoritative for the alpha.2
implementation:

- `core/vehicles.lua` may reuse the selected object or spawn a new one during
  `replaceVehicle`. A synchronous returned object ID is evidence that the call
  was accepted, not proof that it is the final player-controlled vehicle.
  Multi-vehicle configurations can create auxiliary objects and can produce
  several spawn/switch observations before the player target settles.
- `lua/ge/main.lua` emits `onVehicleSpawned`, `onVehicleSwitched`, and
  `onVehicleDestroyed`. No public `onVehicleLoadFailed` contract was found.
  Load failure is therefore detected conservatively from player-vehicle
  identity, model/config/tree readback, destruction, and a bounded timeout;
  alpha.2 does not invent or rely on an unverified failure callback.
- `core/vehicle/partmgmt.lua` applies both part-tree and tuning writes through a
  vehicle respawn and provides no useful synchronous completion value. A write
  may consequently change object identity. Completion requires repeated
  player-target observations and state readback after callbacks.
- `core/trailerRespawn.lua` tracks trailers separately and explicitly ignores
  Prop objects. The main target is selected from player `0` plus expected
  model/config evidence; a newest spawned entity is never assumed to be the
  operation target.
- The lifecycle observation ladder is: callback candidates, current player-0
  vehicle ID, model/config readback, complete part-tree readback, then stable
  agreement over multiple frames and scans. Candidate/event history and retry
  budgets are bounded. Expected reload transitions are classified separately
  from genuine external player switches.
- Transiently incomplete trees are possible while the vehicle is rebuilding.
  Missing critical or required slots become persistent errors only after
  repeated coherent scans of the same settled target; one intermediate scan is
  insufficient evidence.
- `renderViews.takeScreenshot` and the career inventory's
  `util_screenshotCreator.frameVehicle` remain the audited thumbnail path.
  Alpha.2 must compare the exact current final DNA state immediately before
  capture, not merely the model key.
- VFS source still confirms the controlled-path operations used by this
  project. Binary `io.open` remains isolated behind the adapter and receives
  only project-constructed paths.
- `core/modmanager.lua` reads repository-rich metadata from
  `/mod_info/<id>/info.json`; the file is added by BeamNG's repository process.
  A locally distributed ZIP without that repository metadata can legitimately
  show “Description unavailable” in Mod Manager. Alpha.2 will not fabricate
  resource IDs, user IDs, repository tags, or ownership provenance.
- `core_vehicles` and available-parts/JBeam inspection expose provenance only
  when the installed game can prove it. Unknown dependency ownership remains
  `unknown`, and imports recompute compatibility against the local registry
  instead of trusting exporter claims.

Official UI App documentation was rechecked for `app.js`, `app.json`, and
`app.png` packaging. The recommended icon footprint is approximately
`250 x 120`; screen layout, collapsed/compact behavior, controller navigation,
and mod-vehicle behavior still require an interactive session.

Alpha.2 interactive results at implementation start: `0` passed, `0` failed;
all new lifecycle and mod-vehicle rows are pending until exercised in a real
BeamNG 0.38.6 world. Source inspection and mocks do not upgrade those rows.

## 0.6.0 pause, spawn, NavGraph, and AI re-audit

The installed executable remains `0.38.6.0.19963` and Steam build `23007233`.
This audit used installed paths relative to the BeamNG root and did not open or
copy third-party mod archives.

Pause/time evidence:

- GE Lua exposes `simTimeAuthority.getPause()` as the current boolean pause
  state and `simTimeAuthority.getReal()` as a time-scale query. The extension
  only reads these values and never changes pause state.
- `onUpdate(dtReal, dtSim, dtRaw)` provides separate frame deltas. The 0.6
  abstraction retains real delta, simulation delta/time, raw delta, and frame
  count rather than treating a zero simulation delta as a stopped update loop.
- The installed environment exposes the high-precision `os.clockhp()` used by
  GE Lua timing code. The adapter prefers it as the single monotonic deadline
  source and falls back to `os.clock` only when absent. No deadline mixes this
  value with accumulated simulation time.

Spawn/vehicle evidence:

- `lua/ge/ge_utils.lua` and `lua/ge/spawn.lua` use
  `getPlayerVehicle(0):getDirectionVector()` for player heading.
- `core_vehicles.spawnNewVehicle(model, options)` returns a vehicle object; GE
  vehicle objects expose `getID`, `getPosition`, `getVelocity`, and `delete` in
  installed call sites. `getAllVehicles()` is used by GE Lua to enumerate
  current vehicles.
- `lua/ge/map.lua` exports `map.findClosestRoad`; its node table from
  `map.getMap().nodes` provides positions for an evidence-backed road heading.
  World placement and destination preview use `Engine.castRay` only behind
  capability checks.

NavGraph/AI evidence:

- `lua/ge/map.lua` exports `map.findClosestRoad` and `map.getPath`. These return
  road-node/path data; they are not the visual GPS line.
- `lua/vehicle/ai.lua` exports `ai.setSpeed`, `ai.setSpeedMode`,
  `ai.setAggression`, `ai.driveInLane`, `ai.setAvoidCars`,
  `ai.driveUsingPath`, `ai.setTargetObjectID`, `ai.setMode`,
  `ai.startRecording`, and `ai.stopRecording`. These functions run in Vehicle
  Lua, so GE Lua sends fixed, validated commands through the vehicle queue.
- Installed comments/validation support speed modes `set` and `limit` for this
  UI contract and aggression in the 0.3–1 range. Path driving accepts a bounded
  path/waypoint list plus lane, avoidance, speed, aggression, and lap options.
- Chase/Follow uses a real target object ID; Traffic uses the installed traffic
  mode. No bounded portable contract was identified for taking a recording and
  transferring it back into this GE-Lua multi-vehicle director. Recorded and
  Scripted playback therefore remain disabled with explicit reasons.

Installed-source evidence confirms names/call contexts, not live vehicle
behavior. Destination reachability, AI driving, spawn raycasts, ID-changing
mods, pause lifecycle, and recording UI remain 0.6.0 interactive Pending.

## 0.5.0-alpha.1 sharing and gallery audit

The installed executable and Steam build remained unchanged. New optional boundaries were accepted only after source inspection:

- `lua/ge/extensions/career/modules/inventory.lua` uses `util_screenshotCreator.frameVehicle`, a 500x281 `vec3` resolution, a controlled filename, and `render_renderViews.takeScreenshot(options, callback)`. `lua/ge/extensions/render/renderViews.lua` owns the temporary render view, hides/restores UI markers, writes the requested image, and invokes the callback. The adapter mirrors the bounded vehicle-framing shape only after explicit user action and re-reads the result before metadata is stored.
- `lua/ge/ge_utils.lua:testZIP` documents installed `ZipArchive()` calls (`openArchiveName`, `addFile`, `getFileList`, `extractFile`, and `close`). `lua/ge/extensions/core/modmanager.lua` contains current reader call sites. The project nevertheless uses its own tiny stored-entry encoder/parser so archive bytes, local/central validation, CRC, names, bounds, and hostile fixtures remain deterministic and testable without extracting anything.
- `lua/ge/map.lua` and current editor/telemetry call sites prove the global `hashStringSHA256(string)` shape. Package manifests require a lowercase 64-hex digest and fail closed when that capability is absent.
- Installed VFS call sites reconfirm `FS:getUserPath`, `FS:directoryCreate`, `FS:removeFile`, and `FS:fileExists`. Binary `io.open` is capability-gated and receives only adapter-constructed real paths under constant `/settings/soturineChaosRandomizer/vehicleDNA/` roots. Imported names/IDs never provide a path segment without safe-ID normalization.

Source inspection proves call shapes, not successful live capture, filesystem permissions, UI image loading, or cross-PC transfer. Those rows remain Pending. No installed mod ZIP was opened and no third-party thumbnail or asset was copied.

## Official documentation reviewed

- [Lua extensions](https://documentation.beamng.com/modding/programming/extensions/)
- [Programming languages](https://documentation.beamng.com/modding/programming/languages/)
- [Creating a UI App](https://documentation.beamng.com/modding/ui/app_creation/)
- [Slots](https://documentation.beamng.com/modding/vehicle/sections/slots/)
- [Slots2](https://documentation.beamng.com/modding/vehicle/sections/slots/slots2/)
- [Vehicle configurations](https://documentation.beamng.com/modding/vehicle/tutorials/configs/)
- [Variables](https://documentation.beamng.com/modding/vehicle/sections/variables/)
- [Correctly packing mods](https://documentation.beamng.com/modding/mod-support/mod_packing/)
- [User folder](https://documentation.beamng.com/support/userfolder/)

BeamNG's programming documentation states that internal APIs can be incomplete or change. Every internal call remains isolated in `apiAdapter.lua`.

## Write contracts from installed source

### `core_vehicles.replaceVehicle(modelName, options, otherVeh, replaceWholeCollection)`

Installed definition: `lua/ge/extensions/core/vehicles.lua`.

- `_replaceVehicle` either reuses/replaces the selected vehicle or falls back to `_spawnNewVehicle`.
- The third `otherVeh` argument selects the exact object to replace. The adapter resolves the operation's recorded ID with installed `getObjectByID` and passes that object, so rollback/Undo do not implicitly target whichever vehicle happens to be current later.
- The public wrapper returns `vehicle, {vehicles}` for a single vehicle; a failed internal multi-vehicle path can propagate `nil`.
- A returned vehicle object is the synchronous acceptance signal used by the adapter.
- The first returned object exposes the actual target ID through the installed `getID()` convention (`getId()` is also observed elsewhere). The adapter requires this ID and records the extraction strategy; an object without usable ID evidence is ambiguous failure.
- `false`, `nil`, or an exception is immediate `vehicle_replace_rejected`; the pipeline does not wait for a timeout.
- A non-`nil` object is not final success. `lua/ge/main.lua` emits `onVehicleSpawned(vid, vehicle)` after GE-side construction, and the randomizer then reads back the current model and `config.partConfigFilename`.
- `_replaceVehicle` also emits `onVehicleReplaced`, but that hook occurs before full spawned-state confirmation and is not used as completion.

Limitation: the hook contains no operation token or requested config. The extension supplies its own token, exact target ID, and post-hook state equality.

### `core_vehicle_partmgmt.setPartsTreeConfig(tree, respawn)`

Installed definition: `lua/ge/extensions/core/vehicle/partmgmt.lua`.

- The function calls `mergeConfig({partsTree = tree}, respawn)` and has no explicit return: normal return type is `nil`.
- With `respawn=true`, `mergeConfig` updates cached config and calls `vehicle:respawn(serializedConfig)`.
- Missing active vehicle or malformed input logs and returns `nil`, indistinguishable from synchronous success.
- The adapter therefore accepts only the documented `nil` contract as pending confirmation; an explicit `false` or exception becomes `parts_apply_rejected` immediately.
- Completion uses `onVehicleSpawned`, followed by read-back of every requested slot path/candidate.

Limitation: because both acceptance and an early internal rejection can return `nil`, post-event verification and timeout/rollback remain mandatory.

### `core_vehicle_partmgmt.setConfigVars(values, respawn)`

Installed definition: `lua/ge/extensions/core/vehicle/partmgmt.lua`.

- The function calls `mergeConfig({vars = values}, respawn)` and normally returns `nil`.
- With `respawn=true`, it follows the same `vehicle:respawn` path as parts.
- Explicit `false` or an exception becomes `tuning_apply_rejected`; normal `nil` means pending event confirmation.
- Completion uses `onVehicleSpawned`, but only while the active expectation phase is tuning and only after requested numeric values match `config.vars`.

An event that satisfies a replace wait cannot satisfy a tuning wait merely because both use the same hook; phase and state are both checked.

### `core_vehicle_partmgmt.setConfigPaints(paints, respawn)`

Installed definition: `lua/ge/extensions/core/vehicle/partmgmt.lua`.

- The function calls `mergeConfig({paints = paints}, respawn)` and normally returns `nil`.
- The project passes `respawn=false`. This updates live vehicle colors and serialized config without `vehicle:respawn`.
- No `onVehicleSpawned` completion hook is expected for this write.
- Explicit `false` or an exception becomes `paint_apply_rejected`; normal `nil` is followed by `getConfig()` read-back.
- Installed `validateVehiclePaint` supplies defaults for `baseColor`, `metallic`, `roughness`, `clearcoat`, and `clearcoatRoughness`. Verification therefore compares only requested supported fields, accepts equivalent array/object colors and small float normalization, and permits extra returned fields.
- An unavailable/stale immediate read starts a two-second, interval/attempt-bounded `onUpdate` read-back. Significant mismatch at the bound becomes `paint_apply_unconfirmed` and rolls back. No paint spawn event is expected.

### Read calls

| Call | Installed return behavior | Project validation |
| --- | --- | --- |
| `core_vehicle_partmgmt.getConfig()` | configuration table or `nil` when no player data | require table, deep-copy |
| `core_vehicle_manager.getPlayerVehicleData()` | loaded cached data or `nil` | require table |
| `core_vehicles.getModelList(true)` | wrapper with `models` | require expected table |
| `core_vehicles.getConfigList(true)` | wrapper with `configs` | require expected table |
| `getPlayerVehicle(0)` | current vehicle or `nil` | require object for model lookup |
| `be:getPlayerVehicleID(0)` | numeric ID; negative means absent | normalize absence to `nil` |

## VFS JSON persistence evidence

Installed definition: `lua/common/utils.lua`.

- `jsonReadFile(filename)` opens the supplied VFS path, decodes JSON, and returns a table/value or `nil` on failure.
- `jsonWriteFile(filename, obj, pretty, precision, atomicWrite)` encodes the object. With `atomicWrite=true`, it writes a temporary sibling and treats `FS:renameFile(temp, filename) == 0` as the final replacement result.
- Installed VFS methods also expose directory, find, copy, remove, and rename operations, but source presence alone did not establish one cross-platform multi-file transaction contract for this project.

The selected design is therefore a single bounded library plus one controlled last-known-good path. The adapter owns all three constant paths; imported IDs/names never choose them. Before a primary write, the caller supplies the already validated current library for the backup. Both write and read-back results are checked. The project calls this recovery, not atomic or crash-proof storage.

Evidence classification:

| Claim | Evidence |
| --- | --- |
| JSON helper signatures and temp/rename branch | Installed source |
| Schema/storage/failure/recovery decisions | Pure and mocked automated tests |
| Primary corruption recovery after a real BeamNG restart | Pending interactive evidence |
| Persistence across two machines | Pending multi-PC evidence |

## Hook sequence

Relevant installed source:

- `lua/ge/extensions/core/vehicle/manager.lua` constructs GE vehicle data, calls global `vehicleSpawned(objID)`, triggers UI `VehicleChange`, and may then enter the vehicle.
- `lua/ge/main.lua` implements `vehicleSpawned`: invalidate cache, call `onPreVehicleSpawned`, then `onVehicleSpawned`.
- `lua/ge/main.lua` implements `vehicleSwitched`, triggering `onVehicleSwitched(oldId, newId, player)` and UI `VehicleFocusChanged`.
- `lua/ge/extensions/core/modmanager.lua` emits `onModActivated` and `onModDeactivated` with copied mod data.

Source-derived expectations:

| Operation | Hook used | State verification |
| --- | --- | --- |
| replace vehicle | `onVehicleSpawned` | player vehicle ID, model, config filename/key |
| parts tree with respawn | `onVehicleSpawned` | player vehicle ID, model, every requested path/candidate |
| tuning with respawn | `onVehicleSpawned` | player vehicle ID, model, every requested value |
| paints without respawn | none | immediate or bounded deferred requested-field read-back |

The actual ordering/timing in a live world remains Pending interactive evidence.

## Registry source evidence

Installed definition: `lua/ge/extensions/core/vehicles.lua`.

`getSourceAttr(path)` returns:

- `BeamNG - Official` when the real path is below the installed game path;
- `Custom` for a non-official `.pc` path;
- `Mod` otherwise.

During configuration normalization, `core_modmanager.getModFromPath(configFilename, true)` resolves mounted ownership through `FS:getOriginArchivePathRelative` and can add `modID`/display source. The adapter records that exact path-ownership evidence as well. Consequently:

- exact `Custom`, `userSaved`, or `player` evidence maps to `user`;
- `modID`/`modId` maps to `mod` even on an official parent model;
- confirmed config-path ownership maps to `mod`, including mounted external/forum ZIPs, without inheriting from the parent model;
- exact `BeamNG - Official` maps to `official`;
- arbitrary titles without mod identity remain `unknown` instead of being guessed as mods.

The original label is preserved for diagnostics. `Everything` includes unknown entries; Official-only and Mods-only exclude them.

## Loaded configuration identity evidence

`getConfig().partConfigFilename` is present for file-backed configurations, but installed code also accepts config tables and generated state. Exact model is always required. The implementation then tries normalized path, model-scoped registry key/path, and a minimal stable selected-parts/tuning signature. Correct model alone is never claimed as the exact requested configuration; lack of proof is `config_identity_unverified`.

## Candidate part and safety evidence

`jbeamIO.getAvailableParts(ioCtx)` exposes UI metadata per candidate, including `modName` where present. `jbeamIO.getPart(ioCtx, candidate)` exposes each candidate's own `powertrain`, `energyStorage`, wheels, brakes, hydros, controller, and slot data. Candidate lookups are cached once per snapshot and previous/selected provenance stays separate.

Installed metadata supports a conservative graph, not a universal drivability ontology. No contract proves that all registered content has fuel, a battery, an engine, a gearbox, four wheels, steering, propulsion, or exactly one differential. Exact model type and loaded functional sections therefore select dynamic profiles; trailers/props omit road-only requirements and insufficient unusual layouts remain `uncertain`.

## Model type evidence

Installed selector/editor code enumerates exact types including `Car`, `Truck`, `Automation`, `Trailer`, `Prop`, `Utility`, `Traffic`, and `Unknown`. Content hardening therefore uses explicit boolean metadata or exact normalized `Type` values for Automation, trailer, and prop detection. Model-key or substring heuristics are not used.

## Slots and hierarchy

Relevant installed source:

- `lua/common/jbeam/io.lua` converts legacy `slots` rows into `slots2`, preserving option-table metadata such as `coreSlot`.
- `lua/common/jbeam/slotSystem.lua` creates `config.partsTree`, `path`, `chosenPartName`, `suitablePartNames`, and children.
- `getCompatiblePartNamesForSlot` supplies current allow/deny-compatible names.
- `setPartsTreeConfig` is the supported writer; deprecated `setPartsConfig` only logs an error.

The loaded tree is the source of truth. A parent part supplies child slot definitions; replacing it can change descendants and candidates. This is the evidence for deferring descendants until a fresh reload/snapshot.

## Tuning metadata and correlation finding

Installed definition: `lua/common/jbeam/variables.lua`.

Processed range variables retain `name`, numeric `min`, `max`, `default`, selected `val`, display range, calculated `step`, `stepDis`, `unit`, and display `category`/`subCategory`. Variables are merged across loaded parts.

No explicit paired-variable/correlation group ID or documented semantic grouping contract was found. Display category is not proof that two variables must share a value. Therefore 0.4.0-alpha.1 does not infer correlations from names, categories, front/rear wording, or part concepts.

The pure normalizer supports only explicit synthetic/future metadata (`correlationGroup` plus `correlationStrategy = "shared_normalized_sample"`). This architecture is tested, but no current BeamNG content correlation is claimed.

## UI host evidence

Installed `ui/modules/apps` contains both `replace: true` and `replace: false` directives. Because this app's template includes a stylesheet link plus its section root, it keeps `replace: false`. The custom-element selector is explicitly `display: block` with full width/height and zero minimums, matching the safe host-sizing pattern without relying on replacement semantics.

Visual overflow, minimum size, scaling, keyboard focus, and controller behavior remain Pending interactive tests.

## Unresolved and interactive-only evidence

- Generic mechanical drivability across unconventional or third-party vehicles cannot be proven from the identified metadata.
- Exact live timing of reload hooks, UI rendering, and physics readiness remains unobserved.
- Representative third-party config/full-vehicle/part/wheel packs were not installed or executed.
- User-saved config discovery depends on the active game's registry/user-folder state.
- Cross-platform ZIP byte identity requires comparing the real final Windows and CI/Linux archives.
