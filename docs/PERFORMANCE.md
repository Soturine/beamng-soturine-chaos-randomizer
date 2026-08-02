# Performance, profiling, and efficiency

## v0.7.0 preservation

The Vue migration preserves the v0.6.9 P1 backend metrics, budgets, caches,
incremental work, diagnostic aggregation, adaptive polling, and dirty-diff
publisher. Initial mount/recovery receives full state; ordinary progress uses a
small `core` diff. Domain stores prevent a progress update from replacing the
Garage or Race collections, and closed Details panels do not create additional
backend subscriptions.

Automated tests cover diff ordering/gap recovery, store isolation, stable list
keys, 100 layout/lifecycle cycles, Garage pagination contracts, and Race
1/4/8/12 deterministic vectors. These checks do not measure FPS, 1% low, CEF
memory, or live UI latency. The exact v0.6.9-to-v0.7.0 comparison remains in the
v0.7.0 live plan.

Live BeamNG 0.39 validation: Pending owner validation

v0.6.9 implemented the P1 performance layer without changing generator version
6 or the Chaos/Garage/Race feature contracts.
The goal is bounded work and observable evidence, not an unverified FPS claim.

## Runtime profiler

Profiling is off by default (`performanceProfiling=false`). When enabled, each
metric retains at most 256 recent samples in a circular buffer while lifetime
aggregates remain constant-size. UI snapshots contain aggregates only, never
raw samples:

```text
count totalMs minMs maxMs meanMs p50Ms p95Ms p99Ms lastMs
```

The required metrics are:

```text
onUpdate                 targetTracking          spawnDirector
aiDirector               fluidGuard              paintConfirmation
treeRescan               raceGeneration          registryIndexing
uiPublish                diagnosticsSerialization vehicleEnumeration
vehicleDimensionRead     configVerification      ownershipCleanup
orphanReaper             garageLoad              dnaCompatibility
```

Legacy aggregate names remain readable for existing diagnostics consumers.
`timeprobe`, `gcprobe`, and `luaProfiler` are capability-detected and reported;
none is a runtime dependency. The profiler API supports enable/disable, reset,
snapshot, and export. Disabling it rejects samples before touching a metric
buffer.

## Frame budgets

Settings schema 8 introduced five configurable budgets; schema 9 preserves
them unchanged while adding UI preferences:

| Budget | Default | Purpose |
|---|---:|---|
| `idleBudgetMs` | 0.50 ms | Minimal housekeeping while idle |
| `busyBudgetMs` | 2.50 ms | Critical lifecycle work during a Chaos operation |
| `raceBudgetMs` | 3.50 ms | Distributed Race/AI maintenance |
| `uiPublishBudgetMs` | 1.50 ms | State construction, serialization, and hook dispatch |
| `indexChunkBudgetMs` | 2.00 ms | One incremental catalog chunk |

An excess records the stage, elapsed time, budget, and repetition count. The
warning is rate-limited per stage. Budget evidence never aborts an operation,
extends a timeout, or introduces an artificial delay.

## Allocation and enumeration strategy

- `vehiclesIterator()` and `activeVehiclesIterator()` are preferred when
  present; `getAllVehicles()` is the compatibility fallback.
- IDs are sorted only where deterministic order is required. Invalid,
  destroyed, negative, duplicate, and non-integral IDs are ignored.
- Named reusable buffers have one borrower and a generation token. Release
  clears every key, stale generations fail closed, and external callers receive
  an owned copy rather than the mutable buffer.
- OOBB rear/front/center XYZ and `getPointXYZ` capabilities are detected. Half
  extents provide orientation-stable width/height; rear-to-front XYZ supplies
  length. World-box extents are the bounded fallback.
- Dimension cache keys combine vehicle ID and target generation. Destroy,
  replacement, config change, generation change, and invalid reads prevent an
  ID-recycled vehicle from receiving stale dimensions.

Deep copies remain at ownership, persistence, async callback, and public-state
boundaries. Freshly owned event/diff payloads no longer receive a redundant
adapter copy. Lifecycle snapshots, rollback material, Vehicle DNA, Race/Garage
records, and persistence candidates intentionally retain defensive copies.

## Catalog cache and incremental index

The persistent catalog envelope is versioned and fingerprinted by BeamNG
version, mod version, registry shape, active mods, content-alias version, and
settings schema. A CRC-32 checksum, complete-snapshot marker, 4 MiB limit, and
absolute personal-path rejection are validated before restoration. Persistence
uses the existing transactional JSON write/readback boundary.

Extension load follows:

```text
extension loaded -> cache check -> cache ready OR indexing
                 -> budgeted chunks -> atomic complete index
```

Only one indexer can be active. It is cancellable and restartable; manual
Reindex and mod changes invalidate cache/generation. A partial build never
replaces the last valid index and is never used for selection. Diagnostics and
public performance state expose hit/miss reason, generation, chunks, items,
progress, and total time.

## UI and diagnostics

The initial mount and explicit request publish full state. Progress publishes a
small diff (`SoturineChaosRandomizerStateDiff`) with debounce/batching; the
Vue state protocol routes it to the matching store. Dirty flags cover operation,
progress, Race, Garage, settings, diagnostics, compatibility, and performance.
Counters expose hooks/s, bytes/s, full/partial counts, and suppressed publishes.

Closed Details receives compact diagnostic aggregates rather than full history.
Diagnostics use a bounded fingerprint index with first/last time, repetitions,
severity, deduplication, and per-record rate limiting. A full sanitized export
is still available on explicit Copy diagnostics. Lower-severity churn cannot
evict a buffer containing only critical errors.

## Polling, AI, Race, and cleanup

Adaptive polling starts fast while state changes, backs off to a configured
ceiling while stable, wakes on relevant events, rejects stale generations, and
stops completely at terminal state. Managed Race AI is processed in distributed
batches while due confirmations remain prioritized.

When `getAIMode` or an equivalent readable state exists, an AI command reaches
Running only after expected mode readback. Destination/Route normalize to the
Traffic runtime mode. Mismatch, timeout, destruction, and stale responses are
bounded terminal outcomes. Builds without readback keep the v0.6.8 fallback and
record `mode_confirmation_unavailable`.

The orphan reaper consumes only managed ownership IDs from a queue, under item
and time budgets. It never sweeps or deletes arbitrary external world vehicles.

## Collection and export

Enable profiling in Settings, reproduce the operation, open Details, and use
Copy diagnostics for the complete sanitized aggregate. Record the exact game
build, map, active mods, vehicle count, settings, seed, catalog fingerprint,
generator version, and whether Details was open. Reset metrics before comparing
two controlled runs.

## Synthetic benchmark

Run:

```powershell
python tools/benchmark_v069.py
```

The BeamNG-shipped Lua console executes 11 production-module microbenchmarks:
idle, Chaos active, Race 4/8/12, Garage 100/500, Details closed/open, registry
cache hit, and full index rebuild. Each row reports iterations, total/mean,
p50/p95/p99, buffer reuses, UI hooks, and diagnostic count. The committed result
is in `docs/testing/v0.6.9/SYNTHETIC_BENCHMARK.json`.

These timings are synthetic metadata/algorithm measurements on one machine.
They are not FPS, 1% low, physics, rendering, RAM/VRAM, or real gameplay proof.
They are diagnostic and intentionally not a brittle CI timing gate.

## Live validation boundary

Live BeamNG 0.39 validation is **Pending owner validation**. The 64-row owner
matrix measures FPS average, 1% low, frame time, `onUpdate` p50/p95/p99, GC,
RAM, VRAM, hooks/s, diagnostics/s, vehicle/managed/orphan counts for 1/4/8/12
vehicles. No real-world performance improvement is claimed before those rows
are executed with the downloaded release artifact.
