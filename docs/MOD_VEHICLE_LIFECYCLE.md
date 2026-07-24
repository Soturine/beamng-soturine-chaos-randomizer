# Mod Vehicle Lifecycle and Recovery

Version `0.5.0-alpha.2` treats BeamNG vehicle lifecycle notifications as observations, not as proof that the requested player target is ready. This is a bounded best-effort protocol for official and third-party content; it does not claim that every mod follows one lifecycle.

## Target tracking protocol

Every replacement or reload expectation owns an operation token, phase, start time, expected model/configuration/parts, original player vehicle ID, and a bounded tracker. Evidence can arrive from:

1. the vehicle object/ID returned by the replace API;
2. synchronous or asynchronous spawn/switch callbacks;
3. the current player-0 vehicle poll;
4. model and normalized configuration read-back;
5. requested part read-back for reload phases.

Callbacks add candidates only. They never make an operation succeed by themselves. The tracker rejects stale tokens, wrong models/configurations, non-player auxiliary objects, and candidates beyond its limits. A returned intermediate ID may disappear; a later matching player target can rebind the operation.

The accepted target must remain coherent for at least five update frames and two scans. Polling is interval-limited. Candidate and event histories are capped at 16 and 32 entries, and the normal operation timeout remains authoritative. This permits an internal chain such as `A → B → C` while still cancelling a real unrelated manual player switch.

## Stabilization and part trees

Model/configuration identity may become readable before the complete parts tree. An incomplete or temporarily inconsistent tree is rescanned; one bad scan is not a structural verdict. Two coherent scans that prove the same absence make it persistent.

Part mutation remains parent-first. A changed parent defers new descendants until the real post-reload tree is scanned, so deep trees and newly materialized subslots are explored without inventing candidates. No-progress, repeated-state, depth-derived pass, operation-retry, and wall-clock guards make termination finite.

## Localized batch recovery

Before each parts write, the operation retains the pre-batch snapshot. If the stable post-reload tree loses a required/core path or fails persistent structural validation:

1. restore the pre-batch snapshot;
2. verify the rollback through the same lifecycle tracker;
3. quarantine the failing candidate under model/configuration/slot/candidate scope;
4. plan another compatible candidate from the fresh tree;
5. continue the remaining operation when budgets allow.

Budgets are finite: two retries per slot, eight retries per pass, four localized batch rollbacks, twelve operation retries, and 128 quarantined candidates. A failed localized rollback or exhausted structural recovery enters the ordinary total transaction rollback. Quarantine is session-only and clears on reindex/mod-state reset; it does not rewrite installed content.

## Failed vehicle-load recovery

A failed configuration load can remove the previous target and leave player 0 without a vehicle. Recovery is independent of creative locks and tries, in order:

1. the operation's previous complete snapshot;
2. the session last-known-good model/configuration;
3. an eligible safe official configuration.

The failed configuration is quarantined for the session. Three consecutive load failures open a circuit breaker that temporarily restricts automatic selection to official content. A successful recovery closes the active failure path; a failed recovery still clears the busy flag, operation token, wait/tracker state, pending timers, and transient creative state so the UI remains usable.

Random Car and Full Random may spawn from an empty player state. Scramble cannot infer a model without an active vehicle, so it remains unavailable with an explicit recovery message and a safe-vehicle action.

## Full Random completion contract

Full Random does not finish when a base vehicle merely appears. It must:

1. select and request a model/configuration;
2. bind to the final stable player target;
3. scan and execute the post-spawn Scramble pipeline;
4. apply or explicitly omit tuning and paint with reason codes;
5. perform final configuration, field, and safety read-back.

Terminal codes distinguish `full_random_completed`, `full_random_partial`, and `full_random_no_mutable_content`. A structural failure that cannot be localized rolls the whole operation back.

## Metrics and diagnostics

Public diagnostics expose bounded aggregates rather than unbounded event payloads:

```text
replacementEvents
candidateVehicles
rebindCount
stabilizationFrames
stabilizationScans
stabilizationMs
partBatchRetries
partBatchRollbacks
quarantinedCandidates
fullRandomPostSpawnMs
```

Useful reason codes include stable-target timeout, stale token, unrelated switch, transient/persistent tree state, localized rollback, quarantine, no mutable content, recovery step, circuit breaker, and cleanup. **Copy diagnostics** exports inert JSON/text; it does not execute code or include mod archives.

## Evidence boundary

The protocol was derived from the installed BeamNG.drive `0.38.6.0.19963` source and automated lifecycle fixtures. The alpha.1 maintainer report contains real observations that motivated it. No alpha.2 third-party mod vehicle has yet been interactively validated in game; all alpha.2 interactive cases remain Pending in [the test plan](INTERACTIVE_TEST_PLAN_0.5.0-alpha.2.md).
