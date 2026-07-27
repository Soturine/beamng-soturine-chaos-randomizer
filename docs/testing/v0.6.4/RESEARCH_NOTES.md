# Research notes — 0.6.4

Access date for every source: **2026-07-27**. Official BeamNG documentation and
the exact installed game source were preferred. These sources describe API and
data contracts; they do not prove that the mod passes live gameplay.

| Source | Claim used | Relevance / implementation impact | Limitation |
| --- | --- | --- | --- |
| https://documentation.beamng.com/modding/programming/extensions/ | `onUpdate` is an extension hook called once per GFX frame; extension source is the detailed contract | Keep housekeeping, polling, cancellation and real deadlines in GE update rather than UI or simulation time | Documentation does not guarantee third-party mod readiness timing |
| https://documentation.beamng.com/modding/ui/app_creation/ | UI apps use AngularJS and conventional `app.js`, `app.json`, `app.png`; selector PNG recommendation is 250×120 | Retain BeamNG app structure and render the new fox selector at 250×120 | Does not define host resize-event provenance in detail |
| https://documentation.beamng.com/modding/vehicle/sections/energystorage/ | `fuelTank`, `n2oTank`, `electricBattery`; unique storage names support multiple tanks; capacity/starting capacity have distinct roles | Separate storage categories, support multiple tanks, correlate the starting variable before correction | Custom controllers/mod metadata can still be incomplete |
| https://documentation.beamng.com/modding/vehicle/vehicle_system/controller/main/vehiclecontroller/ | Fuel ratio, fuel capacity and fuel volume are distinct values | Never confuse maximum capacity with remaining fuel; enforce 10% only on correlated current volume | Controller outputs may be unavailable during construction |
| https://documentation.beamng.com/modding/vehicle/sections/slots/ | `coreSlot` removes the empty-part choice; slot default is a fallback selection | Treat core absence as structural; do not reinterpret an undocumented mod `required` field as equivalent proof | Mods may implement additional private semantics, reported as uncertainty |
| https://documentation.beamng.com/modding/vehicle/sections/ | Vehicle sections/content are data-driven | Full-tree/current metadata discovery instead of fixed catalogs | Documentation cannot enumerate every custom section/controller |
| https://documentation.beamng.com/modding/vehicle/sections/nodes/ | Node groups can associate distinct systems/tanks | Do not assume one tank or one canonical group | Group presence alone does not expose a writable tuning variable |
| https://documentation.beamng.com/modding/vehicle/vehicle_system/electrics/ | Electrics exposes fuel ratio/low-fuel signals | Useful diagnostic corroboration, not a safe write target | Electrics is runtime/controller state, not configuration ownership proof |
| https://documentation.beamng.com/modding/programming/performance/ | Direct/current-player access patterns and bounded work matter | Poll bounded evidence and keep histories/telemetry capped | Performance guidance is not a measured budget for this mod |

## Installed primary source

Installed game: `D:\SteamLibrary\steamapps\common\BeamNG.drive`, executable
file/product version `0.38.6.0.19963`.

| Local source | Observation | Design impact | Limitation |
| --- | --- | --- | --- |
| `lua/ge/main.lua` (`update`) | GE calls `extensions.hook('onUpdate', dtReal, dtSim, dtRaw)` each update before GUI-conditional work | Pause-independent backend progress is available; no UI update dependency is needed | Source inspection is not a live scheduler trace |
| `lua/ge/extensions/core/vehicle/manager.lua` (`vehicleSpawned`, `getVehicleData`) | Manager stores the bundle and finishes GE construction before spawn hooks; player switch/enter and physics settlement are distinct | Callback is a candidate hint after partial construction, not final phase proof; exact-ID bundle is one evidence source | Internal API may change in later BeamNG builds |
| `lua/ge/extensions/core/vehicle/partmgmt.lua` (`mergeConfig`, `getConfig`) | Parts/tuning are merged into player config and the vehicle respawns; same ID can persist and desired config can appear before later lifecycle evidence | Observe player config independently, accept already-applied phase state, and do not require ID change/callback | Cache timing depends on vehicle/mod implementation |

The user profile logs available in this workspace were older than the installed
0.38.6 build and did not contain the owner's reported v0.6.3 sessions, so they
were not used as fabricated reproduction evidence.
