# Requirements matrix — v0.6.9

| P1 requirement | Implementation | Automated evidence | Live evidence |
|---|---|---|---|
| Bounded profiler and p50/p95/p99 | `performanceMetrics.lua` | Lua profiler overflow/reset/capability tests | L01–L64 Pending |
| Configurable frame budgets | `frameBudget.lua`, settings schema 8 | below/above/rate-limit/continuation tests | L01–L64 Pending |
| Low-GC iteration and buffers | `vehicleIterator.lua`, `vehicleBufferPool.lua` | iterator/fallback/reuse/alias/stale tests | L01–L60 Pending |
| OOBB XYZ and dimension cache | `dimensionCache.lua`, spawn adapter | XYZ/fallback/cache/generation/invalidation tests | L17–L24 Pending |
| Registry cache | `registryCache.lua`, API adapter | hit/fingerprint/corrupt/partial/privacy/size tests | L45–L52, L61–L64 Pending |
| Incremental atomic index | `incrementalIndexer.lua`, `contentIndex.lua` | chunk/cancel/restart/progress/no-partial tests | L45–L52 Pending |
| UI dirty diff | `uiPublisher.lua`, Angular recursive merge | full/partial/debounce/suppress/request/accounting tests | L01–L44 Pending |
| Aggregated diagnostics | `diagnostics.lua` | dedup/count/rate/critical/compact/export tests | L01–L64 Pending |
| Adaptive polling | `adaptivePolling.lua` | fast/backoff/change/terminal/stale/wake tests | L05–L60 Pending |
| AI confirmation | `aiModeConfirmation.lua`, `aiAdapter.lua` | confirm/unavailable/mismatch/timeout/destroyed/stale tests | L25–L32 Pending |
| Race scale 1/4/8/12 | Race/Spawn/AI integration | scale, unique seed and repeat-equivalence tests | L17–L32 Pending |
| Determinism | generator 6 unchanged | six fixed vectors plus legacy/DNA/Race regressions | L05–L20 Pending |
| Functional preservation | existing Chaos/Garage/Race/DNA modules | full v0.6.8 regression suite | L01–L64 Pending |
| Packaging and publication | deterministic package/release tools | ZIP/checksum/manifest/reproducibility/gate tests | exact-ZIP install Pending |

The Lua runner records 75 new v0.6.9 requirement mappings without representing
those mappings as 75 additional test executions.

