# Soturine's Chaos Randomizer 0.6.1

**Runtime Lifecycle, Race Workflow & Compact UI Hotfix**

Experimental pre-1.0 release. Third-party mod support remains best-effort.

## Fixed

- Pause-dependent Random Car, Scramble and Full Random lifecycle processing in
  deterministic fixtures: target polling and required housekeeping now advance
  independently from simulation pause state.
- Busy deadlocks and missing-callback waits through explicit terminal cleanup,
  safe cancellation and wall-clock deadlines.
- Recovery loops and repeated clean/mutated cycles through recovery-only
  generations, bounded retry, quarantine, and no automatic re-randomization.
- Stale parts, tuning and paint writes after recovery; old plans and target/read
  state are invalidated before recovery work.
- Automatic clicks reusing weak entropy or recent selections; every click gets
  fresh session entropy and completed-result anti-repeat history.
- Race competitors stuck Pending; processing now exposes Selecting, Loading,
  Randomizing and Verifying before a terminal status.
- Non-functional Race presets and the native preset selector; three buttons now
  apply real policies and manual edits mark Custom.
- Persisted legacy locks and implicit saved-seed activation; migration starts
  unlocked, lock persistence is opt-in, and Random every run is the default.
- Hidden active-lock/fixed-seed state through contextual warnings and Unlock All.
- Cluttered Chaos layout, undersized text/actions, ineffective near-duplicate
  compact modes, the Chaos slider endpoint geometry, and unclear Race workflow.

## Changed

- Consolidated Lineup, Spawn and AI under the public **Race** workflow with
  **Cars**, **Placement** and **Drive** steps.
- Reduced top-level navigation to **Chaos**, **Garage**, **Race**, **Settings**.
- Moved seed and locks to Settings; Chaos keeps only direct randomization,
  slider, warnings and operation feedback.
- Garage now groups **Saved**, **Compare**, and **Share**.
- Removed ambiguous C/S header controls and retained only true Collapsed and
  Expanded modes at a 340×320 default and 300×220 minimum.
- Added a lightweight local decorative fox SVG to the header.
- Public terminology uses Race/Race Cars while saved `lineup` schema and
  `.lineup.json` compatibility remain intact.

## Compatibility

- BeamNG target inspected: 0.38.6.0.19963.
- Vehicle DNA schema remains 1.
- Generator remains 6 and new seeds remain `SCR6-...`.
- Existing generator-4/5 snapshots and legacy Lineup data remain readable under
  their recorded semantics; no destructive migration is required.
- External mod Lua errors can break those mods' own vehicles. They are not
  treated as proof against a Randomizer candidate without ownership evidence.

## Automated tests

Local result: **44/44 Python tests passed**, including **304/304 Lua cases** in
the installed BeamNG Lua console. All 76 mandatory v0.6.1 requirement mappings
are registered. These fixture results do not prove live gameplay.

## Interactive status

**0 Passed / 0 Failed / 50 Pending / 0 Blocked.** No v0.6.1 gameplay/UI run was
performed in this delivery environment. The exact cases are in the interactive
plan and report; historical v0.6.0 failures are not promoted or counted as
v0.6.1 results.

## Known limitations

- Mods are best-effort and can expose incomplete/transient metadata.
- External mod Lua errors can break their own vehicles.
- AI depends on NavGraph and build capabilities.
- Metadata does not prove drivability.
- Performance depends on installed mods and vehicle complexity.
