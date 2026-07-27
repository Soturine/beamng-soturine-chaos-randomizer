# Mod vehicle lifecycle and recovery

Every BeamNG vehicle event is candidate evidence, never proof that a target is
ready. The protocol is best effort for official and third-party content. The
inspected 0.38.6 contracts and their limitations are recorded in the current
[research notes](testing/v0.6.3/RESEARCH_NOTES.md).

## Clock and housekeeping contract

`onUpdate(dtReal, dtSim, dtRaw)` keeps monotonic wall time, simulation time,
raw/real deltas, and frame count distinct. Deadlines, watchdogs, retry cadence,
cancellation, stale-work cleanup, recovery, and Busy release use wall time.
Pause and frame-step do not create ownership or advance a logical phase, and
the extension never toggles pause as a flush mechanism.

## Logical target and concrete candidates

Each action creates an operation context with operation, phase, target, and
recovery generations. Its logical target records the intended model and
configuration. Returned replacement IDs, spawn/switch callbacks, and player-0
observations are stored only as bounded concrete candidates.

Before confirmation, the adapter discovers through
`getVerificationState(nil)`: it reads player 0's ID, reads ID-specific data,
then confirms player 0 still references that ID. A mixed or temporarily absent
view is unreadable, not a match. A candidate can be promoted only when it
belongs to the current wait/generations, is player 0, is stable and readable,
and matches the expected model/configuration. Promotion atomically updates the
concrete target and wait/tracker/public state while preserving the logical
target.

After confirmation, every parts, tuning, paint, fuel, DNA, and completion read
or write uses the confirmed ID and rechecks its operation/target binding.
Auxiliary entities, wrong models/configurations, destroyed candidates, external
switches, and old-generation callbacks are rejected with diagnostics.

## Reload and convergence

Spawn, parts/tuning reload, rollback, Undo, DNA stages, isolation, and batch
rollback release concrete ownership because BeamNG may recreate the object or
ID. The logical target remains. Discovery repeats through player 0 and accepts
only a validated rebind.

Parts and tuning discovery are bounded by pass/item/write limits, fingerprints,
cycle/no-progress detection, and deadlines. A new tree or variable wave is
processed from fresh coherent state; a structural gap cannot redirect writes
to another vehicle.

## Timeout and recovery

Immediately before rollback, the coordinator performs one final unbound
player-0 read and checks expected identity plus applicable parts/tuning state.
If the intended result has converged, it is accepted instead of restoring the
previous vehicle.

Recovery invalidates outstanding candidates, timers, mutation plans, ledgers,
and stale generations before selecting a bounded rollback/baseline tier. A
signature comprising tier, snapshot identity, logical target, concrete ID, and
phase prevents the same state from cycling without meaningful progress.
Terminal success, partial, cancellation, recovered failure, safe-baseline
failure, or unrecoverable failure always releases Busy; terminal phases cannot
transition back to a nonterminal phase.

## Evidence boundary

Deterministic and property tests cover returned/intermediate/recreated IDs,
early/missing/duplicate/stale callbacks, coherent discovery, validated rebind,
reload ownership reset, pause-independent clocks, final timeout readback,
bounded recovery, cancellation across active phases, and terminal Busy release.
They are not live BeamNG evidence. All 110 current cases remain Pending in the
[live report](testing/v0.6.3/LIVE_TEST_REPORT.md); historical failures remain in
the [0.6.1 report](archive/releases/0.6.1/LIVE_TEST_REPORT.md) and current
regression matrix.
