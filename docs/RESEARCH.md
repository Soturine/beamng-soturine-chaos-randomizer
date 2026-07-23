# BeamNG.drive API Research

Research date: 2026-07-23

This document records the evidence used for the first alpha of Soturine's Chaos Randomizer. The installed game source is the primary compatibility reference. Public documentation is used to confirm concepts and packaging rules. Historical projects were inspected for behavior only; this project is a clean-room implementation.

## Environment

| Item | Detected value | Evidence |
| --- | --- | --- |
| Operating system | Windows | Local development environment |
| Steam root | `C:\\Program Files (x86)\\Steam` | Steam registry and `libraryfolders.vdf` |
| Steam library | `D:\\SteamLibrary` | `libraryfolders.vdf` contains app 284160 |
| Game install | `D:\\SteamLibrary\\steamapps\\common\\BeamNG.drive` | Steam manifest and executable |
| Game version | `0.38.6.0.19963` | `BeamNG.drive.exe` file/product version |
| Steam build | `23007233` | `appmanifest_284160.acf` |
| User-folder root | `C:\\Users\\rafael\\AppData\\Local\\BeamNG.drive` | Existing BeamNG user data |
| Last-run profile | `0.36` (`version.txt` says `0.36.4.0`) | Existing user folders and `version.txt` |
| Expected 0.38 profile | `C:\\Users\\rafael\\AppData\\Local\\BeamNG.drive\\0.38` | Versioned user-folder convention; it did not exist during research |
| Repository workspace | `C:\\Users\\rafael\\Documents\\soturine_chaos_randomizer` | Current Git checkout |
| Intended unpacked path | `...\\0.38\\mods\\unpacked\\soturine_chaos_randomizer` | Official unpacked-mod layout; not created during research |

BeamNG 0.38 had not been launched in this profile after the installed update, so no `0.38` user folder, `mods`, or `mods/unpacked` directory existed. The game itself is accessible, including its Lua and UI source. No in-game validation had been performed when this document was written.

## Official documentation reviewed

- [Lua extensions](https://documentation.beamng.com/modding/programming/extensions/) confirms extension tables, explicit loading, hooks, lifecycle methods, dependencies, and the three Lua VM locations.
- [Programming languages](https://documentation.beamng.com/modding/programming/languages/) recommends keeping logic in Lua and limiting JavaScript to UI work; it also describes the separate Lua virtual machines.
- [Creating an app](https://documentation.beamng.com/modding/ui/app_creation/) documents AngularJS `beamng.apps` directives and the required `app.js`, `app.json`, and `app.png` files.
- [Slots](https://documentation.beamng.com/modding/vehicle/sections/slots/) documents `slotType`, the hierarchical parent/child model, `coreSlot`, and slot variables.
- [Slots2](https://documentation.beamng.com/modding/vehicle/sections/slots/slots2/) documents `name`, `allowTypes`, `denyTypes`, and the precedence of deny types.
- [Vehicle configurations](https://documentation.beamng.com/modding/vehicle/tutorials/configs/) documents `.pc` parts, tuning variables, paints, model keys, and config metadata.
- [Variables](https://documentation.beamng.com/modding/vehicle/sections/variables/) documents numeric `default`, `min`, `max`, `stepDis`, and `hideInUI` metadata.
- [Correctly packing mods](https://documentation.beamng.com/modding/mod-support/mod_packing/) confirms that `lua`, `ui`, and `settings` must be top-level ZIP directories, with no enclosing mod-name folder.
- [User folder](https://documentation.beamng.com/support/userfolder/) documents versioned user data, `mods`, settings, and saved vehicle configurations.
- [Performance](https://documentation.beamng.com/modding/programming/performance/) documents Lua profiling and garbage-collection considerations.
- [Lua console](https://documentation.beamng.com/modding/programming/console/) documents `FS:findFiles`, logging, and profiler functions available in the shipped console/runtime.
- [Mod support](https://documentation.beamng.com/modding/mod-support/) and [overwriting guidance](https://documentation.beamng.com/modding/mod-support/overwritting/) require correct packing, console-error checks, and avoiding stock-file overrides.

The official documentation explicitly notes that programming documentation is incomplete and that current source is often the definitive API reference. For that reason, the exact calls below are tied to the installed 0.38.6 source rather than treated as long-term public contracts.

## Installed UI framework

BeamNG 0.38.6 contains both `ui/modules` and `ui/ui-vue`, but the installed app registry at `lua/ge/extensions/ui/apps.lua` still scans `/ui/modules/apps/**/app.json`. Current built-in examples such as `SimpleTrip` and `SimplePowertrainControl` use AngularJS directives, `bngApi.engineLua`, and `scope.$on(...)` events.

The first alpha therefore uses the documented and installed AngularJS UI App format:

```text
ui/modules/apps/soturineChaosRandomizer/
  app.json
  app.js
  app.html
  app.css
  app.png
```

This is an intentional 0.38 compatibility decision, not an assumption that all BeamNG UI will remain AngularJS indefinitely.

## APIs confirmed from installed 0.38.6 source

### Extension and UI bridge

| Capability | Confirmed mechanism | Installed source |
| --- | --- | --- |
| Load GE extension | `extensions.load("soturineChaosRandomizer")` | `lua/common/extensions.lua`; official docs |
| Extension lifecycle | returned table with hooks such as `onExtensionLoaded`, `onUpdate` | `lua/ge/main.lua`; official docs |
| Lua to UI | `guihooks.trigger(eventName, payload)` | Used throughout `lua/ge/extensions` |
| UI to Lua | `bngApi.engineLua(command, callback)` | Current built-in UI apps |
| Safe UI argument encoding | `bngApi.serializeToLua(value)` | Current installed UI modules |
| App discovery | `/ui/modules/apps/**/app.json` | `lua/ge/extensions/ui/apps.lua` |

### Current vehicle and configuration

| Capability | Confirmed mechanism | Notes |
| --- | --- | --- |
| Current vehicle object | `getPlayerVehicle(0)` | Returns the active player vehicle or `nil` |
| Current vehicle ID | `be:getPlayerVehicleID(0)` | `-1` means no active vehicle in current code |
| Current loaded data | `core_vehicle_manager.getPlayerVehicleData()` | Returns cached vehicle data including `ioCtx`, `config`, `vdata`, and vehicle directory |
| Current full config | `core_vehicle_partmgmt.getConfig()` | Returns the current config; callers must copy before mutation |
| Current model key | active vehicle `JBeam` or `getJBeamFilename()` | Model key used by the registry and spawner |

Installed definitions are in:

- `lua/ge/extensions/core/vehicle/manager.lua`
- `lua/ge/extensions/core/vehicle/partmgmt.lua`

### Vehicle and configuration registry

| Capability | Confirmed mechanism | Return shape in 0.38.6 |
| --- | --- | --- |
| Models | `core_vehicles.getModelList(array)` | `{models=..., filters=..., displayInfo=...}` |
| Configurations | `core_vehicles.getConfigList(array)` | `{configs=..., filters=..., displayInfo=...}` |
| One model | `core_vehicles.getModel(modelKey)` | model plus configuration map |
| One configuration | `core_vehicles.getConfig(modelKey, configKey)` | normalized configuration metadata |
| Replace current vehicle | `core_vehicles.replaceVehicle(modelKey, options)` | `options.config` may be a registry/path selection or configuration table |

The registry code reads mounted VFS content. It classifies official content, custom `.pc` files, and mod content; configuration metadata contains `model_key`, `key`, `pcFilename`, display data, and source information. This lets the randomizer see enabled config packs and mod vehicles without opening ZIP files itself.

Installed definition: `lua/ge/extensions/core/vehicles.lua`.

### Parts and slots

BeamNG 0.38 uses a hierarchical configuration tree:

```text
config.partsTree
  chosenPartName
  suitablePartNames
  children
    <slot id>
      path
      chosenPartName
      suitablePartNames
      children
```

The installed slot system builds this tree during vehicle loading. Candidate names in each node have already passed the current slot compatibility rules.

| Capability | Confirmed mechanism | Compatibility decision |
| --- | --- | --- |
| Available part metadata | `jbeamIO.getAvailableParts(ioCtx)` | Adapter only; returned tables are treated as read-only |
| Load one part definition | `jbeamIO.getPart(ioCtx, partName)` | Used to recover the parent slot definition |
| Compatible candidates | `jbeamIO.getCompatiblePartNamesForSlot(ioCtx, slotDef, slotMap)` | Supports legacy `slots` and current `slots2` |
| Current compatible tree | `config.partsTree` | Preferred mutation input because compatibility is already resolved |
| Apply a tree | `core_vehicle_partmgmt.setPartsTreeConfig(tree, true)` | One batched respawn per mutation pass |

`jbeamIO.getAvailableSlotNameMap` exists but is explicitly marked deprecated and incompatible with `slots2`. `jbeamIO.getAvailableSlotMap` is absent from the installed export. It must not be used.

`core_vehicle_partmgmt.setPartsConfig` still exists only as a compatibility stub and logs: `please use the new function setPartsTreeConfig instead`. It must not be used.

`coreSlot` is present on the parent part's slot definition, and official documentation says it removes the empty choice. The loaded `partsTree` does not retain `coreSlot`, so the adapter/scanner must match every child node back to its parent part's `slots` or `slots2` definition before allowing removal.

Installed definitions are in:

- `lua/common/jbeam/io.lua`
- `lua/common/jbeam/slotSystem.lua`
- `lua/common/jbeam/loader.lua`

### Tuning and paints

| Capability | Confirmed mechanism | Notes |
| --- | --- | --- |
| Tuning metadata | `playerVehicleData.vdata.variables` | Numeric metadata includes default/min/max and display step fields |
| Current chosen tuning | `config.vars` | Missing entries imply defaults |
| Apply tuning | `core_vehicle_partmgmt.setConfigVars(values, true)` | Respawn required for final parts to consume values |
| Current paints | `config.paints` | Paint count is vehicle/config dependent |
| Apply paints | `core_vehicle_partmgmt.setConfigPaints(paints, false)` | Updates the stored config and live colors |
| Live one-paint update | `core_vehicle_manager.liveUpdateVehicleColors(id, vehicle, index, paint)` | Current implementation handles indices exposed by the config |

The randomizer will only mutate valid numeric, visible tuning variables, clamp all output, quantize when usable step metadata exists, and preserve unsupported fields. It will use the number of paint entries exposed by the loaded configuration rather than assuming three.

### VFS, events, notifications, and persistence

| Capability | Confirmed mechanism | Notes |
| --- | --- | --- |
| Mounted file discovery | `FS:findFiles(path, pattern, depth, includeFiles, includeDirs)` | Fallback only; registries are preferred |
| File presence | `FS:fileExists(path)` | Adapter wrapper |
| JSON persistence | `jsonReadFile` / `jsonWriteFile` | User settings path with packaged defaults fallback |
| User notification | `guihooks.trigger('Message', payload)` | Short result/error notification |
| Vehicle ready signal | `onVehicleSpawned(vehicleId, vehicle)` | Hook emitted in `lua/ge/main.lua` after pre-spawn processing |
| Manual vehicle switch | `onVehicleSwitched(oldId, newId, player)` | Cancels a mismatched active operation |
| Vehicle reset | `onVehicleResetted(vehicleId)` | Recorded but not used as a reload completion substitute |
| Vehicle destruction | `onVehicleDestroyed(vehicleId)` | Cancels when the target disappears |

The exact timing of spawn callbacks after every third-party vehicle respawn is an internal behavior and still requires in-game stress validation. All waits therefore have a timeout and operation token.

## APIs that remain uncertain or intentionally deferred

- A stable, public powertrain-graph API capable of proving generic drivability for every mod vehicle was not identified. Alpha validation is conservative and metadata/slot based, and is documented as best effort.
- A stable mod-manager hook that fires for every enable/disable/change scenario was not confirmed. Users get an explicit `Reindex Content` action; common lifecycle hooks may invalidate the cache when observed.
- The installed registry exposes source labels and mod IDs, but exact source ownership is not guaranteed for every user config or unusual mounted pack. Uncertain content is labeled `unknown`.
- User configuration discovery depends on registry/VFS settings and the game's `Include custom .PC configurations` behavior. The randomizer does not manually scan arbitrary personal directories.
- Saving generated configurations is intentionally deferred until its current API and repository expectations receive in-game validation.
- Paint-design/skin mutation is possible through the parts tree, but specialized skin semantics are not assumed beyond compatible slot candidates.
- In-game lifecycle, timeout, rollback, UI scale, controller navigation, and package installation behavior were not validated during research.

## Historical and related projects

No source or artwork from the projects below is included. Ideas were converted into independent requirements and then implemented against current APIs.

| Project | URL | License finding | Useful behavior | Obsolete assumptions or weaknesses | Independent response |
| --- | --- | --- | --- | --- | --- |
| Crazy Contraptions Remastered | https://github.com/angelo234/crazycontraptions_remastered_angelo234 | MIT, copyright angelo234 (2022) | Random parts, tuning, paints, fuel/final-drive heuristics, optional empty parts | Uses global `math.random`; flat `config.parts`; removed `getAvailableSlotMap`; deprecated `setPartsConfig`; shallow candidate mutation; name-only classification; assumes three paints; multiple reloads | Isolated seeded RNG, hierarchical slots, immutable copies, bounded passes, metadata-first validation, dynamic paint count |
| Part Randomizer / Crazy Contraptions | https://www.beamng.com/resources/part-randomizer-crazy-contraptions.18490/ | No source license identified; treat as all-rights-reserved | Demonstrates demand for one-click part chaos | Marked outdated; no usable current API evidence | Behavior reference only |
| Random Vehicle/Config Spawner | https://www.beamng.com/resources/random-vehicle-config-spawner.635/ | No source license identified; treat as all-rights-reserved | Separate random model and random config actions | 2021-era app reported broken in later versions | Registry-backed selectors and explicit error reporting |
| Breb's Random Vehicle Spawner | https://www.beamng.com/resources/brebs-random-vehicle-spawner.21324/ | No source license identified; treat as all-rights-reserved | Automation/prop/trailer filters; equal-per-vehicle fairness | 2022 release; compatibility reports vary | Fairness is an explicit, tested selector policy |
| Vehicle And Part Randomizer | https://www.beamng.com/resources/vehicle-and-part-randomizer.34361/ | No source license identified; treat as all-rights-reserved | Combined vehicle and part workflow | Marked outdated after part-system changes; ImGui window persistence/usability reports | Standard UI App plus current `partsTree` APIs |
| Used Car Generator | https://beamng.com/resources/used-car-generator.30414/ | No source license identified; treat as all-rights-reserved | Seed reuse and bounded procedural generation | Focuses on vehicle wear/location rather than compatible part mutation | Shareable operation seeds and bounded state machine |

### Clean-room conclusions

The most important historical lesson is what not to carry forward. Current BeamNG already calculates compatible candidates for each loaded tree node; forcing a global part into a guessed slot is unnecessary and dangerous. The implementation will never copy API-owned candidate arrays merely by reference, will never add an empty entry to a shared slot table, and will never rely on old flat-map APIs.

## Compatibility baseline

The implementation baseline is the locally installed `0.38.6.0.19963`. It may work on nearby 0.38 builds, but only 0.38.6 source compatibility is claimed until in-game tests are performed. Internal BeamNG APIs are isolated in `apiAdapter.lua` so future migrations do not spread through selection, mutation, state, and UI code.
