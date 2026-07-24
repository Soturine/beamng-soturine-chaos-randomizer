# Soturine's Chaos Randomizer 0.6.0

Full Coverage, Tuning Integrity, Chaos Lineup & AI Director.

**Experimental pre-1.0 release.** Mod support is best-effort. Automated/source
evidence does not replace the 60-row live BeamNG plan, which is still entirely
Pending. Publication does not claim real gameplay validation.

## Implemented

- Full Coverage ledgers for slots, public tuning, and supported paint fields,
  including Chaos-100 terminal classification, tree convergence, local
  isolation, scoped quarantine, and honest Partial handling.
- Generic post-parts tuning discovery, change/read-back, bounded rescan,
  variable/category rollback, explicit correlation evidence, dynamic locks,
  and generator-6 Vehicle DNA values.
- Sequential 2–16 competitor Chaos Lineup with episode/competitor/domain
  substreams, variety rules, acceptance policies, incremental checkpoints,
  failure actions, schema-1 data-only import/export, and local compatibility
  recomputation.
- Spawn Director with deterministic formations/custom point, audited headings,
  spatial preview, one concurrent load, stable DNA read-back, managed target
  generations, bounded ID rebind, respawn, removal, and ownership checks.
- Capability-gated AI Director and NavGraph routes for Destination, Route,
  Chase, Follow, and Traffic; camera destination placement; exact/snap;
  stagger; finish/stuck policies; bounded replan; compact recording controls.
- Explicit pause-aware lifecycle phases, operation/phase/target generations,
  transaction roles, recovery-only write guards, dual clocks, progress
  watchdog, actionable Busy UI, and bounded diagnostics.

## Behavior changes

Chaos 100 attempts and classifies every eligible unlocked entry; it does not
promise that every entry changes. Completed means coverage is terminal and
completion read-back/validation passed. Random Car still loads a complete
configuration without Scramble; Scramble includes parts/tuning/paint on the
current model; Full Random includes a new base plus that complete pipeline.

Lineup reuses Full Random. A competitor cannot be Ready while writes, timers,
or callbacks remain pending. Metadata uncertainty and potential non-drivability
require explicit acceptance. Spawn and AI operations act only on verified
managed generations.

## Pause-State Lifecycle Fix

The static evidence identified five interacting failure risks: parts-tree data
participating too early in target stability, lifecycle work starving later
housekeeping, mixed timing semantics, recovery retaining an old mutation
continuation, and readable/base snapshots being confused with completed-good.
Live causality for the originally observed `heritage` case is not yet claimed.

The implementation separates target identity from parts-tree convergence;
derives Busy from an explicit phase machine; separates real monotonic and
simulation progression; binds callbacks, timers, ledgers, and mutation plans to
operation/phase/target generations; invalidates every old plan before
recovery; distinguishes original, candidate-base, current-target,
recovery-target, readable, and completed-good snapshots; and blocks any stale
parts/tuning/paint write with `stale_callback_ignored` or
`recovery_target_received_stale_mutation` diagnostics.

The deterministic A/B harness covers a failed vehicle B, recovery to A, and a
late B callback without allowing B's plan onto A. Cancel, Copy diagnostics,
phase details, simulation-resume messaging, and stalled warnings remain
available while destructive actions are gated. **static fix implemented;
interactive confirmation pending**.

## Coverage results

Automated coverage exercises target/tree separation, Full Coverage ledgers,
tuning integrity, Lineup, Spawn/managed generations, routes/AI, UI source
contracts, stale callbacks, snapshot roles, pause/slow-motion/frame-step
clocks, recovery isolation, package structure, and honest test counting.
The release tree records 44 unique Python methods, 294 unique Lua test
functions/executed cases, 269 requirement mappings, and 3,290 Lua assertions.
These counts are rerun and copied into the manifest built from the tagged tested
commit.

## Backward compatibility

The visible version is exactly 0.6.0. Vehicle DNA schema remains 1 because new
fields remain optional. Generator 6 emits
`SCR6-...`; generator-4 and generator-5 snapshots remain restorable and are
never reinterpreted as generator 6. The internal/public `randomConfig` action
ID remains compatible. Historical tags and releases are untouched.

## Automated tests

The current repository suite passes all 44 unique Python methods, including 11
package methods and 32 static methods plus the Lua wrapper. The wrapper passes
294 unique Lua functions/cases, 269 requirement mappings, and 3,290 assertions.
Mappings and aliases are not new test functions. The same suite passes from the
release tree before tagging.

## Interactive tests

Current 0.6.0 result: **0 Passed / 0 Failed / 60 Pending**. The exact plan is
in `docs/INTERACTIVE_TEST_PLAN_0.6.0.md`. Until it is executed, no gameplay,
mod, NavGraph, multi-vehicle, recording, scaling, or recovery claim is promoted
to Passed.

Real BeamNG gameplay validation remains pending.
The pause-state lifecycle correction is statically implemented and covered by
automated simulations, but interactive confirmation is still pending.

## Release assets

Release asset names are:

- `soturine_chaos_randomizer_0.6.0.zip`
- `soturine_chaos_randomizer_0.6.0.sha256`
- `release-manifest.json`

They are rebuilt reproducibly from the exact tagged commit and validated after
download, with `lua/`, `ui/`, and `settings/` at ZIP root.

## Known limitations

- Real BeamNG world/UI evidence is Pending.
- Generic safety metadata cannot prove drivability.
- Third-party mod scripts can still alter IDs, trees, controllers, and timing;
  the mod responds best-effort and fails closed where evidence is insufficient.
- Recorded/Scripted AI playback is unavailable in the audited build contract.
- A NavGraph path is not the visual GPS line and may not exist for an exact
  world point.
- Sixteen live vehicles are hardware/map/content-dependent best-effort.

## Not performed

No Repository submission, interactive gameplay pass, or gameplay-validation
claim was performed. Historical releases and tags are not modified.
