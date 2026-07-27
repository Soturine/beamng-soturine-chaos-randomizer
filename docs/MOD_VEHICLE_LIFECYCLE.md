# Mod Vehicle Lifecycle and Recovery

Version 0.6.2 treats every BeamNG vehicle event as bounded evidence, never as proof that a target is ready. The protocol is best-effort for official and third-party content and does not claim that every mod follows one lifecycle. The 0.38.6 contract was checked against the installed first-party Lua source; the exact findings are in [Research Notes](RESEARCH_NOTES_0.6.2.md).

## Clock and housekeeping contract

`onUpdate(dtReal, dtSim, dtRaw)` samples four independent domains: monotonic wall time, simulation time, raw/real deltas, and frame count. Operation/phase deadlines, callback age, retry cadence, watchdogs, recovery and UI elapsed time use wall time. `dtSim == 0`, slow motion, frame step, or a pause transition does not change an operation, target, phase, or recovery generation.

Every update services, in order, clocks, stale callback/timer cleanup, cancellation, deadline/watchdog, recovery, target tracking, active pipeline, Race/Placement/Drive housekeeping, and UI publication. A phase branch cannot return before Cancel, diagnostics, timeouts, cleanup, recovery, or Busy release are serviced. A phase that genuinely needs Vehicle Lua or physics remains bounded and explains the wait; the extension never toggles pause as a flush mechanism.

## Operation and target ownership

Each click creates a new operation ID/generation, target generation, RNG, entropy input and isolated model/config, parts, tuning, paint, and retry substreams. It clears the previous selection, candidate, mutation/current batch, tuning/paint plans, target tracker, deferred callbacks/timers and temporary quarantine view. Fixed seed, replay, restore and a one-option pool keep their explicit deterministic exceptions.

The operation retains separate roles:

```text
operationOriginalVehicle
operationOriginalSnapshot
selectedCandidate
spawnRequestedTarget
confirmedTarget
currentTarget
lastReadableTarget
lastCompletedGoodSnapshot
recoveryTarget
```

A replacement target is confirmed from the active operation/target generations, returned object and ID, player index 0, expected model, expected configuration and spawn/replace ownership. `apiAdapter.getVerificationState(expectedVehicleId)` reads the expected ID-specific object/configuration and samples the current player ID before and after the bundle; a target change during that read rejects the observation. The adapter never combines one vehicle object with another vehicle's global parts configuration.

Callbacks can nominate candidates but cannot acquire ownership alone. Auxiliary entities, wrong player indexes, old generations, stale timers, changed IDs outside the accepted chain, and mismatched model/configuration are rejected and recorded. After ownership is accepted, every parts/tuning/paint/DNA/thumbnail/completion write and readback rechecks the same operation, phase, target, and recovery generations.

## Identity before tree convergence

Ownership does not wait for the mutable parts tree. Random Car needs final coherent model/configuration readback but does not require a parts scan or execute Scramble. Scramble captures the current confirmed target; Full Random confirms its replacement and only then enters the same complete Scramble pipeline.

Tree convergence has separate identity-stable and tree-stable counters. A reload may legitimately change a tree multiple times; `tree_changed_legitimately` does not clear target ownership. Polling/rescans, no-progress detection, candidate/event histories and deadlines are bounded. Parent-first mutation defers descendants, reloads once per coherent batch, and plans again only from the fresh exact-target tree.

## Target-bound pipelines

The pipeline order is parts → reload/rescan → tuning → reload/readback → paint → bounded readback → final coverage/safety/readback. Pending write/callback/timer ownership is explicit. Completed requires:

- final target ownership;
- terminated parts, tuning, and paint stages;
- final readback for the expected target;
- closed coverage ledgers;
- zero pending writes, callbacks, and timers;
- no active recovery;
- a clean terminal result.

A partial result is classified and follows **Keep Partial Result**. Accepted partial stays Partial; a rejected partial enters an explicit rollback and terminates. Neither path silently starts the same randomization again.

## Snapshot and recovery integrity

Snapshot roles are independent: operation original, candidate base, last readable, last completed good, and explicitly chosen recovery snapshot. A clean spawn, base configuration load, rejected Partial, timeout, or recovery never promotes completed-good. Promotion occurs only after the completion gate above closes.

Recovery first invalidates callbacks/timers, selection and mutation plans, current batch, tuning and paint plans, and coverage ledgers; it increments recovery generation and marks the failed operation generation terminal. Old work cannot resume after the restoration.

The bounded tiers are:

1. continue the current owned target only for a temporary read gap with recent progress;
2. roll back the local candidate/batch/category;
3. abort the current candidate;
4. restore an explicitly selected operation-original or completed-good safe baseline;
5. load a ranked safe official fallback;
6. hard-fail and release Busy.

Every recovery observation records a bounded fingerprint of model, configuration, parts, tuning, paint, snapshot, tier and generations. A repeated candidate chain records `candidate_cycle_detected`; a repeated recovery state sequence records `recovery_loop_detected`. Either ends the automatic cycle. `lastReadableSnapshot` remains diagnostic evidence and cannot be selected implicitly.

## Busy and terminal paths

Busy is derived from an active non-terminal operation. Success, accepted/rejected partial, failure, cancel, timeout, rollback, recovery, map unload, extension unload, and bounded player-vehicle loss all terminate or transition into one bounded terminal handler. The UI retains Cancel safely, Details, Copy diagnostics, and available recovery actions while Busy. It shows action, phase, progress, elapsed time and target, plus the last-progress age when stalled.

Player-vehicle loss outside an expected target-in-transit phase is tolerated for at most two wall-clock seconds before a bounded recovery/terminal decision. Map and extension unload invalidate all work and release Busy without writing to a new target.

## Required diagnostics

Public diagnostics include operation/phase/target/recovery generations; expected/current player and vehicle IDs; candidate chain; model/config/path; wall/simulation/raw/frame clock samples and pause transitions; identity/tree/config fingerprints and stability counts; readback/pending callback/timer/write state; batch/tuning/paint plans; progress timestamp/reason; snapshot source/promotion; recovery tier/attempt/fingerprint; and terminal outcome. Histories are bounded and personal Windows paths are redacted.

The explicit reason-code contract includes:

```text
target_callback_missing
target_id_changed
target_model_mismatch
target_config_mismatch
target_identity_unstable
tree_unavailable
tree_changed_legitimately
parts_reload_pending
tuning_reload_pending
paint_readback_pending
pause_toggle_unblocked_operation
stale_callback_rejected
stale_timer_rejected
recovery_snapshot_old_generation
recovery_loop_detected
candidate_cycle_detected
operation_deadline_exceeded
```

`pause_toggle_unblocked_operation` is a diagnostic regression signal: if a stalled phase advances immediately after pause changes, the run is not acceptable as normal operation.

## Evidence boundary

The coherent-read, ownership/tree split, stale-work guards, deadlines, recovery tiers/cycles and all 95 required v0.6.2 scenarios have automated coverage. No final v0.6.2 ZIP has been run in a live BeamNG world here; all 80 rows in the [interactive plan](INTERACTIVE_TEST_PLAN_0.6.2.md) remain Pending. The eight reproduced v0.6.1 failures remain historical Failed results in the [v0.6.1 report](INTERACTIVE_TEST_REPORT_0.6.1.md).
