# v0.7.0 performance report

Automated status: **P1 regression contracts Passed**. Live comparison status:
**Blocked by module graph failure**.

Automation preserves and tests bounded profiler buffers, p50/p95/p99,
frame-budget behavior, low-GC iteration, reusable buffers, dimension/registry
caches, incremental indexing, dirty UI diffs, aggregate diagnostics, adaptive
polling, AI confirmation, deterministic Race 1/4/8/12 vectors, store domain
isolation, and 100 lifecycle/layout cycles.

No live FPS, 1% low, frame-time, UI-latency, CEF-memory, Garage-500, Race-12, or
v0.6.9 comparison measurement was collected. The synthetic Lua benchmark is a
regression instrument and is not live frame-rate evidence.

Live BeamNG 0.39 validation: Failed before mount; performance cases blocked
