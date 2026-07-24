# Soturine's Chaos Randomizer

Soturine's Chaos Randomizer is a BeamNG.drive UI App and GE Lua extension for seeded, bounded randomization of complete vehicle configurations, compatible hierarchical parts, tuning values, and paint layers.

Current version: **0.5.0-alpha.2 — Mod Vehicle Lifecycle, Creative Integrity & Compact UI Hotfix**
Inspected target: **BeamNG.drive 0.38.6.0.19963** (Steam build 23007233)

This is an alpha artifact, not a gameplay-validated beta or stable release. Automated and installed-source evidence is complete for the documented contracts. Maintainer observations from alpha.1 informed this hotfix, but the alpha.2 interactive world/UI and multi-PC matrix remains Pending.

## What it does

| Action | Behavior |
| --- | --- |
| **Random Car** | Replace the current vehicle with one complete eligible installed configuration; stop without scrambling it. The persisted/internal operation remains `randomConfig`. |
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

### Stabilized lifecycle and tolerant verification

Replacement/reload callbacks are candidate evidence, not immediate success. A bounded tracker combines the returned ID, callbacks, the current player vehicle, model/configuration read-back, and part read-back; it accepts the final target only after five stable frames and two coherent scans. Legitimate `A → B → C` mod lifecycles, auxiliary vehicles, trailers, destroyed intermediates, and reload-time ID changes can rebind without being mistaken for a manual switch. A truly unrelated player switch still cancels safely.

Transient part-tree gaps are rescanned. A persistent structural failure rolls back only the failing batch, quarantines the model/configuration/slot/candidate combination, and tries a bounded alternative. Failed configuration loads recover through the previous snapshot, last-known-good vehicle, then a safe official fallback; cleanup always releases busy/token/timer state. Random Car and Full Random can start with no active vehicle, while Scramble explains that it needs an active target.

### Granular capabilities

The adapter reports registry, replace, parts read/write, tuning read/write, paint read/write, settings read/write, DNA read/write/list/delete/import/file-export/backup, UI events, and lifecycle-confirmation capabilities separately. Missing parts write disables Scramble. Missing optional tuning or paint support skips only that stage and exposes a visible warning. Missing optional DNA file export does not disable Save Vehicle DNA or JSON copy.

## Installation

1. Download the attached `soturine_chaos_randomizer_0.5.0-alpha.2.zip` release asset, or build that filename locally.
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

After Random Car, Scramble, or Full Random completes and a fresh final read-back validates, **Save Vehicle DNA** becomes available. Saving is always explicit; `autoSaveDNA` is fixed off. A Vehicle DNA entry records normalized slot paths and selected parts, tuning metadata/values, supported paint fields, base configuration, environment, generation settings, warnings, dependencies, and fingerprints. It never embeds mod archives, JBeam files, textures, or executable code.

- **Restore Exact** performs a read-only registry preflight, loads the saved model/configuration when target inspection is required, then applies parent-first fresh-tree passes and succeeds only after strict read-back. Any target mismatch or divergence rolls back.
- **Restore Compatible** reports every omission, clamp, and mapping; partial application requires confirmation and never substitutes a random part.
- **Replay Generation** freezes the saved base model/configuration and replays only the recorded parts/tuning/paint generation stages. **Pure Seed Replay** is a separate advanced action that may reselect the base and differ when content or algorithms changed.
- **Copy DNA JSON / Import pasted JSON** use schema v1 and bounded JSON-only validation. Imported text is parsed as data before crossing the UI bridge.

New seeds use generator 5 and `SCR5-XXXX-XXXX`. `SCR4-...` and legacy seed text remain parseable as their recorded version and are never silently reinterpreted as generator 5. Schema v1 snapshots from generator 4 remain restorable; generation replay requires a supported matching generator. Manual-seed selection ignores the hidden recent list. See [Vehicle DNA](docs/VEHICLE_DNA.md) and [Schema](docs/VEHICLE_DNA_SCHEMA.md).

## Creative Vehicle DNA in 0.5

- Persisted locks cover vehicle, configuration, evidence-based category, hierarchical slot, current part, tuning, and paint. Restore Snapshot ignores locks; Replay Generation explicitly chooses saved or current locks; Reroll Unlocked and Mutate use current locks.
- **Reroll Unlocked** and **Small**, **Medium**, and **Wild** first restore and verify the saved parent's real `final` state, then create a new pending child without editing the parent. Model-bound locks keep their bound model/configuration; unlocked Wild prefers another eligible model when available.
- Garage adds pins, 0-5 rating, tags, notes, collections, search, filters, sort, grid/list, lineage, storage meter, and paginated lazy details. Compare uses normalized fields rather than fingerprints alone.
- Exact gallery capture compares model, configuration, slots, tuning, and paints before and after capture. A deliberate non-exact override is labeled in metadata. PNGs receive bounded signature, chunk ordering/length, CRC, IHDR/IDAT/IEND, trailing-payload, and chunk-count validation.
- `.vdna.json` and `.vdna.zip` transfer inert metadata only, plus an optional image explicitly captured by this mod. ZIP import is fixed-inbox, bounded, allowlisted, checksummed, schema-validated, previewed, and confirmed before a unique local ID is created.

See [Locks](docs/LOCKS.md), [Mutations](docs/MUTATIONS.md), [Gallery](docs/GALLERY.md), [Sharing](docs/SHARING.md), [UI Design](docs/UI_DESIGN.md), and [Replay Semantics](docs/REPLAY_SEMANTICS.md).

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
dist/soturine_chaos_randomizer_0.5.0-alpha.2.zip
dist/soturine_chaos_randomizer_0.5.0-alpha.2.sha256
dist/release-manifest.json
```

`dist/` is ignored by Git.

## Current validation status

- Installed 0.38.6 Lua/API/UI source: inspected.
- Lua behavior and mocked main-pipeline suite: runs against the shipped BeamNG Lua 5.1 console.
- Python/static/JS/JSON/package checks: automated.
- Synthetic registry/config-pack/full-mod/part-pack/wheel-pack/user/unknown fixtures: automated.
- Clean-profile ZIP install, UI rendering/resizing, gameplay operations, representative third-party mods, and bounded stress inside a world: **Pending**.
- Vehicle DNA exact/compatible restore, creative locks/mutations, managed capture, corruption recovery, restart persistence, and cross-PC package import inside the game: **Pending**.

See [Testing](docs/TESTING.md), [Compatibility](docs/COMPATIBILITY.md), [Compatibility Matrix](docs/COMPATIBILITY_MATRIX.md), [Safety Model](docs/SAFETY_MODEL.md), [Performance](docs/PERFORMANCE.md), and [Troubleshooting](docs/TROUBLESHOOTING.md).

## Known limitations

- No alpha.2 interactive gameplay result or universal third-party mod compatibility is claimed. Alpha.1 maintainer observations are historical evidence, not alpha.2 passes.
- `onVehicleSpawned` is the installed 0.38.6 reload hook for replace, parts, and tuning writes; phase and post-event state verification distinguish them. Paint writes use immediate or bounded deferred read-back because `respawn=false` emits no reload hook.
- Tuning metadata exposes display category/subcategory but no proven correlation-group contract. The normalizer supports only an explicit `correlationGroup` plus `shared_normalized_sample`; current installed metadata therefore remains independently sampled.
- Safety is metadata-based and cannot prove generic drivability; unknown/special layouts can remain `uncertain` without being destructively rejected.
- Undo history is memory-only.
- Vehicle DNA uses one bounded JSON library (100 entries, 128 KiB per entry, 1 MiB total) plus a last-known-good copy. The installed helper uses temp-write/rename, but the project does not claim transactional filesystem atomicity.
- The optional share ZIP supports this project's deterministic stored-entry format only; it intentionally rejects compressed or feature-rich general-purpose ZIP variants.
- Thumbnail capture is source-inspected and capability-gated but remains interactively unverified. Package images are included only when explicitly captured and revalidated; mod thumbnails are never discovered or copied.
- A cross-model preflight may report `target_inspection_required`. Restore then loads the saved base inside the same history transaction, reruns target-specific preflight, and rolls back unless Exact is proven or the user explicitly authorized a reported Compatible partial result.
- Fingerprints are deterministic change detectors, not cryptographic signatures or proof that two mod installations contain identical bytes.
- Paint-design/skin semantics are not specialized beyond ordinary compatible part slots.
- Repeated local build identity is tested. Cross-platform identity is reported only after comparing the final CI artifact for this exact commit.
- BeamNG's Mod Manager owns the outer ZIP listing description. This project can reliably control its UI App name/icon/description, but no installed public metadata contract was found for overriding every Mod Manager field; no speculative `mod_info` file is shipped.

## License

Apache License 2.0. See [LICENSE](LICENSE) and [NOTICE](NOTICE). BeamNG.drive is a product of BeamNG GmbH; this project is independent and not endorsed by BeamNG GmbH.
