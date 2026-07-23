# Compatibility

## Current target

The first alpha targets **BeamNG.drive 0.38.6**. The exact inspected executable version is `0.38.6.0.19963`, Steam build `23007233`.

This status means the adapter was written against the installed 0.38.6 Lua/UI source and the pure modules ran in its Lua 5.1 console. It does not mean the full interactive matrix has passed. See [Testing](TESTING.md).

| BeamNG version | Status | Notes |
| --- | --- | --- |
| 0.38.6 | Alpha target | API inspected; syntax/runtime/package checks pass; live UI/gameplay pending |
| 0.38.x other builds | Unknown | May work, but exact internal API compatibility is unverified |
| 0.37 and older | Unsupported | Hierarchical API and UI assumptions are not backported |
| Newer than 0.38.6 | Unknown | Revalidate `apiAdapter.lua` before claiming support |

## Why an adapter is required

BeamNG's programming documentation notes that internal APIs can be incomplete or change. All direct calls to vehicle registry, current vehicle data, `jbeam/io`, hierarchical part management, spawn/replace, paints, tuning, VFS JSON, logging, and UI hooks are isolated in `apiAdapter.lua`.

The current implementation intentionally uses:

- `core_vehicles.getModelList(true)` and `getConfigList(true)`;
- `core_vehicles.replaceVehicle(...)`;
- `core_vehicle_manager.getPlayerVehicleData()`;
- `core_vehicle_partmgmt.getConfig()`;
- `core_vehicle_partmgmt.setPartsTreeConfig(...)`;
- `core_vehicle_partmgmt.setConfigVars(...)` and `setConfigPaints(...)`;
- `jbeam/io` parts, slot definitions, and current compatible candidates;
- the installed `/ui/modules/apps/**/app.json` AngularJS app registry.

The obsolete flat `setPartsConfig` path is not used.

## Content compatibility

| Content | Discovery behavior | Current confidence |
| --- | --- | --- |
| Official models/configs | Mounted registry; `BeamNG - Official` source | Implemented, live tests pending |
| Full mod vehicles | Mounted registry; mod ID/title when available | Implemented, representative tests pending |
| Config packs | Registry configuration source, including packs on official models | Automated fixture passes, live tests pending |
| User-saved configs | Registry `Custom` source when BeamNG exposes them | Implemented, live tests pending |
| Mod parts/accessories | Current `suitablePartNames` per loaded slot | Implemented, representative tests pending |
| Mod wheels/tires | Same compatibility candidates as other slots | Implemented, unusual wheel tests pending |
| Automation vehicles | Classified by registry metadata/key hints; opt-in | Live tests pending |
| Trailers | Classified by registry type metadata; opt-in | Live tests pending |
| Props | Classified by registry type metadata; opt-in | Live tests pending |
| Multi-vehicle configurations | Registry may expose them, but behavior is not validated | Treat as unknown |

Mounted ZIP content is discovered through BeamNG's registry/VFS. The randomizer does not enumerate or manually extract mod ZIP files.

The index is invalidated by the current 0.38 mod activation/deactivation hooks. If content changes outside those hooks, use **Reindex Content** before the next action.

## Source classification

The index preserves BeamNG's source metadata and normalizes it to:

- `official` for the current official label;
- `user` for current `Custom`/saved metadata;
- `mod` when a mod ID or mounted mod source/title is present;
- `unknown` when ownership cannot be established safely.

`Everything` includes unknown entries. `Official only` and `Mods only` require a matching source class. A mod configuration on an official vehicle is filtered by the configuration's source, so it remains available in Mods-only mode.

## Slot and part behavior

- The loaded vehicle's hierarchical `partsTree` is the source of truth.
- Candidate lists are copied before filtering; BeamNG-returned tables are not mutated in place.
- Only candidates already reported compatible for that exact slot are selected.
- Required/core metadata blocks empty choices.
- A parent change can expose new child paths; only new or changed slot signatures are considered in later bounded passes.
- BeamNG still performs final JBeam compatibility/loading. A bad third-party part can fail even when advertised as compatible.

## Tuning and paint behavior

Numeric variables require finite `min`/`max` metadata. Results are clamped and quantized when a positive step exists. Hidden, malformed, or nonnumeric variables are ignored. Variables are independent in this alpha; no speculative front/rear or drivetrain correlations are imposed.

Paint count is discovered dynamically from the current configuration. Existing paint table shapes are copied and only supported paint entries are updated. Skin/paint-design slot selection is not implemented.

## UI compatibility

BeamNG 0.38.6 still discovers UI Apps through `/ui/modules/apps` and AngularJS `beamng.apps`. The app uses local HTML/CSS/JavaScript only. Common scaling and controller behavior remain part of the pending interactive matrix.

## Reporting a compatibility result

Include:

- BeamNG full version/build;
- randomizer commit/version;
- operation, settings, and displayed seed;
- vehicle/configuration and relevant mod links/versions;
- whether the problem occurs without other mods;
- `beamng.log` lines tagged `SoturineChaosRandomizer`;
- whether Reindex Content and a clean profile change the result.
