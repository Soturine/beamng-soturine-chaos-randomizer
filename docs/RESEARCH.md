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

Machine-specific install, user-profile, and repository paths are intentionally omitted. Installed-source references below are paths relative to the BeamNG installation.

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
- The public wrapper returns `vehicle, {vehicles}` for a single vehicle; a failed internal multi-vehicle path can propagate `nil`.
- A returned vehicle object is the synchronous acceptance signal used by the adapter.
- `false`, `nil`, or an exception is immediate `vehicle_replace_rejected`; the pipeline does not wait for a timeout.
- A non-`nil` object is not final success. `lua/ge/main.lua` emits `onVehicleSpawned(vid, vehicle)` after GE-side construction, and the randomizer then reads back the current model and `config.partConfigFilename`.
- `_replaceVehicle` also emits `onVehicleReplaced`, but that hook occurs before full spawned-state confirmation and is not used as completion.

Limitation: the hook contains no operation token or requested config. The extension supplies its own token and requires post-hook state equality.

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
- Explicit `false` or an exception becomes `paint_apply_rejected`; normal `nil` is followed immediately by a `getConfig()` read-back.
- A mismatch or unavailable read becomes `paint_apply_unconfirmed` and rolls back when applicable.

### Read calls

| Call | Installed return behavior | Project validation |
| --- | --- | --- |
| `core_vehicle_partmgmt.getConfig()` | configuration table or `nil` when no player data | require table, deep-copy |
| `core_vehicle_manager.getPlayerVehicleData()` | loaded cached data or `nil` | require table |
| `core_vehicles.getModelList(true)` | wrapper with `models` | require expected table |
| `core_vehicles.getConfigList(true)` | wrapper with `configs` | require expected table |
| `getPlayerVehicle(0)` | current vehicle or `nil` | require object for model lookup |
| `be:getPlayerVehicleID(0)` | numeric ID; negative means absent | normalize absence to `nil` |

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
| paints without respawn | none | immediate paint-table read-back |

The actual ordering/timing in a live world remains Pending interactive evidence.

## Registry source evidence

Installed definition: `lua/ge/extensions/core/vehicles.lua`.

`getSourceAttr(path)` returns:

- `BeamNG - Official` when the real path is below the installed game path;
- `Custom` for a non-official `.pc` path;
- `Mod` otherwise.

During configuration normalization, `core_modmanager.getModFromPath` can add `modID` and replace the display `Source` with mod filename/title. Consequently:

- exact `Custom`, `userSaved`, or `player` evidence maps to `user`;
- `modID`/`modId` maps to `mod` even on an official parent model;
- exact `BeamNG - Official` maps to `official`;
- arbitrary titles without mod identity remain `unknown` instead of being guessed as mods.

The original label is preserved for diagnostics. `Everything` includes unknown entries; Official-only and Mods-only exclude them.

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

No explicit paired-variable/correlation group ID or documented semantic grouping contract was found. Display category is not proof that two variables must share a value. Therefore 0.2.0-alpha.1 does not infer correlations from names, categories, front/rear wording, or part concepts.

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
