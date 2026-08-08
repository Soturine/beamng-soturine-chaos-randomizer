# Performance

The performance goal is bounded, observable work. Automated timings are useful
regression signals but are not claims about BeamNG FPS, 1% low, CEF memory, or
driver behavior.

## Permanent architecture

- Registry indexing is incremental, cancellable, and atomically published.
- Heavy runtime work uses one cooperative scheduler with a bounded per-frame
  budget and no synchronous stress loop.
- Adaptive polling backs off and stops at terminal states.
- Full state is used for mount/recovery; normal changes are domain-scoped diffs.
- Stores keep stable keys and avoid cloning unrelated Garage/Race collections.
- Diagnostics, histories, candidates, callbacks, caches, and telemetry have
  explicit caps.
- Layout work is coalesced; teardown returns observers, timers, subscriptions,
  and event handlers to baseline.

## Budgets

Central limits in `runtime/stabilityLimits.lua` define interactive operation,
phase, Race slot, callback, and ownership budgets. Random Car is shortest,
Scramble remains short and spawn-free, Full Random has a larger interactive
budget, and each Race slot is bounded independently. The semantic watchdog
requires meaningful progress and moves stalled work through abort/cleanup to a
terminal state.

Full Random records parts reload, readback, and repair reload counts separately,
plus reload duration, phase duration, and maximum single cooperative step. The
normal target is one mutation reload with at most one repair reload; a hard cap
terminates further churn while preserving the last coherent result.

Mounted UI regression tests require synthetic local tab and button p95 below
50 ms. This threshold protects JavaScript/UI regressions only; it is not a live
game latency statement.

## Metrics

Runtime telemetry includes phase/operation duration, time-to-first-progress,
watchdog age, callback/stale/drop counts, pending writes/timers/callbacks,
candidate/owned/orphan IDs, peak owned temporary count, state full/diff bytes,
component invalidations, and bounded percentile samples. Race reports per-slot
and global progress separately.

## Methodology

Automated gates run pure Lua/fixture invariants, JavaScript services, mounted Vue
cycles, graph/style validation, Python integration checks, and deterministic ZIP
rebuild. Live testing starts from the downloaded release asset and records map,
renderer, hardware, traffic, mod set, FPS/1% low, timings, and diagnostic export.
No live percentile or improvement is published without that evidence.

## Results history

Version-specific automated numbers are recorded in
[`docs/testing/`](testing/) and changelog entries. Live historical outcomes stay
in their original reports. Current in-game performance is **Pending owner
validation**; the v0.7.4 automated report contains only measurements produced by
the release gates.
