# Soturine's Chaos Randomizer

Soturine's Chaos Randomizer is an experimental BeamNG.drive UI App that creates repeatable vehicle chaos from the content actually loaded by the game. It discovers configurations, compatible part slots, tuning variables, and paint fields at runtime instead of maintaining a catalog of supported cars.

The current source is the **0.6.3 release candidate**. Automated validation is in progress and the exact candidate ZIP has not yet passed the mandatory live BeamNG smoke test. The latest published release remains available on the [GitHub releases page](https://github.com/Soturine/beamng-soturine-chaos-randomizer/releases/latest).

## Three Chaos actions

| Action | Result |
| --- | --- |
| **Random Car** | Loads one eligible installed configuration and stops after target and fuel readback. |
| **Scramble** | Keeps the current logical vehicle and randomizes compatible parts, newly exposed tuning, paint, and applicable fuel. |
| **Full Random** | Loads a random configuration, then runs the complete bounded Scramble pipeline. |

All actions are designed to run during normal gameplay without asking the user to pause or toggle a menu. A seed can replay project-owned choices when the game build, installed content, settings, and starting state are unchanged.

## What makes it different

- Runtime discovery covers official vehicles, user configurations, Automation exports, and mods through BeamNG-provided metadata.
- Parent-first part passes rescan after reload until a bounded fixed point, so newly introduced slots can participate.
- Tuning discovery also runs to a bounded fixed point and classifies every valid public variable at Chaos 100.
- Lifecycle state separates the logical target from concrete vehicle IDs that may be destroyed and recreated during replacement or reload.
- Writes remain bound to a coherently verified player-0 target; stale callbacks and generations are rejected.
- Combustion fuel storages receive a verified 10% capacity floor without treating batteries, N2O, air, or hydraulic reservoirs as fuel.
- Vehicle DNA, Garage, Race, Placement, and AI workflows preserve bounded storage and target-ownership contracts.

## Install

1. Download the release ZIP, not GitHub's automatic source archive.
2. Put the ZIP in the active BeamNG user folder's `mods` directory without extracting it.
3. Enable the mod, enter Freeroam, open UI Apps, and add **Soturine's Chaos Randomizer**.

The archive must contain `lua/`, `ui/`, and `settings/` at its root, with no wrapper directory. See the complete [installation guide](docs/INSTALLATION.md) and [troubleshooting guide](docs/TROUBLESHOOTING.md).

## Compatibility and evidence

- Inspected target: BeamNG.drive `0.38.6.0.19963`.
- Settings schema: 6. Vehicle DNA schema: 1. Generator: 6.
- Mod support is best effort: bad or incomplete metadata degrades or skips a feature with a reason instead of granting false success.
- Automated tests do not prove live gameplay, physics, mod compatibility, or CEF rendering.
- Tagging and release of 0.6.3 remain blocked until the exact final ZIP passes the live plan.

See [current validation](docs/status/CURRENT_VALIDATION.md) and the [compatibility matrix](docs/status/CURRENT_COMPATIBILITY_MATRIX.md).

## Documentation

- [User guide](docs/USER_GUIDE.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Testing](docs/TESTING.md)
- [Compatibility](docs/COMPATIBILITY.md)
- [Security](docs/SECURITY.md)
- [Chaos](docs/features/CHAOS.md), [Vehicle DNA](docs/features/VEHICLE_DNA.md), [Garage](docs/features/GARAGE.md), [Race](docs/features/RACE.md), [Placement](docs/features/PLACEMENT.md), [AI Director](docs/features/AI_DIRECTOR.md), [Locks](docs/features/LOCKS.md), and [Sharing](docs/features/SHARING.md)
- [0.6.3 validation workspace](docs/testing/v0.6.3/README.md)

Version history belongs in [CHANGELOG.md](CHANGELOG.md); planned work belongs in [ROADMAP.md](ROADMAP.md).

## Development

Contributions are welcome. Read [CONTRIBUTING.md](CONTRIBUTING.md), run the complete automated suite, and keep gameplay claims separate from live BeamNG evidence.

Licensed under the [MIT License](LICENSE). This independent project is not endorsed by BeamNG GmbH.
