# Automated test report — v0.6.9

Status: **Passed on the v0.6.9 prerelease source**.

| Metric | Result |
|---|---:|
| Python test methods | 65 |
| Pytest reported subtests | 1,099 |
| Lua unique executed cases | 394 |
| Lua assertions | 9,136 |
| Lua requirement mappings | 652 |
| JavaScript checks | 49 |
| Node syntax files | 1 |
| Workflow YAML files | 3 |

P1 coverage includes profiler enable/disable/reset/overflow and percentiles;
budget continuation/rate limiting; iterator fallback/determinism; buffer reuse,
aliasing and stale generations; OOBB XYZ/fallback/cache invalidation; registry
fingerprint/checksum/privacy/partial rejection; incremental chunk/cancel/restart/
atomic completion; UI full/diff/debounce/accounting; diagnostic dedup/critical/
export; adaptive polling; AI mode terminal outcomes; Race 1/4/8/12; and six
fixed generator-6 seed vectors.

All v0.6.8 compatibility, Chaos, Garage, Race, Race Policy, Vehicle DNA,
packaging, checksum, manifest, and prerelease-gate regressions remain included.
Live BeamNG owner validation remains Pending (0 executed / 64 pending).
