# Soturine's Chaos Randomizer

Soturine's Chaos Randomizer is an experimental BeamNG.drive UI app that builds
unexpected vehicles from the content already mounted in your game. It can load
a random vehicle/configuration, scramble the active vehicle's parts, tuning and
paint, or run the complete pipeline as one bounded transaction. It also
includes Vehicle DNA, a local Garage, and Race/Placement/AI workflows.

Current release: **0.6.9**, published as an experimental prerelease for
additional live validation. Automated validation is recorded separately; live
BeamNG validation is **Pending owner validation** (0 executed / 0 passed / 0
failed / 64 pending / 0 blocked).
That wording matters: mocked pipelines and source inspection are not gameplay,
physics, rendering, performance, or mod-compatibility proof.

## Requirements

- BeamNG.drive 0.38.6 or newer. The primary compatibility target is `0.39`;
  source/API inspection is complete, while exact live owner validation remains
  Pending.
- The normal BeamNG UI Apps system and vehicle manager APIs.
- At least one eligible vehicle/configuration for Random Car or Full Random.
- An active player vehicle for Scramble.

Third-party vehicle, configuration, part, wheel, Automation, trailer, and prop
content is best effort. The randomizer discovers current registry, JBeam,
slot-tree, tuning, and energy-storage metadata dynamically; it ships no vehicle
or part catalog.

## Install or update

1. Download `soturine_chaos_randomizer_0.6.9.zip` from the official
   [GitHub Release v0.6.9](https://github.com/Soturine/beamng-soturine-chaos-randomizer/releases/tag/v0.6.9).
   Do not use GitHub's automatic source archive.
2. Copy the ZIP, without extracting it, into your BeamNG user folder's
   `mods` directory.
3. Remove or disable older Chaos Randomizer ZIPs so only one version is active.
4. Start BeamNG, enable the mod, open UI Apps, and add
   **Soturine's Chaos Randomizer**.
5. Confirm `0.6.9` appears in the orange header.

The release page attaches the versioned ZIP, `.zip.sha256`, and `.manifest.json`.
Verify both integrity files before owner testing; the manifest binds the ZIP
size, member count, SHA-256, commit, branch, tag, compatibility declaration,
automated results, and Pending live status.

A valid ZIP has `lua/`, `ui/`, `settings/`, `LICENSE`, `NOTICE`, and `VERSION`
at its root. If the app does not appear, clear BeamNG's UI cache, reload the UI,
and inspect `beamng.log` for `SoturineChaosRandomizer`.

## The three Chaos actions

### Random Car

Chooses one eligible model and configuration, loads it, proves the current
player target through coherent read-back, applies the combustion-fuel guard,
performs final safety/DNA capture, and stops. The internal action name remains
`randomConfig` for compatibility. It does not scramble parts, tuning, or paint.

### Scramble

Keeps the active model/base configuration and dynamically scans its complete
current slot tree. It mutates eligible parts in bounded parent-first passes,
rescans descendants exposed by a reload, then discovers tuning to a fixed point
and randomizes supported paint fields. Scramble requires an active vehicle.

### Full Random

Runs Random Car followed by the complete Scramble stages inside one operation,
seed, lifecycle context, history transaction, and terminal result. Success is
not reported after spawn: parts, tuning, paint, fuel, safety, and final read-
back must reach their honest terminal classifications.

## Chaos slider

Chaos ranges from 0 to 100. It affects selection probability, empty optional
slots when Allow Missing is enabled, tuning spread, paint changes, and coverage
intensity. Zero is conservative; 100 requests maximum eligible coverage, not a
promise that every vehicle exposes alternatives. The orange fill represents
the exact value and remains correct at 0, 1, 99, and 100, including keyboard
input.

## UI tabs and sizing

- **Chaos** contains the three actions, slider, status, warnings, progress,
  Cancel, seed copy, and operation details.
- **Garage** stores, searches, compares, restores, mutates, imports, and exports
  Vehicle DNA.
- **Race** creates sequential competitors, places managed vehicles, and starts
  bounded supported AI modes.
- **Settings** contains filters, safety, seeds, locks, history, capability
  notes, and diagnostics.

Expanded and compact sizes are cached separately for Chaos, Garage, Race, and
Settings. Switching tabs restores that tab's size immediately. Compact mode
keeps the active tab and shows only relevant controls: Chaos actions, selected
Garage DNA, Race generation/AI state, or the Settings summary. Details height
is tab-scoped; closing Details restores the exact base size without cumulative
growth.

## Settings that change results

- **Content**: Everything, Official only, or Mods only. Unknown ownership is
  never guessed into a narrower filter.
- **Fairness**: weight selection per vehicle or per configuration.
- **Automation / Trailers / Props**: explicit opt-ins.
- **Protect critical parts**: preserves topology-proven functional evidence;
  it is not a drivability guarantee.
- **Allow missing parts**: permits empty optional slots. It never permits a
  documented core slot or proven functional infrastructure to disappear.
- **Keep partial result**: retains stable results with ordinary incomplete
  coverage. Non-critical metadata/read-back uncertainty is preserved with a
  warning even when this is off; uncertainty alone must not restore stock.
- **Extreme tuning**: selects a wider range while remaining within finite
  discovered metadata.
- **Diagnostic logging**: records bounded lifecycle evidence useful for issue
  reports. It does not log Vehicle DNA payloads or unbounded per-frame data.
- **Performance profiling**: opt-in bounded timing for documented runtime
  stages with count, total/mean, p50/p95/p99, minimum, maximum, and last sample.
  Profiling is off by default to minimize overhead; synthetic results are not
  live FPS claims.

## Seeds and reproducibility

Random mode creates new entropy for every click. Fixed mode normalizes the
manual seed and repeats generator-6 decisions when the same content, metadata,
settings, and operation are present. Results can still differ after a BeamNG or
mod update, removed content, different ordering/evidence, clamps, or a safety
correction. Vehicle DNA Replay Generation freezes the saved base; Pure Seed
Replay intentionally performs selection again.

Current Vehicle DNA remains schema 1 with generator 6 and `SCR6-...` seeds.
Generator-4/5 records remain restorable and are never reinterpreted as
generator 6.

## Locks

Vehicle, configuration, category, slot/current part, individual tuning, and
paint locks are supported. Locks are session-only by default. Enable Remember
locks to persist them. Model-bound locks that cannot resolve on a different
vehicle remain visible as unresolved; they do not silently substitute content.
Restore Snapshot ignores current creative locks, while Replay Generation asks
whether saved/original or current locks control deviations.

## Garage and Vehicle DNA

A successful or honest partial operation may expose a pending Vehicle DNA
capture. Saving is explicit. Garage entries support names, favorites, pins,
ratings, tags, notes, collections, pagination, thumbnails, field-by-field
Compare, lineage, Exact/Compatible restore, replay, mutations, JSON, and
validated `.vdna.zip` transfer.

Vehicle DNA stores normalized identifiers and state, not mod assets. Exact
restore fails closed on divergence. Compatible restore previews every omission,
remap, and clamp and requires explicit partial authorization. Imports are
bounded data-only operations; archive traversal, duplicate entries, symlinks,
compression ambiguity, invalid CRC/SHA, malformed PNG, future schema, cycles,
non-finite values, and excessive depth/size are rejected.

## Race, Placement, and AI

Race creates competitors sequentially with independent selection, mutation,
placement, and retry seeds, operation contexts, and physical targets. **Player
participates** treats the count as total vehicles (one player plus AI
opponents); **Spectator / camera only** creates exactly the requested number of
AI competitors and needs no player vehicle. Generate Cars is the only action
that creates a Race lineup.

Placement calculates and validates the whole preview before confirmation. It
supports left/right, split, single-file ahead/behind, staggered/side-by-side
grid, circular, and automatic-best-fit formations. Automatic spacing uses
available vehicle dimensions and safety margin; unknown/narrow width falls
back visibly to a longitudinal line. Confirmation repositions retained managed
IDs and does not duplicate them. The complete preset-aware Race policy remains
editable and survives close/reopen, tab/compact changes, and lineup
export/import.
Destination and Route require a reachable NavGraph; Chase/Follow require a real
distinct target. Unsupported Scripted playback remains disabled with a reason.

## Lifecycle, pause, and recovery

Chaos, Race, and Garage own independent generations and ownership contexts.
Callbacks nominate candidates; they never prove completion. Each callback is
bound to domain, operation, generation, slot, and logical target. A delayed or
cross-domain callback is ignored; an owned unaccepted object from it is reaped,
while external and accepted vehicles are preserved. Each wait keeps a
logical target, bounded concrete candidates, generation tokens, readiness,
configuration/parts/tuning evidence, and a wall-clock deadline. The current
player configuration and ID-specific manager bundle are observed independently,
so a fresh applied state can win over a stale cache. A concrete ID is rebound
only after coherent player/model/phase evidence.

Housekeeping runs from the game-engine `onUpdate` hook and is independent of
simulation time. Pausing/unpausing is not a workaround and the mod never changes
pause state. Cancel and diagnostics must remain available while paused.

Terminal outcomes distinguish success, partial success, cancellation, failure
with the current result preserved, and failure with explicit rollback. Recovery
invalidates old plans/timers/callbacks before using its bounded ladder. Unknown
fuel metadata, optional missing parts, or a temporarily unreadable final tree
does not by itself justify restoring stock or the previous vehicle.

## Fuel, engine fluids, and missing-parts policy

Only `combustion_fuel` receives the 10% minimum guard. Electric energy,
nitrous, air pressure, hydraulic storage, unknown storage, and normal tuning are
separate classifications. Multiple fuel tanks are correlated independently.
When a finite capacity, variable, and current value prove a tank below 10%, the
guard corrects and reads it back. Ambiguous correlation or unavailable read-
back produces a visible non-destructive warning; it is never labeled verified.

BeamNG's documented `coreSlot` is structural/fatal when empty. Optional absence
is allowed state, including an intentional Allow Missing choice. A third-party
`required` hint that is not a documented core slot is incomplete mod metadata,
so it becomes an uncertain warning rather than invented proof. Proven loss of a
baseline functional role can still be fatal when critical protection is on.

Combustion oil is separate from fuel. The implementation blocks exposed oil/coolant
volume tuning from reaching zero and uses a generation-bound vehicle-VM probe
to read combustion engine thermal `oilMass`, safe-minimum metadata, coolant,
disabled state and oil-critical damage. Two stable samples are required.
Unavailable evidence produces `UNKNOWN_OR_PENDING` without an oil-safety
claim; only proven zero/below-safe/disabled state is `INVALID_CONFIRMED`.
Evidence-backed safe/not-applicable state is `VALID`. EVs, trailers, props and
explicit shells do not receive a combustion-oil requirement.

## Diagnostics and troubleshooting

Open operation details before cancelling and record phase, operation/phase/
target generations, candidate IDs, evidence source, readiness, tree status,
pending work, clocks, and the displayed seed. **Copy diagnostics** produces a
bounded report with personal paths redacted.

For a stuck or failed case:

1. Do not toggle pause to unblock it; leave the state intact long enough to
   capture diagnostics.
2. Record the exact ZIP SHA-256, BeamNG full build, vehicle/config/mod versions,
   map, settings, seed, and whether the candidate was already visible/applied.
3. Check `beamng.log` for the tagged lifecycle transitions and read errors.
4. Reproduce once with a clean profile or smallest mod set.
5. Use Reindex after content changes. Use Retry quarantined only after the game
   has settled.

Detailed symptom guidance is in [Troubleshooting](docs/TROUBLESHOOTING.md).
Security-sensitive reports should follow [SECURITY.md](SECURITY.md).

## Compatibility and limitations

The app depends on internal BeamNG Lua/UI surfaces and therefore needs review
after game updates. Compatibility is evidence-based, not a promise for every
mod. Malformed or incomplete content may be skipped, partial, uncertain,
unsupported, or rejected safely. Protect Critical Parts cannot simulate
drivability; Vehicle DNA fingerprints detect changes but are not cryptographic
mod hashes; session Undo is not durable across restart; live rendering,
physics, performance, controller, DPI, clean-profile, and representative-mod
results remain Pending until the owner executes the exact release plan.

See [Compatibility](docs/COMPATIBILITY.md) and the
[current matrix](docs/status/CURRENT_COMPATIBILITY_MATRIX.md).

## Validation evidence

- [BeamNG 0.39 compatibility dossier](docs/BEAMNG_0.39_COMPATIBILITY.md)
- [v0.6.8 evidence index](docs/testing/v0.6.8/README.md)
- [automated report](docs/testing/v0.6.8/AUTOMATED_TEST_REPORT.md)
- [60-case live plan](docs/testing/v0.6.8/LIVE_TEST_PLAN.md)
- [live report](docs/testing/v0.6.8/LIVE_TEST_REPORT.md)
- [requirements matrix](docs/testing/v0.6.8/REQUIREMENTS_MATRIX.md)

Automated tests include real production Lua executed by BeamNG's console, a
mocked BeamNG adapter pipeline, property/state-machine cases, JavaScript sizing
math, static/architecture/security contracts, JSON/YAML parsing, deterministic
packaging, checksum, manifest, and release gates. They never update live rows.

## Clean uninstall

1. Remove/disable the versioned mod ZIP.
2. Remove the UI app from the active layout if BeamNG keeps its placement.
3. Optionally back up, then remove
   `/settings/soturineChaosRandomizer/` to delete settings, Garage, thumbnails,
   inbox/export files, and the last-known-good library.

Vehicle changes already applied to the current session are BeamNG state; load a
normal saved/default configuration if you want to replace them before exit.

## Development

Use Python 3, Node, and either Lua 5.1/LuaJIT or the installed BeamNG console.

```text
python -m pytest -q
node tests/js/ui_math.test.js
node --check ui/modules/apps/soturineChaosRandomizer/app.js
python tools/package_mod.py
python tools/validate_package.py
python tools/validate_release_gate.py --channel prerelease
```

Do not edit generated ZIP/checksum/manifest bytes manually. Keep BeamNG API
access in the adapter boundary, preserve unrelated work, add a regression for
every lifecycle fix, and separate automated evidence from live evidence. See
[Contributing](CONTRIBUTING.md), [Architecture](docs/ARCHITECTURE.md), and
[Testing](docs/TESTING.md).

## License

Apache-2.0. See [LICENSE](LICENSE) and [NOTICE](NOTICE).
