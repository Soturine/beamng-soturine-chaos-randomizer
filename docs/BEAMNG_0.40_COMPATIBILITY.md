# BeamNG.drive 0.40 compatibility

Status for v0.7.12: **target BeamNG 0.40.4, minimum 0.39, live validation pending**.
Every row below was checked against the installed game source of
**0.40.4.0, build 296339** (Steam build 26298565, executable dated 2026-10-30),
not only against the patch notes. No game session of 0.40 has been run with
this mod yet, so nothing here is a live pass. `testedGameVersions` stays empty
until the owner runs the exact published ZIP.

Sources read on 2026-11-02: the
[0.40 patch notes](https://www.beamng.com/game/news/patch/beamng-drive-v0-40/),
[0.40.1](https://www.beamng.com/game/news/patch/beamng-drive-v0-40-1/),
[0.40.2](https://www.beamng.com/game/news/patch/beamng-drive-v0-40-2/),
[0.40.3](https://www.beamng.com/game/news/patch/beamng-drive-v0-40-3/),
[0.40.4](https://www.beamng.com/game/news/patch/beamng-drive-v0-40-4/) and the
[hotfix index](https://www.beamng.com/game/news/announce/beamng-drive-v0-40-hotfixes/).
No hotfix after 0.40.4 was published at that date.

## API impact matrix

| 0.40 change (source) | Mod call site | Risk | Change | Test | Status |
| --- | --- | --- | --- | --- | --- |
| Local split-screen: `core_multiseat.getPlayers()`, `be:getPlayerVehicleID(player)` per player | Race cleanup/remove/placement, AI start, Chaos target | NPC entered by player B deleted, teleported or driven by AI | `apiAdapter.humanOccupancy` covers every local player; delete, teleport and AI start refuse occupied vehicles; unknown never counts as free | `v040_split_screen_occupancy_*`, `v040_physical_side_effects_*` + 7 killed mutants | Fixed, live pending |
| Seat occupants: `gameplay_seatOccupants.getVehiclePresences(vehId)`; players walk into any car | same as above | passenger presence missed by a driver-only check | presences included | same | Fixed, live pending |
| Walking character is a `unicycle` vehicle | Scramble / Random Car / Full Random / route recording target | randomizing the character | refused with `player_on_foot` | `v040_chaos_refuses_walking_player_*`, `v040_recorded_route_lifecycle_*` | Fixed, live pending |
| `core_vehicle_configTarget`: implicit `getConfig` / `setPartsTreeConfig` / `setConfigVars` / `setConfigPaints` act on the configured player's car | Chaos writes and verification readback | writing to, and verifying against, another player's car | implicit calls only when no foreign target exists, else bound by vehicle ID; foreign implicit read refused | `v040_foreign_config_target_*` | Fixed, live pending |
| `setConfigOfVehicle` is now `mergeConfigOfVehicle` | Race background writes | merge vs replace semantics | none: the mod always passes partial patches, which merge as before | existing background-write tests | Verified by source |
| `ui_router.navigate`, `ChangeState`, `onUiChangedState`, `createVueApp`, `v-bng-panel`, `setWindowTitle` | none in the app | n/a | none | host export snapshot rejects removed names (`vBngPanel` fixture) | Not used |
| Runtime UI host exports (`@/bridge`, `@/services/*`, `@/common/directives`, `@/common/components/base`) | every SFC import | renamed/removed export blanks the app | named imports checked against a 0.40.4 snapshot | `test_host_export_removed_by_beamng_is_rejected` | Verified by source, live pending |
| `BngSmartSelect`, `vBngOnUiNav`, `vBngScopedNav`, `vBngTooltip`, `BngButton` | ScrSelect, shell, dialogs | removal | present in 0.40.4 | snapshot check | Verified by source |
| Vehicle Lua AI: `ai.driveUsingPath` sets mode `manual`; no AI-mode getter on GE objects | AI confirmation | confirmation never happened, dispatch shown as running | Vehicle Lua `ai.mode` probe; Destination/Route/Recorded confirm `manual` | `v040_ai_mode_probe_round_trips_through_vehicle_lua`, `v069_ai_mode_confirmation_*` | Fixed, live pending |
| `ai.startRecording` / `ai.stopRecording` / `ai.driveUsingPath{script}` (scriptai) | Recorded route | was a stub | implemented end to end | `v040_path_recorder_*`, `v040_recorded_*` | Implemented, live pending |
| `driveUsingPath{script}` places the car at `script[1]` | Recorded playback | every opponent stacked at one point | each script starts at that car's position | `v040_recorded_playback_starts_each_car_from_its_own_position` | Fixed before release |
| `vec3` is still a global Lua function (`mathlib.lua:49`); `ColorF` remains a callable class | aiAdapter, spawnApiAdapter, preview | wrong binding detection | none: `type(vec3)=="function"` is correct; preview already probes by calling | existing preview probe tests | Verified by source |
| `map.findClosestRoad(pos, radius)`, `map.getPath`, `map.getMap` | route planning | signature change | none | existing route tests | Verified by source |
| `spawn.safeTeleport(veh, pos, rot, ...)` | Race placement | signature change | none | existing placement tests | Verified by source |
| `core_vehicles.spawnNewVehicle/replaceVehicle`, `core_vehicle_manager.getVehicleData`, `jbeam/io getPart/getAvailableParts` | spawn, DNA, slot scan | signature change | none | existing tests | Verified by source |
| JBeam `slots2` everywhere (6115 official parts) and occupant slots (`seat_occupant`, `coreSlot: true`) | slot scanner, critical-slot policy | occupant slot emptied | none: the engine normalises `slots` into `slots2` (`jbeam/io.lua:83-105`), no official part declares both, and core slots are never emptied | existing core-slot tests | Verified by source |
| Cherrier Percheron (2-5 axles, retarder, 50+ chassis) | content index, validator | model-specific breakage | none: no model-specific code; classified generically | none specific | Live pending |
| Traffic setting rename `trafficParkedAmount` -> `trafficParkingAmount` | not used | n/a | none | n/a | Not used |
| Failed UI -> GE Lua commands are now logged | UI bridge | noisy log on rejection | none: commands are allow-listed | existing parity check | Live pending |
| PS5 | n/a | mods are not supported on PS5 at launch | the ZIP is PC-only | n/a | Not supported |

## What still needs the game

Live boot on 0.40.4, renderer (D3D11/D3D12/Vulkan), split-screen with two
local players, Percheron mutation, AI movement, Recorded playback and every
item in [v0.7.12 live results](testing/v0.7.12/LIVE_RESULTS.md).
