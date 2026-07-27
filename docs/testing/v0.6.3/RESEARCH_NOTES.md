# Research notes — 0.6.3

Access date: 2026-07-27. Sources inform compatibility hypotheses and API boundaries; they do not prove live behavior of this mod.

| Source | Claim used | Implementation impact | Limitation |
| --- | --- | --- | --- |
| [BeamNG extension documentation](https://docs.beamng.com/modding/programming/extensions/) | GE extensions use hooks/dependencies and frame updates | Preserve entrypoint/hooks and monotonic update processing | Public docs do not guarantee every internal API detail |
| [BeamNG UI App creation](https://documentation.beamng.com/modding/ui/app_creation/) | UI Apps use AngularJS/CEF app manifests and host sizing | Keep fixed bridge, app manifest, content sizing, and live visual gate | Rendering must still be checked in the target build |
| [BeamNG energy storage](https://documentation.beamng.com/modding/vehicle/sections/energystorage/) | Energy storage types represent distinct resources | Classify loaded storage type before applying a fuel floor | Third-party metadata may be incomplete or custom |
| [BeamNG mod packing](https://documentation.beamng.com/modding/mod-support/mod_packing/) | Installable mods require game-root paths in the archive | Enforce `lua/`, `ui/`, `settings/` at ZIP root | Repository submission metadata is a separate workflow |
| [BeamNG v0.35 release notes](https://beamng.com/game/news/patch/beamng-drive-v0-35/) | BeamNG systems and vehicle content evolve across updates | Avoid catalogs and discover current runtime metadata | Not the exact target build contract |
| [BeamNG forum: early `onVehicleSpawned`](https://www.beamng.com/threads/onvehiclespawned-is-called-to-early-by-the-game-which-leads-to-invalid-config-data.96054/) | Community report shows spawn callbacks can precede readable config data | Treat callbacks as candidate evidence only | Forum evidence is not an official API guarantee |

The installed first-party `0.38.6.0.19963` source was also inspected for `core_vehicle_manager`, `core_vehicle_partmgmt`, replacement/reload flows, UI hooks, and energy storage factories (`fuelTank`, `n2oTank`, `electricBattery`, and `pressureTank`). This primary local inspection motivated independent player/exact-ID capability checks and multi-evidence storage classification. Installed source inspection is not a live world test and may differ on another BeamNG build.
