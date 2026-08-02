# Architecture

## v0.6.9 P1 performance model

The GE `onUpdate` orchestrator prioritizes active lifecycle work, advances at
most one incremental catalog chunk, distributes Race AI observation, flushes a
debounced progress diff, and performs bounded owned-orphan cleanup. Profiling,
budgets, iteration, buffers, dimension/cache ownership, indexing, UI publishing,
diagnostic aggregation, polling, and AI confirmation are separate modules with
no BeamNG API calls in domain logic.

The last complete content index remains selection authority during rebuild.
Cache restoration and new build completion both cross an atomic ownership
boundary. UI mount/request crosses a full-state boundary; progress crosses a
small owned diff boundary. Persistence and lifecycle snapshots keep defensive
copies, while newly constructed event payloads avoid redundant copying.

## v0.6.8 BeamNG 0.39 compatibility model

`COMPATIBILITY.json` feeds the package manifest and runtime compatibility
classification. Registry discovery moves through `unavailable`, `warming_up`,
`partial`, `ready`, and `failed_confirmed`; retries use monotonic wall time and
never discard the last complete index. Mod activation/deactivation marks the
cache stale and schedules a fresh bounded snapshot.

Technical identity is independent of presentation. Models/configurations keep
registry keys, exact case-preserving physical paths, lowercase comparison paths,
basenames, source kinds, technical IDs, vehicle families, optional display
groups, and data-driven aliases as distinct fields. Seeds, DNA, locks, Race,
and compatibility matching consume technical fields, not translated labels.

Spawn/replacement is a transaction containing requested model/config/placement,
world IDs before/after, returned object/ID evidence, candidates, one accepted
ID, rejected IDs, typed outcome, and ownership-scoped cleanup. A candidate is
not accepted until stable readback. Only IDs proven created by the transaction
can be reaped.

Settings and lineup writes share backup → candidate write → deep readback →
verified rollback. Vehicle DNA retains its equivalent existing contract. A
structured migration report records preserved/migrated/failed stores without
interpreting a temporary read failure as an empty library.

## v0.6.4 lifecycle evidence model

The operation owns a logical target (model/config intent) independently from
concrete BeamNG object IDs. Replacement returns, spawn/switch/destroy callbacks,
and player polling nominate bounded candidates. `apiAdapter.getVerificationState`
collects player/object identity plus independent player-part-manager and manager-
by-ID configuration views. `vehicleTargetTracker` selects one matching view and
uses that same view for phase-specific identity, parts, and tuning proof.

No callback is completion authority. Once coherent read-back stabilizes,
`runtime/operationContext` atomically promotes the concrete target for guarded
writes. Operation, phase, target, and recovery generations reject stale work.
Reload may retain or recreate the ID without changing logical ownership.

Backend housekeeping is driven by GE `onUpdate` with real monotonic time.
Simulation time and pause state are diagnostics/phase requirements only; UI
render events never drive Lua progress.

Safety results distinguish confirmed fatal evidence from uncertainty. Fuel and
parts warning paths can finish as partial success while preserving the current
target. Generic rollback remains for confirmed write/ownership/core/Exact-DNA
failures, and always invalidates the old plan first.

Soturine's Chaos Randomizer is a BeamNG GE Lua extension with an AngularJS/CEF UI App. `main.lua` composes the subsystems, owns public hooks and routes operations; deterministic domain logic remains in modules that run in the Lua 5.1 test harness.

Current persistent contracts are settings schema 8, Vehicle DNA schema 1,
generator 6, and the historical Race/Lineup schema 1.

## Runtime flow

```text
UI App -> fixed bridge allowlist -> main routing
                                  |
                                  +-> operation state/context
                                  +-> content and mutation pipelines
                                  +-> adapters -> BeamNG internal APIs
                                  +-> verified readback -> result/DNA/UI state
```

The UI sends a complete validated settings snapshot with an action. Gameplay decisions live in Lua. The extension publishes bounded summaries; full Vehicle DNA, thumbnail bytes, and arbitrary local paths do not travel in periodic UI state.

## Logical and concrete targets

An operation owns a logical target containing model/configuration intent and operation/target generations. Concrete IDs observed from replacement returns, `onVehicleSpawned`, `onVehicleSwitched`, or player polling are only candidates.

`runtime/operationContext.lua` promotes a concrete candidate only when it belongs to the current wait and generations, is current player 0, has coherent stable reads, matches model/configuration intent, was observed after the wait began, and has not been destroyed. Reloads release concrete ownership while retaining the logical target. A validated rebind atomically updates operation state, wait state, tracker state, and diagnostics.

Timeout handling performs one final coherent player read without a fixed ID. Correct model/configuration, parts, and applicable tuning can therefore be accepted before recovery. Recovery invalidates old plans and uses bounded state fingerprints; repeated snapshots terminate instead of restarting the pipeline.

## State and timing

- `operationState.lua` owns phases, Busy derivation, generations, deadlines, terminal states, and stale continuation checks.
- `runtime/operationContext.lua` owns logical/concrete targets, candidates, rebinds, ownership release, and checkpoints.
- `timeSource.lua` separates monotonic real time, simulation time, raw time, frame count, pause, and slow-motion evidence.
- Deadlines, watchdog, cancel, cleanup, retry scheduling, and director housekeeping use monotonic real time.
- A terminal phase cannot transition back to a Busy phase. A new operation must start a new generation.

## Dynamic Chaos pipelines

`contentIndex.lua` builds the mounted model/configuration index. `slotScanner.lua`, `treeConvergence.lua`, `mutationEngine.lua`, and `slotCoverageLedger.lua` scan the real part tree, apply parent-first batches, reload, rescan, and stop at a fixed point or an explicit protection limit.

`tuningPipeline.lua` normalizes finite public variables, respects locks and explicit correlation metadata, randomizes previously unprocessed eligible variables, reads back, and rescans through multiple discovery waves. `tuningCoverageLedger.lua` tracks metadata revisions, disappearance, selection, write, clamp, rejection, and rollback. The retired duplicate `tuningRandomizer.lua` is not packaged.

`paintCoverageLedger.lua` and the other ledgers share only target-binding behavior through `coverageContext.lua`; their domain classifications remain independent.

`energyStorageGuard.lua` combines storage type, loaded storage metadata, variable metadata, and configuration correlations. It enforces a read-back-confirmed 10% floor for fuel storage only, after tuning/paint and before validation/DNA capture.

## Boundaries

| Module | Boundary |
| --- | --- |
| `apiAdapter.lua` | registry, current player, exact-ID data, replacement, parts, tuning, paint, settings, storage, files, log, and UI events |
| `spawnApiAdapter.lua` | placement transforms, raycast, spawn, preview, and managed object access |
| `aiAdapter.lua` | Vehicle Lua AI commands and NavGraph access |
| `destinationMarker.lua` | in-world destination drawing through the placement adapter |
| `compatibility.lua` / `registryReadiness.lua` | version and content-registry state machines |
| `pathIdentity.lua` | exact physical versus normalized comparison identity |
| `spawnOutcome.lua` | observable spawn/replacement evidence and cleanup set |
| `transactionalJSON.lua` | backup/readback/rollback persistence protocol |

The packaged HUD remains a legacy Angular directive. BeamNG 0.39's runtime Vue
UI hosts it through the Angular host, so v0.6.9 keeps the established directive
contract. Timers, mutation/resize observers, and remount state are explicitly
bounded. Runtime UI-native Vue migration and internationalization are P2 for
v0.7.0, not part of the v0.6.9 P1 performance release.

`main.lua` declares BeamNG extension dependencies but is not allowed to call unstable BeamNG APIs directly. A static source-contract test enforces the boundary.

## Race compatibility

`raceManager.lua` is the canonical internal Race domain. Persisted keys, storage files, public methods, and third-party imports retain historical `lineup` names. `lineupManager.lua` is a compatibility entrypoint routed through `compat/legacyLineupFacade.lua`; both paths return the same manager contract.

## Packaging and integrity

`crc32.lua` is shared by PNG validation and deterministic Vehicle DNA ZIP packaging. The package builder fixes member order, timestamps, permissions, separators, compression, and text line endings. Release validation checks root layout, version consistency, manifest, SHA-256, reproducibility, historical immutability, and live-test gating.

## Performance and bounds

`performanceMetrics.lua` keeps optional circular windows and lifetime aggregates
for the documented P1 stages. `frameBudget.lua` classifies idle/busy/Race/UI/
index work; an amortized excess warning never becomes a cancellation signal.
`vehicleIterator.lua`, `vehicleBufferPool.lua`, and `dimensionCache.lua` isolate
low-GC enumeration, buffer ownership, OOBB capability detection, and generation-
scoped dimensions. `registryCache.lua` and `incrementalIndexer.lua` retain a
last-valid atomic content index while rebuilding in budgeted chunks.

`uiPublisher.lua` owns dirty flags, full/diff accounting, debounce, hook rate,
and byte rate. `diagnostics.lua` owns bounded fingerprints and aggregates.
`adaptivePolling.lua` and `aiModeConfirmation.lua` own polling cadence and AI
readback terminal states. Normal gameplay does not emit raw timing samples or
per-frame repeated logs. See [Performance](PERFORMANCE.md).

Production modules must be reachable from the BeamNG entrypoint or a documented compatibility entrypoint. `tests/test_architecture.py` fails on unresolved internal requires and orphaned production modules.
# v0.6.7 operation domains

Chaos, Race, and Garage have independent domain generations even though BeamNG
still exposes some player-global APIs. Every mutating operation records domain,
operation ID, generation, action, expected slot/logical target, source,
candidates, accepted/restored/removed IDs, player ID after completion, and one
terminal state. Vehicle ownership distinguishes player source/result, Race
competitor/candidate, orphan, and external objects.

Callback tokens must match domain, operation, generation, slot, and target.
Terminal/superseded operations invalidate callbacks. Cleanup is limited to
managed, created, unaccepted ownership entries; it never sweeps arbitrary world
vehicles. Chaos cannot mutate a retained Race competitor without an explicit
ownership transfer.
