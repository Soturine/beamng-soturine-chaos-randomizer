# Soturine's Chaos Randomizer

Soturine's Chaos Randomizer is a BeamNG.drive UI App and GE Lua extension for seeded, bounded randomization of complete vehicle configurations, compatible hierarchical parts, tuning values, and paint layers.

Current version: **0.4.0-alpha.1 — Vehicle DNA and Persistence**
Inspected target: **BeamNG.drive 0.38.6.0.19963** (Steam build 23007233)

This is a Vehicle DNA persistence alpha artifact, not a gameplay-validated stable release. Automated and installed-source evidence is complete for the documented contracts; the interactive world/UI and multi-PC matrix remains Pending.

## What it does

| Action | Behavior |
| --- | --- |
| **Random Config** | Replace the current vehicle with one complete eligible installed configuration; stop without scrambling it. |
| **Scramble** | Keep the current model and randomize its BeamNG-reported compatible parts, nested slots, tuning, wheels, tires, and paints. |
| **Full Random** | Replace with a random eligible model/configuration and automatically run the entire bounded scramble and validation pipeline in one click. |

For example, you may start in an Ibishu Covet, press **Full Random** once, and finish controlling an ETK 800-Series 856 ttSport+ base configuration with newly randomized compatible engine, forced-induction, transmission, suspension, wheels, tires, optional body parts, tuning, and paints. The exact categories depend on what the loaded vehicle exposes; no second Scramble click is required.

- **Undo** restores one complete pre-write state from bounded session history.
- **Chaos** controls part probability, pass count, missing-part probability, tuning spread, and paint contrast.
- **Manual seed** makes project-owned choices repeatable when the game version, content, settings, starting state, and session blacklist are unchanged.

The randomizer never opens installed mod ZIPs, never forces a part that BeamNG did not report for the exact loaded slot, and never calls or reseeds global `math.random`.

## Safety and compatibility behavior

### Safe hierarchy passes

Slots are sorted by depth, path, and ID. When a parent changes, all of its descendants are recorded as `deferred_due_to_ancestor_change` without consuming descendant RNG. The batch reloads once, the real tree is scanned again, and only candidates from that new tree can be used in the next bounded pass. Sibling changes remain eligible in the same batch.

### Protect Critical Parts

The former **Keep Vehicle Drivable** setting is migrated to the more accurate **Protect Critical Parts** name. It does not promise drivability.

When enabled, it builds a graph from required/core slot metadata, loaded-part functional sections, hierarchy, powertrain/energy metadata, and exact model type. Dynamic profiles cover standard road, electric, hybrid-like, Automation, trailer, prop, special, and unknown layouts. It:

- never empties `required` or `coreSlot` slots;
- preserves baseline-proven energy, propulsion, power-path, and required functional roles without assuming one engine, fuel tank, gearbox, differential, four wheels, or steering system;
- restores an explicitly compatible `defaultPart` when a recognized critical slot is already empty;
- blocks a non-empty replacement when metadata cannot prove that it is a safe functional substitute;
- treats trailer/prop concepts as not applicable where appropriate;
- reports `safe`, `uncertain`, `unsafe`, or `not_applicable`, and rolls back on unsafe post-reload/final evidence.

Unknown optional slots remain mutable. `uncertain` is honest evidence status, not a drivability claim.

### Evidence-based source classes

Source precedence is explicit:

1. confirmed user/custom metadata becomes `user`;
2. explicit config mod identity or confirmed `core_modmanager.getModFromPath(pcFilename)` ownership becomes `mod`;
3. explicit current official aliases become `official`;
4. every other label remains `unknown`.

`Everything` includes unknown content. `Official only` and `Mods only` exclude it. A mod configuration attached to an official model remains `mod` when its own metadata carries mod identity. Automation, trailer, and prop filtering uses exact current `Type` evidence instead of broad name matching.

### Phase-aware failures and blacklists

Failures retain their phase (`index`, `selection`, `spawn`, `parts`, `tuning`, `paint`, `validation`, `rollback`, `undo`, `lifecycle`, or the matching `dna_*` restore/storage/import/export phase) and operation context. Models, configurations, part candidates, and optional tuning entries have separate session namespaces.

A confirmed base configuration is not penalized for a later parts/tuning/paint failure. Part keys include model, slot path, and candidate. Multi-candidate failures use bounded suspicion scores and batch fingerprints; repeated independent evidence can suppress and eventually isolate a candidate, while a confirmed success reduces suspicion. Reindex and mod activation/deactivation clear all session failure state.

Advanced UI shows compact blacklist/suspect counts and the latest records; detailed records stay in `beamng.log` under `SoturineChaosRandomizer`.

### Correlated writes and tolerant verification

Vehicle replacement waits are bound to the ID extracted from the actual object returned by `core_vehicles.replaceVehicle`; unrelated switches never retarget spawn, rollback, or Undo. Configuration confirmation uses model, normalized filename, registry identity, and a minimal loaded-state signature in that order. Paint read-back compares only requested supported fields with numeric tolerance and uses a short bounded update-driven retry when the game cache is not immediately current; it never waits for a paint spawn event.

### Granular capabilities

The adapter reports registry, replace, parts read/write, tuning read/write, paint read/write, settings read/write, DNA read/write/list/delete/import/file-export/backup, UI events, and lifecycle-confirmation capabilities separately. Missing parts write disables Scramble. Missing optional tuning or paint support skips only that stage and exposes a visible warning. Missing optional DNA file export does not disable Save Vehicle DNA or JSON copy.

## Installation

1. Download the attached `soturine_chaos_randomizer_0.4.0-alpha.1.zip` release asset, or build that filename locally.
2. Copy the ZIP, without extracting it, into the active BeamNG user folder's `mods` directory.
3. Enable it in Mod Manager.
4. Enter Freeroam, open UI Apps, and add **Soturine's Chaos Randomizer**.

The ZIP must expose `lua/`, `ui/`, and `settings/` at its root. GitHub's automatic source archives are not installable mod packages. Verify the attached `.sha256` against the same release ZIP.

## Controls

- **Allow Missing Parts:** permits bounded removal only for optional, non-protected slots.
- **Protect Critical Parts:** applies the conservative behavior described above.
- **Content:** Everything, Official only, or Mods only.
- **Fairness:** equal per vehicle or equal per configuration.
- **Automation / Trailers / Props:** opt-in exact-type filters.
- **Diagnostic logging:** enables detailed structured pass/lifecycle records.
- **Reindex Content:** rebuilds mounted registry data and clears all session blacklists.

UI actions send the currently displayed settings and action in one Lua call. A pending debounce cannot make a click use older Chaos, seed, filter, or checkbox values.

## Vehicle DNA Garage

After Random Config, Scramble, or Full Random completes and a fresh final read-back validates, **Save Vehicle DNA** becomes available. Saving is always explicit; `autoSaveDNA` is fixed off. A Vehicle DNA entry records normalized slot paths and selected parts, tuning metadata/values, supported paint fields, base configuration, environment, generation settings, warnings, dependencies, and fingerprints. It never embeds mod archives, JBeam files, textures, or executable code.

- **Restore Exact** performs a no-write preflight, ignores recent/blacklist/RNG state, uses parent-first fresh-tree reloads, and succeeds only after strict read-back. Missing, ambiguous, changed, or unverified evidence blocks it.
- **Restore Compatible** reports every omission, clamp, and mapping; partial application requires confirmation and never substitutes a random part.
- **Replay Seed** reruns the saved generator operation and settings. It is separate from restore and can differ when the environment or starting state changed.
- **Copy DNA JSON / Import pasted JSON** use schema v1 and bounded JSON-only validation. Imported text is parsed as data before crossing the UI bridge.

New seeds use `SCR4-XXXX-XXXX`; legacy `XXXX-XXXX` seeds remain accepted without changing their generator sequence. Manual-seed selection ignores the hidden recent list. See [Vehicle DNA](docs/VEHICLE_DNA.md) and [Schema](docs/VEHICLE_DNA_SCHEMA.md).

## Developer stress diagnostic

The bounded diagnostic is intentionally absent from the normal panel. From the GE Lua console or another developer extension:

```lua
soturineChaosRandomizer.runDeveloperStress({
  iterations = 10,
  mode = "mixed",
  maxDuration = 300,
  operationTimeout = 25,
  stopOnFailure = false,
  seed = "safety-compatibility"
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

Expected release files:

```text
dist/soturine_chaos_randomizer_0.4.0-alpha.1.zip
dist/soturine_chaos_randomizer_0.4.0-alpha.1.sha256
dist/release-manifest.json
```

`dist/` is ignored by Git.

## Current validation status

- Installed 0.38.6 Lua/API/UI source: inspected.
- Lua behavior and mocked main-pipeline suite: runs against the shipped BeamNG Lua 5.1 console.
- Python/static/JS/JSON/package checks: automated.
- Synthetic registry/config-pack/full-mod/part-pack/wheel-pack/user/unknown fixtures: automated.
- Clean-profile ZIP install, UI rendering/resizing, gameplay operations, representative third-party mods, and bounded stress inside a world: **Pending**.
- Vehicle DNA exact/compatible restore, corruption recovery, restart persistence, and multi-PC import inside the game: **Pending**.

See [Testing](docs/TESTING.md), [Compatibility](docs/COMPATIBILITY.md), [Compatibility Matrix](docs/COMPATIBILITY_MATRIX.md), [Safety Model](docs/SAFETY_MODEL.md), [Performance](docs/PERFORMANCE.md), and [Troubleshooting](docs/TROUBLESHOOTING.md).

## Known limitations

- No interactive gameplay result or third-party mod compatibility is claimed yet.
- `onVehicleSpawned` is the installed 0.38.6 reload hook for replace, parts, and tuning writes; phase and post-event state verification distinguish them. Paint writes use immediate or bounded deferred read-back because `respawn=false` emits no reload hook.
- Tuning metadata exposes display category/subcategory but no proven correlation-group contract. The normalizer supports only an explicit `correlationGroup` plus `shared_normalized_sample`; current installed metadata therefore remains independently sampled.
- Safety is metadata-based and cannot prove generic drivability; unknown/special layouts can remain `uncertain` without being destructively rejected.
- Undo history is memory-only.
- Vehicle DNA uses one bounded JSON library (100 entries, 128 KiB per entry, 1 MiB total) plus a last-known-good copy. The installed helper uses temp-write/rename, but the project does not claim transactional filesystem atomicity.
- Exact preflight is `unverified` when the target model is not currently loaded and its slot tree cannot be inspected without mutation; Exact restore is blocked in that state.
- Fingerprints are deterministic change detectors, not cryptographic signatures or proof that two mod installations contain identical bytes.
- Paint-design/skin semantics are not specialized beyond ordinary compatible part slots.
- Repeated local build identity is tested. Cross-platform identity is reported only after comparing the final CI artifact for this exact commit.

## License

Apache License 2.0. See [LICENSE](LICENSE) and [NOTICE](NOTICE). BeamNG.drive is a product of BeamNG GmbH; this project is independent and not endorsed by BeamNG GmbH.
