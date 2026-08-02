# Synthetic performance report — v0.6.9

Command: `python tools/benchmark_v069.py`

Environment observed during the recorded run: BeamNG.drive 0.39.2.1 shipped
Lua console, Windows 10, AMD Ryzen 5 7535HS. Timings vary by machine and load.

| Scenario | Iterations | Mean ms | p50 ms | p95 ms | p99 ms | Reuses | Hooks | Diagnostics |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| idle | 2,000 | 0.000221 | 0.000100 | 0.000200 | 0.000400 | 1,999 | 0 | 0 |
| Chaos active | 300 | 0.117330 | 0.076600 | 0.332100 | 0.457000 | 0 | 0 | 0 |
| Race 4 | 300 | 0.008101 | 0.002400 | 0.031600 | 0.092000 | 0 | 0 | 0 |
| Race 8 | 300 | 0.010848 | 0.004300 | 0.045600 | 0.064100 | 0 | 0 | 0 |
| Race 12 | 300 | 0.015403 | 0.008200 | 0.057900 | 0.093100 | 0 | 0 | 0 |
| Garage 100 entries | 300 | 0.261732 | 0.232100 | 0.492300 | 0.646800 | 0 | 0 | 0 |
| Garage 500 entries | 150 | 1.098925 | 0.958300 | 1.676900 | 2.083300 | 0 | 0 | 0 |
| Details closed | 1,000 | 0.000779 | 0.000400 | 0.001800 | 0.003600 | 0 | 1,000 | 200 |
| Details open | 300 | 0.279585 | 0.204500 | 0.673700 | 1.023800 | 0 | 300 | 200 |
| index cache hit | 1,000 | 0.041163 | 0.037800 | 0.057000 | 0.088000 | 0 | 0 | 0 |
| index full rebuild | 20 | 43.050325 | 42.177000 | 53.063600 | 55.084600 | 0 | 0 | 0 |

The full rebuild fixture contains 250 models and 2,500 configurations and is
measured synchronously inside the microbenchmark to expose total algorithm
cost. Production v0.6.9 splits that work across `indexChunkBudgetMs` chunks and
keeps the last complete index authoritative.

This table is synthetic algorithm evidence, not an FPS or live performance
claim. Exact raw output is in `SYNTHETIC_BENCHMARK.json`.

## Deep-copy audit

| Classification | Retained/reduced behavior |
|---|---|
| `required_for_ownership` | Public state, Race/Garage summaries, cache restore output, dimensions, and diagnostics exports remain owned copies. |
| `required_for_persistence` | Settings, lineup, Vehicle DNA, manifest, backup, readback, and rollback candidates remain defensive copies. |
| `required_for_async_boundary` | Lifecycle waits, callbacks, recovery snapshots, spawn transactions, and generation-bound plans remain copied. |
| `replaceable_with_shallow_copy` | Aggregate settings/budget/capability snapshots use bounded shallow copies where children are scalar. |
| `replaceable_with_immutable_reference` | Catalog build jobs read sorted immutable source entries until atomic completion. |
| `unnecessary` | Freshly built full/diff UI payloads no longer receive a second adapter deep copy. |

