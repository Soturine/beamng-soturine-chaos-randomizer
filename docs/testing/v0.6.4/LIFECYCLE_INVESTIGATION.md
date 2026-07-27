# Lifecycle investigation — 0.6.4

## Observed failure

The owner reproduced v0.6.3 Random Car and Full Random at 22%
`tracking_target_identity`, Scramble at 57% `waiting_parts_reload`, and cases
where pause/unpause released progress. Subsequent recovery could restore stock
or the previous vehicle and lose the new randomized result.

No exact v0.6.3 log or run count was supplied. This investigation therefore
combines that live symptom with production control-flow review, automated state
sequences, official documentation, and the installed BeamNG 0.38.6 source. It
does not pretend to be a replay of the owner's machine.

## Root cause

v0.6.3 had already made wall-clock deadlines pause-independent, but phase
acceptance still depended on one all-or-nothing verification snapshot. The
adapter read only the ID-specific vehicle-manager config. During replace/respawn
the player's part-manager configuration and the manager bundle can become ready
at different moments. A stale/missing manager bundle caused the entire
observation to disappear even when the current player object/model or desired
parts state was already applied.

Every wait deliberately released concrete ownership before read-back. That is
correct for recreated IDs, but it made the single snapshot the only route to a
new binding. Callbacks were nominally hints, yet missing read evidence made
their timing appear authoritative. When the deadline or downstream safety
policy fired, generic failure handling escalated uncertainty into destructive
recovery.

Pause/unpause was an incidental cache/event refresh, not a valid lifecycle
clock. Increasing timeouts, sleeping, forcing pause, retaining the old fixed ID,
or accepting a callback without read-back would only hide the defect.

## Installed BeamNG source evidence

The installed `0.38.6.0.19963` source shows:

- GE `main.lua` calls extension `onUpdate(dtReal, dtSim, dtRaw)` every GFX frame;
  the backend need not wait for UI rendering or simulation time.
- `core/vehicle/manager.lua` stores the vehicle bundle and finishes GE-side
  construction before emitting spawn hooks; player enter/switch and physics
  readiness remain separate evidence.
- `core/vehicle/partmgmt.lua` merges requested parts/tuning into the player
  config and asks the vehicle to respawn. Desired state can therefore appear in
  one view before another bundle or callback settles.
- `getVehicleData(id)` and player part-manager config are separate readable
  surfaces, so they must not veto one another implicitly.

Exact local paths and limitations are in [RESEARCH_NOTES.md](RESEARCH_NOTES.md).

## v0.6.4 model

```text
logical target intent
        |
        v
bounded candidate IDs <--- return/switch/spawn/destroy hints
        |
        v
current player observation
  + object/model evidence
  + player part-manager config candidate
  + ID-specific manager config candidate
        |
        v
phase-specific matching view (identity / parts / tuning)
        |
        v
stable coherent read-back -> atomic concrete rebind -> next phase
```

The adapter returns identity/readiness plus independent configuration
candidates and read errors. The tracker tests every candidate against the
logical configuration and uses the same matched view for parts/tuning evidence;
it never combines identity from one cache with a tree from another. No callback
is required. Returned/callback IDs remain bounded correlations, destroyed and
stale generations are rejected, and player ID is checked around the read.

Identity is a milestone separate from mutable tree convergence. A legitimate
parts reload does not become a new logical vehicle simply because its tree
changes. Concrete binding is recreated only after current player, model,
configuration, coherence, generation, and phase requirements pass.

## Terminal and recovery policy

The operation now records one of: success, partial success, cancellation,
failure with current result preserved, explicit rollback, or failure. Fuel or
parts uncertainty produces warnings/partial success and bypasses generic
rollback. Confirmed write rejection, wrong target, lost core/function evidence,
user-requested post-write cancellation, and exact DNA divergence can still
justify rollback.

Recovery invalidates mutation plans, batches, tuning/paint plans, timers,
trackers, ledgers, and generations before choosing a bounded fingerprinted
step. A readable recovery target is never allowed to resume the failed plan.

## Testable acceptance

- Random Car, Full Random, and Scramble finish while paused and without any
  lifecycle callback when the requested state is coherently readable.
- Fresh player config wins over a stale manager config only when it matches the
  logical/phase expectation.
- Early, late, duplicate, auxiliary, destroyed, and stale callbacks cannot
  force success or cross-target writes.
- An already-applied parts tree converges at 57% without waiting for a callback.
- Cancel, deadline, diagnostics, and Busy cleanup use GE real updates.
- Noncritical uncertainty preserves the stable randomized target.

Automated coverage passes; all corresponding real-game cases remain Pending.
