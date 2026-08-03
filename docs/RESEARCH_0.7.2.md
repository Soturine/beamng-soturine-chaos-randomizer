# v0.7.2 research notes

Research was limited to the contracts needed for this rescue release. It is not
the complete post-v0.7.0 audit.

## Official sources

- [BeamNG UI modding](https://documentation.beamng.com/modding/ui/) establishes
  the supported UI extension surface.
- [Creating an app](https://documentation.beamng.com/modding/ui/app_creation/)
  documents HUD app metadata and placement.
- [BeamNG.drive v0.37 release notes](https://www.beamng.com/game/news/patch/beamng-drive-v0-37/)
  provide the public transition context for native Vue Runtime UI.

## Installed 0.39.2.1 contracts inspected

The installed Runtime UI AppHost loader, SFC style loader, vehicle manager, and
vehicle part-management sources were inspected read-only. The findings used by
the implementation are:

- the app entry is the colocated `app.vue` selected by AppHost;
- imported SFC styles must resolve to a packaged browser-loadable CSS asset;
- `core_vehicle_partmgmt.setConfigOfVehicle(vehicle, data, respawn)` can apply
  a configuration to the explicit vehicle object;
- player selection and target vehicle identity are distinct concepts and must
  not be conflated for Race background work.

No private resize API, Sass runtime loader, guessed vehicle API, or external
runtime dependency was introduced. Machine-specific installation paths are not
recorded in repository evidence.

