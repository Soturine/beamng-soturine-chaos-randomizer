# Interactive Test Report — 0.5.0-alpha.1

Status: historical maintainer observation, **not** alpha.2 approval.

Evidence labels:

```text
Maintainer-observed on 0.5.0-alpha.1
External screenshot evidence supplied during development
```

## Environment reported by the maintainer

- BeamNG.drive `0.38.6`;
- approximately 104 enabled mods;
- 212 indexed vehicles;
- 5,681 indexed configurations;
- screenshots supplied externally during development.

The exact mod list, clean-profile isolation, per-case log bundle, and repeat count were not captured in the repository. Therefore these are observations, not formal Passed rows.

## Observed working behavior

- The ZIP was recognized by Mod Manager.
- The UI App appeared in the selector with its icon and description.
- The app could be added, moved, and resized.
- The index found mod vehicles and configurations.
- Mod vehicles were selected and loaded.
- The former visible **Random Config** selected a normal vehicle and an existing configuration.
- Full Random behaved better on vanilla vehicles.
- Scramble produced substantially chaotic results on some vehicles/mods, including doors, glass, accessories, panels, wheels, drag parts, paint, and removed optional parts.

## Observed failures and instability

Messages seen in game included:

```text
Multiple vehicle switches occurred before the replacement target was known
Operation cancelled because the active vehicle changed
Operation cancelled because an unrelated vehicle switch occurred
Critical or required parts are missing after reload
No active vehicle configuration was found
Erro ao carregar veículo
Veículo: 'heritage'
```

Random Config generally behaved as a ready-configuration draw. Scramble was partial: sometimes extensive, sometimes limited to nearby variants, and sometimes cancelled after a reload/ID change. Full Random selected and spawned vehicles, including mods, but frequently lost its target after spawn and stopped before complete randomization, effectively resembling Random Config.

One mod configuration failed to load, the previous vehicle disappeared, no replacement remained active, and all three primary actions then reported no active configuration. This was the key recoverable-transaction defect addressed by alpha.2.

The app was also judged too large to leave open during gameplay. The external screenshots did not expose a reliable project-controlled Mod Manager package-description contract; alpha.2 therefore changes the UI App metadata/icon but does not ship speculative `mod_info` metadata.

## Result accounting

These observations are retained as qualitative regression input only:

```text
alpha.2 Interactive passed: 0
alpha.2 Interactive failed: 0
alpha.2 Interactive pending: 50
```

The alpha.2 cases must be executed again using [the dedicated plan](INTERACTIVE_TEST_PLAN_0.5.0-alpha.2.md).
