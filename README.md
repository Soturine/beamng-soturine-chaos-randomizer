# Soturine's Chaos Randomizer

[![Status: Alpha](https://img.shields.io/badge/status-alpha-f97316)](ROADMAP.md)
[![BeamNG.drive 0.38.6](https://img.shields.io/badge/BeamNG.drive-0.38.6-555)](docs/COMPATIBILITY.md)
[![CI](https://github.com/Soturine/beamng-soturine-chaos-randomizer/actions/workflows/ci.yml/badge.svg)](https://github.com/Soturine/beamng-soturine-chaos-randomizer/actions/workflows/ci.yml)
[![License: Apache-2.0](https://img.shields.io/badge/license-Apache--2.0-blue)](LICENSE)

A dynamic vehicle, configuration, compatible-parts, tuning, wheel, and paint randomizer for BeamNG.drive. It discovers installed content through BeamNG's mounted registry, follows the current hierarchical slot tree, and uses reproducible operation seeds.

> **Alpha software:** the logic, package, and BeamNG Lua 5.1 runtime tests pass, but the interactive in-game matrix is still pending. Keep a normal copy of any configuration you care about and review [known limitations](#known-limitations) before use.

## Screenshots

Real in-game screenshots will be added after the interactive UI and gameplay test pass.

> Screenshot placeholder — compact main controls at the default app size.
>
> Screenshot placeholder — expanded Advanced settings and operation progress.

The original app-selector icon is included in the mod; no third-party artwork is bundled.

## Features

- **Random Config** chooses one complete eligible configuration without scrambling it.
- **Scramble** keeps the current model and mutates compatible parts, newly exposed nested slots, final tuning variables, and supported paints.
- **Full Random** loads a configuration and then runs the complete Scramble pipeline.
- A single **Chaos** slider controls mutation coverage, nested passes, missing-part probability, tuning spread, extremes, and paint contrast.
- **Allow Missing Parts** can empty optional slots, but never slots marked required or core by current metadata.
- **Keep Vehicle Drivable** applies conservative, metadata-based protection to known critical concepts. It is best-effort, not a guarantee.
- Vehicle-first and configuration-first fairness modes avoid overrepresenting vehicles with large configuration lists.
- Recent selections are avoided when alternatives exist.
- A local deterministic PRNG isolates the mod from BeamNG's global random state.
- Bounded event-driven reloads, cancellation tokens, timeouts, session blacklisting, rollback, and a ten-entry Undo history keep failures contained.
- No network calls, analytics, remote scripts, or CDN assets are used by the in-game mod.

## Controls

### Random Config

Selects from the installed BeamNG vehicle/configuration registry after applying content filters. Official configurations, mounted mod vehicles, mounted config packs, and safely indexed user configurations can participate. The selected configuration is loaded as-is.

### Scramble

Snapshots the active vehicle, scans its current `partsTree`, chooses only candidates BeamNG reports as compatible, and applies one batched mutation per pass. A reload can expose new child slots; those paths are handled in later bounded passes. Tuning and paint run only after the final part tree is available.

### Full Random

Runs Random Config, waits for the replacement vehicle, then runs Scramble. Progress is reported for indexing, selection, loading, scanning, mutation, tuning, paint, and validation.

### Chaos

`0` is conservative but not a strict no-op; `100` allows the widest mutation coverage, up to five slot passes, stronger tuning extremes, and the highest optional-empty probability. The default is `75`.

### Safety checkboxes

- **Allow Missing Parts:** permits an empty choice only for optional, non-core slots. Missing doors, panels, wheels, exhausts, or powertrain pieces are possible when metadata allows it.
- **Keep Vehicle Drivable:** protects core/required slots and uses slot descriptions/types to avoid removing clearly critical propulsion, energy, transmission, driveline, steering, suspension, hub, wheel, and tire concepts. Third-party metadata can be incomplete, so drivability cannot be guaranteed.

## Mod-content compatibility

The randomizer does not maintain a hard-coded vehicle, part, wheel, or accessory list. It uses BeamNG's mounted content registry and each loaded vehicle's compatible slot candidates.

- Config packs inside normal mod ZIPs remain discoverable through the VFS registry; manual extraction is not required.
- A mod configuration attached to an official vehicle remains eligible under **Mods only**.
- Mod wheels and accessories can be selected when the active slot tree reports them as compatible.
- Automation vehicles, trailers, and props are excluded by default and can be enabled independently.
- Source ownership that cannot be determined safely is classified as `unknown`, not guessed.

See [Compatibility](docs/COMPATIBILITY.md) for the current matrix.

## Installation

### GitHub Release

No public GitHub Release is published for this alpha yet. When a validated release is available, download `soturine_chaos_randomizer_<version>.zip` from the repository's [Releases page](https://github.com/Soturine/beamng-soturine-chaos-randomizer/releases) and copy it unchanged to the active BeamNG version's `mods` folder.

Do not install GitHub's automatically generated **Source code** archive; it contains a wrapper directory and development files, so it is not a valid BeamNG mod package.

### Manual packaged installation

1. Build the distribution ZIP as described in [Package build](#package-build), or download a validated CI artifact.
2. Locate the active user folder in **Launcher → Manage User Folder → Open in Explorer**.
3. Copy `soturine_chaos_randomizer_0.1.0-alpha.1.zip` into `<active user folder>/mods/`.
4. Keep the ZIP packed and enable it in Mod Manager.
5. Enter Freeroam, open UI Apps editing, and add **Soturine's Chaos Randomizer**.

The ZIP must contain `lua/`, `ui/`, and `settings/` at its root. It must not contain an enclosing `soturine_chaos_randomizer/` folder.

### Unpacked development installation

Create this directory under the active versioned user folder:

```text
mods/unpacked/soturine_chaos_randomizer/
```

Copy or link the repository's `lua/`, `ui/`, and `settings/` directories into it. After edits, reload the UI or restart BeamNG as appropriate. Do not develop inside the game installation directory.

## Usage

1. Enter a player vehicle in Freeroam.
2. Add the app through **Esc → UI Apps → Edit Apps**.
3. Set Chaos and the two visible safety options.
4. Choose **Random Config**, **Scramble**, or **Full Random**.
5. Wait for the progress indicator to finish before changing vehicles or maps.
6. Expand **Advanced** for filters, fairness, a manual seed, Undo, reindexing, and diagnostics.

A manual vehicle or map change cancels an active operation. Repeated button presses are ignored while the busy lock is held.

## Advanced settings

- **Content:** Everything, Official only, or Mods only.
- **Fairness:** equal chance per eligible vehicle, or equal chance per eligible configuration.
- **Content types:** optionally include Automation vehicles, trailers, and props.
- **Manual seed:** any non-empty text is normalized into the displayed `XXXX-XXXX` seed. Leave empty for fresh session entropy.
- **Undo:** restores the most recent complete pre-operation vehicle snapshot.
- **Reindex Content:** rebuilds the mounted vehicle/configuration index and clears the session blacklist.
- **Diagnostic logging:** enables structured mutation summaries in the BeamNG log under `SoturineChaosRandomizer`.

Settings are validated, migrated by schema version, and stored in the BeamNG user settings VFS.

## Seed reproducibility

The displayed seed can be copied from the app. Reusing it reproduces choices only when all relevant inputs are unchanged: game version, installed/enabled content, content metadata, settings, selected starting vehicle for Scramble, and registry ordering after normalization. Physics outcomes and behavior from third-party scripts are outside the PRNG contract.

The randomizer never calls or reseeds Lua's global `math.random`.

## Known limitations

- Interactive in-game testing on BeamNG 0.38.6 has not yet been completed; only source/API inspection, static checks, BeamNG's Lua 5.1 console, and package validation were available for this build.
- The implementation uses internal 0.38 APIs behind an adapter. A future BeamNG release may require adapter updates.
- Keep Vehicle Drivable depends on current slot metadata and conservative name/type hints; it cannot understand every custom powertrain or unusual third-party convention.
- Correlated tuning groups are not inferred unless explicit, reliable metadata exists. Each numeric variable is currently sampled independently.
- There is no dedicated skin/paint-design selector; a design can only change incidentally when BeamNG exposes it as a normal compatible part slot. Supported paint layers are randomized directly.
- Session history is memory-only and is cleared when the extension/game session ends.
- A configuration is blacklisted for the current session after three observed load failures. Reindexing clears that list.
- There is no automatic stress-loop command, configuration export, tag, GitHub Release, or BeamNG Repository submission in this alpha.

## Compatibility

| Component | Status |
| --- | --- |
| BeamNG.drive 0.38.6 | API source inspected; Lua runtime tests pass; interactive tests pending |
| Older BeamNG versions | Not supported or tested |
| Newer BeamNG versions | Unknown until the adapter is revalidated |
| Official vehicles/configs | Implemented; interactive tests pending |
| Mounted mod vehicles/config packs | Dynamically indexed; interactive tests pending |
| Compatible mod parts/wheels | Dynamically scanned; interactive tests pending |
| Automation, trailers, props | Opt-in filters implemented; interactive tests pending |

## Troubleshooting

Start with [Troubleshooting](docs/TROUBLESHOOTING.md). The most useful first checks are:

- verify the ZIP root layout;
- confirm the mod is enabled and the app appears in UI Apps;
- spawn a player vehicle before pressing an action;
- reindex after enabling/disabling content;
- temporarily use **Everything** and include the relevant content type;
- enable diagnostic logging and inspect `beamng.log` for `SoturineChaosRandomizer`.

## Development setup

Requirements:

- Python 3.10 or newer;
- a Lua 5.1-compatible interpreter, or a local BeamNG console;
- Node.js for JavaScript syntax checks;
- BeamNG.drive 0.38.6 for current adapter inspection and interactive testing.

```powershell
git clone https://github.com/Soturine/beamng-soturine-chaos-randomizer.git
cd beamng-soturine-chaos-randomizer
python -m unittest discover -s tests -v
python tools/package_mod.py
python tools/validate_package.py
```

The tests automatically use `lua5.1`, `lua`, or `luajit` when available. On the documented Windows environment they can use BeamNG's `console.x64.exe`; set `LUA` or `BEAMNG_CONSOLE` to override discovery.

## Tests

The automated suite covers PRNG determinism/ranges/weights, seed normalization, anti-repeat selection, Chaos boundaries, optional-empty behavior, immutable candidates, core-slot filtering, nested-slot discovery, tuning clamping/quantization/distributions, operation tokens/timeouts, circular history, blacklisting, settings migration, source filtering, JavaScript/JSON/static rules, and package paths/reproducibility.

The full executed/pending record and the 35-case interactive matrix are in [Testing](docs/TESTING.md).

## Package build

```powershell
python tools/package_mod.py
python tools/validate_package.py
```

This creates:

```text
dist/soturine_chaos_randomizer_0.1.0-alpha.1.zip
dist/soturine_chaos_randomizer_0.1.0-alpha.1.sha256
```

Archive entries are sorted, timestamps and permissions are normalized, and validation rebuilds the ZIP to verify byte-for-byte reproducibility.

## Contributing

Read [Contributing](CONTRIBUTING.md), [Architecture](docs/ARCHITECTURE.md), and [Research](docs/RESEARCH.md) before changing engine integration. BeamNG API calls must remain in `apiAdapter.lua`, and third-party code/assets must not be copied without a compatible license and fulfilled obligations.

## Project links

- [Roadmap](ROADMAP.md)
- [Changelog](CHANGELOG.md)
- [Testing](docs/TESTING.md)
- [Compatibility](docs/COMPATIBILITY.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [BeamNG Repository submission checklist](docs/BEAMNG_REPOSITORY_SUBMISSION.md)
- [Security policy](SECURITY.md)

## License and credits

Copyright 2026 Soturine.

Licensed under the [Apache License 2.0](LICENSE). The implementation and icon are original project work. Historical mods were studied only for behavior after their licensing status was recorded in [Research](docs/RESEARCH.md); no third-party source or artwork is included.

BeamNG.drive is a trademark of BeamNG GmbH. This community project is not affiliated with, endorsed by, or sponsored by BeamNG GmbH.
