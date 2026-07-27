# User guide

## Start an operation

Open the Chaos tab and choose Random Car, Scramble, or Full Random. The app shows the logical target, current concrete candidate, phase, readback, coverage, recovery, and progress. Normal operation should not require pausing.

- Use **Random Car** for a complete installed configuration with no part scramble.
- Use **Scramble** to mutate the current vehicle.
- Use **Full Random** for replacement followed by the full mutation pipeline.
- Use **Cancel** at any time; cancellation invalidates pending callbacks and releases Busy after bounded rollback/cleanup.

## Chaos and seeds

Chaos controls how many eligible items are selected and how broadly values move. At 100, every unlocked, valid, supported item is processed or classified with an explicit reason. A changed count may be lower than a processed count when the game clamps or only one value exists.

Random seed mode generates fresh entropy. Fixed mode reuses the entered seed. Reproducibility depends on the same BeamNG build, mounted content, starting vehicle, settings, and generator contract.

## Safety and fuel

Protect Critical Parts is conservative metadata protection, not a drivability guarantee. Combustion fuel tanks are verified at no less than 10% capacity. Batteries, N2O, air, hydraulic, and unknown storages are not modified by that floor.

## Other areas

- Garage stores and compares explicit Vehicle DNA snapshots.
- Race generates competitors sequentially and preserves historical Lineup data compatibility.
- Placement previews and spawns verified saved vehicles.
- AI Director controls only confirmed managed targets when the necessary BeamNG capability is available.

See the [feature guides](features/), [installation](INSTALLATION.md), and [troubleshooting](TROUBLESHOOTING.md).
