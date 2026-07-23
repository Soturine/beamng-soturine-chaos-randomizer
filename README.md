# Soturine's Chaos Randomizer

Soturine's Chaos Randomizer is a BeamNG.drive UI App and GE Lua extension for seeded, bounded randomization of complete vehicle configurations, compatible hierarchical parts, tuning values, and paint layers.

Current version: **0.2.0-alpha.1 — Content Hardening**
Inspected target: **BeamNG.drive 0.38.6.0.19963** (Steam build 23007233)

This is a content-hardening alpha artifact, not a gameplay-validated stable release. The implementation and automated fixtures have been validated, but the interactive vehicle/mod matrix remains Pending until it is run in a BeamNG 0.38.6 world and UI session.

## What it does

- **Random Config** chooses an eligible mounted configuration with equal-per-vehicle or equal-per-configuration fairness.
- **Scramble** mutates the current model through BeamNG-reported compatible slots, then independently runs available tuning and paint stages.
- **Full Random** confirms a base configuration before running the Scramble pipeline.
- **Undo** restores one complete pre-write state from bounded session history.
- **Chaos** controls part probability, pass count, missing-part probability, tuning spread, and paint contrast.
- **Manual seed** makes project-owned choices repeatable when the game version, content, settings, starting state, and session blacklist are unchanged.

The randomizer never opens installed mod ZIPs, never forces a part that BeamNG did not report for the exact loaded slot, and never calls or reseeds global `math.random`.

## Content hardening behavior

### Safe hierarchy passes

Slots are sorted by depth, path, and ID. When a parent changes, all of its descendants are recorded as `deferred_due_to_ancestor_change` without consuming descendant RNG. The batch reloads once, the real tree is scanned again, and only candidates from that new tree can be used in the next bounded pass. Sibling changes remain eligible in the same batch.

### Protect Critical Parts

The former **Keep Vehicle Drivable** setting is migrated to the more accurate **Protect Critical Parts** name. It does not promise drivability.

When enabled, it:

- never empties `required` or `coreSlot` slots;
- preserves the current part for recognized energy, propulsion, transmission, driveline, steering, suspension, hub, wheel, and tire concepts;
- restores an explicitly compatible `defaultPart` when a recognized critical slot is already empty;
- blocks a non-empty replacement when metadata cannot prove that it is a safe functional substitute;
- validates detectable required/critical state after a parts reload and rolls back on failure.

Unknown optional slots remain mutable. The broader mechanical validator remains a `0.3.0-alpha` goal.

### Evidence-based source classes

Source precedence is explicit:

1. confirmed user/custom metadata becomes `user`;
2. `modID`/`modId` or the exact registry `Mod` marker becomes `mod`;
3. explicit current official aliases become `official`;
4. every other label remains `unknown`.

`Everything` includes unknown content. `Official only` and `Mods only` exclude it. A mod configuration attached to an official model remains `mod` when its own metadata carries mod identity. Automation, trailer, and prop filtering uses exact current `Type` evidence instead of broad name matching.

### Phase-aware failures and blacklists

Failures retain their phase (`index`, `selection`, `spawn`, `parts`, `tuning`, `paint`, `validation`, `rollback`, `undo`, or `lifecycle`) and operation context. Models, configurations, part candidates, and optional tuning entries have separate session namespaces.

A confirmed base configuration is not penalized for a later parts/tuning/paint failure. Part keys include model, slot path, and candidate. Multi-candidate batch failures are recorded as suspects and do not immediately blacklist every candidate. Reindex and mod activation/deactivation clear all session failure state.

Advanced UI shows compact per-type counts and the latest blocked item; detailed records stay in `beamng.log` under `SoturineChaosRandomizer`.

### Granular capabilities

The adapter reports registry, replace, parts read/write, tuning read/write, paint read/write, settings persistence, UI events, and lifecycle-confirmation capabilities separately. Missing parts write disables Scramble. Missing optional tuning or paint support skips only that stage and exposes a visible warning.

## Installation

1. Build or obtain `soturine_chaos_randomizer_0.2.0-alpha.1.zip`.
2. Copy the ZIP, without extracting it, into the active BeamNG user folder's `mods` directory.
3. Enable it in Mod Manager.
4. Enter Freeroam, open UI Apps, and add **Soturine's Chaos Randomizer**.

The ZIP must expose `lua/`, `ui/`, and `settings/` at its root. GitHub source archives are not installable mod packages.

## Controls

- **Allow Missing Parts:** permits bounded removal only for optional, non-protected slots.
- **Protect Critical Parts:** applies the conservative behavior described above.
- **Content:** Everything, Official only, or Mods only.
- **Fairness:** equal per vehicle or equal per configuration.
- **Automation / Trailers / Props:** opt-in exact-type filters.
- **Diagnostic logging:** enables detailed structured pass/lifecycle records.
- **Reindex Content:** rebuilds mounted registry data and clears all session blacklists.

UI actions send the currently displayed settings and action in one Lua call. A pending debounce cannot make a click use older Chaos, seed, filter, or checkbox values.

## Developer stress diagnostic

The bounded diagnostic is intentionally absent from the normal panel. From the GE Lua console or another developer extension:

```lua
soturineChaosRandomizer.runDeveloperStress({
  iterations = 10,
  mode = "mixed",
  maxDuration = 300,
  operationTimeout = 25,
  stopOnFailure = false,
  seed = "content-hardening"
})
```

Use `cancelDeveloperStress()` to stop it and `getDeveloperStressState()` for a compact summary. Iterations are capped at 50, one operation advances per state-machine/event cycle, normal actions cannot overlap, and map/vehicle/mod-state changes cancel the run. It never saves generated vehicle configurations.

## Build and validation

```powershell
python -m unittest discover -s tests -v
python tools/package_mod.py
python tools/validate_package.py
node --check ui/modules/apps/soturineChaosRandomizer/app.js
```

The package builder fixes entry order, timestamps, permissions, path separators, text line endings, compression settings, and checksum format. Its output includes version, current commit, filename, entry count, byte count, and SHA-256. The matching `.sha256` is generated from the final ZIP in the same directory.

Expected files:

```text
dist/soturine_chaos_randomizer_0.2.0-alpha.1.zip
dist/soturine_chaos_randomizer_0.2.0-alpha.1.sha256
```

`dist/` is ignored by Git.

## Current validation status

- Installed 0.38.6 Lua/API/UI source: inspected.
- Lua behavior suite: runs against the shipped BeamNG Lua 5.1 console.
- Python/static/JS/JSON/package checks: automated.
- Synthetic registry/config-pack/full-mod/part-pack/wheel-pack/user/unknown fixtures: automated.
- Clean-profile ZIP install, UI rendering/resizing, gameplay operations, representative third-party mods, and bounded stress inside a world: **Pending**.

See [Testing](docs/TESTING.md), [Compatibility](docs/COMPATIBILITY.md), and [Troubleshooting](docs/TROUBLESHOOTING.md).

## Known limitations

- No interactive gameplay result or third-party mod compatibility is claimed yet.
- `onVehicleSpawned` is the installed 0.38.6 reload hook for replace, parts, and tuning writes; phase and post-event state verification distinguish them. Paint writes use immediate read-back because `respawn=false` emits no reload hook.
- Tuning metadata exposes display category/subcategory but no proven correlation-group contract. The normalizer supports only an explicit `correlationGroup` plus `shared_normalized_sample`; current installed metadata therefore remains independently sampled.
- Protection is metadata-based and cannot prove generic drivability.
- Undo history is memory-only.
- Paint-design/skin semantics are not specialized beyond ordinary compatible part slots.
- Byte identity is proven for repeated builds in the same validated environment. Cross-platform identity is reported only after the local and final CI ZIP bytes are compared.

## License

Apache License 2.0. See [LICENSE](LICENSE) and [NOTICE](NOTICE). BeamNG.drive is a product of BeamNG GmbH; this project is independent and not endorsed by BeamNG GmbH.
