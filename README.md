# Soturine's Chaos Randomizer

Soturine's Chaos Randomizer is an experimental BeamNG.drive HUD App for
deterministic vehicle randomization. It combines bounded Chaos operations,
Vehicle DNA capture and restore, and multi-vehicle Race orchestration in one
native Runtime UI Vue app.

## Features

- **Random Car** selects and binds one verified replacement vehicle.
- **Scramble** changes the currently bound vehicle without spawning a clone.
- **Full Random** runs vehicle, parts, tuning, paint, validation, and recovery as
  one owned transaction.
- **Garage** stores, compares, imports, exports, mutates, and restores Vehicle
  DNA with explicit compatibility checks.
- **Race** previews generation and final-grid footprints without world mutation,
  generates isolated competitor slots, places owned vehicles, and controls only
  their managed AI.
- Reproducible seeds, locks, progress, diagnostics, cancellation, and Undo are
  available throughout the app.

## Current UI

The app has four destinations: Chaos, Garage, Race, and Settings. It uses
BeamNG Runtime UI components, controller/UINav navigation, an actual compact
presentation, localized status messages, and technical identifiers only in
explicit diagnostic views. Layout responds to measured app width while BeamNG
owns outer placement. Local artwork and CSS are packaged with the mod; runtime
access does not depend on a CDN or `node_modules`.

## Installation

1. Download the mod ZIP and checksum from the
   [latest GitHub release](https://github.com/Soturine/beamng-soturine-chaos-randomizer/releases/latest).
   Use the named mod asset, not GitHub's automatic source archive.
2. Verify the SHA-256 checksum.
3. Place the ZIP, without extracting it, in the active BeamNG user folder's
   `mods` directory.
4. Disable older copies of the Randomizer, start BeamNG, enter a level, then add
   the app from **UI Apps**.

See [Installation](docs/INSTALLATION.md) for exact verification and upgrade
steps.

## Quick start

Open **Chaos**, choose a seed mode, and run Random Car, Scramble, or Full
Random. Keep **Details** open when collecting evidence. Use **Cancel safely**
instead of deleting an in-flight vehicle. For Race, configure Cars first, wait
for every slot to reach a terminal state, then continue to Placement and Drive.

## Modes

- Chaos is single-target and enforces explicit physical ownership.
- Garage operations are data-first; destructive restore occurs only after
  preflight and confirmed target evidence.
- Race counts the player separately from generated opponents and gives each
  competitor a stable slot identity, generation, seed, and owned vehicle set.
- Settings controls content policies, locks, safety, persistence, language, and
  diagnostic detail.

## Compatibility

The declared target and minimum version live in
[`COMPATIBILITY.json`](COMPATIBILITY.json). Compatibility claims are
evidence-based: automated validation can pass while in-game validation remains
**Pending owner validation**. See
[BeamNG 0.39 compatibility](docs/BEAMNG_0.39_COMPATIBILITY.md) and
[current validation](docs/status/CURRENT_VALIDATION.md).

## Data and safety

The mod writes only its settings, cache, Vehicle DNA library, lineups, and
managed thumbnails below its own BeamNG user-data namespace. Imported data is
bounded and treated as inert JSON. Recovery and cleanup require operation,
generation, target, and ownership evidence; unrelated vehicles must never be
deleted or mutated.

Read [Security](SECURITY.md), [Safety model](docs/SAFETY_MODEL.md), and
[Vehicle DNA](docs/VEHICLE_DNA.md) before testing third-party content.

## Experimental limitations

- The project is published as a prerelease until the owner executes the
  versioned matrix against the downloaded release asset.
- Outer HUD placement and saved-frame migration belong to BeamNG's AppHost;
  the child app changes its content geometry but does not call private host APIs.
- Renderer-, driver-, mod-, and vehicle-specific behavior needs live evidence.
- Exact restore depends on compatible content; safe partial results are reported
  rather than silently claimed as exact.

## Documentation

- [User guide](docs/USER_GUIDE.md)
- [Architecture](docs/ARCHITECTURE.md)
- [UI protocol](docs/UI_PROTOCOL.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [Testing evidence](docs/testing/)
- [Changelog](CHANGELOG.md) and [GitHub Releases](https://github.com/Soturine/beamng-soturine-chaos-randomizer/releases)

## Development

The repository uses Lua compatible with the BeamNG runtime, Vue 3 SFCs, plain
runtime CSS, Node-based UI checks, and Python packaging tests. Start with:

```text
npm ci --ignore-scripts
npm run validate:version
npm run validate:sfc
npm run validate:graph
npm run validate:styles
npm run test:ui
python -m unittest discover -s tests -v
```

Build and validate the deterministic mod asset with
`python tools/package_mod.py` and `python tools/validate_package.py`.

## Contributing

Keep changes deterministic, bounded, and covered at the lowest useful layer.
Do not convert automated or fixture evidence into a live BeamNG claim. Follow
[`AGENTS.md`](AGENTS.md), preserve unrelated work, and update the appropriate
versioned evidence when behavior changes.

## License

Licensed under [Apache License 2.0](LICENSE). See [NOTICE](NOTICE) for required
attribution.
