# Current compatibility matrix

Published candidate: **0.7.1 Experimental prerelease**. Primary target:
BeamNG.drive `0.39`; owner environment: `0.39.2.1`. Minimum declared version:
`0.39`. v0.7.0 failed before mount. v0.7.1 mounted but failed Runtime styling,
usability, latency, Full Random, Race ownership/cleanup, and stability.

| Surface | Automated/source evidence | Live status |
|---|---|---|
| Runtime version | central metadata and four-way/unknown classifier | Pending |
| Registry readiness | five states, persistent fingerprinted cache, incremental atomic rebuild | Pending |
| Official 0.39 subgroup configs | registry keys/path/basename/display separated | Pending |
| User/config packs | exact case path plus normalized comparison and traversal rejection | Pending |
| Full vehicle mods / ID churn | transactional world snapshots and stable readback | Pending |
| Safe spawn pressure | confirmed low-memory denial; no invented no-space claim | Pending |
| Instability/removal | generation/ID correlation and one recovery path | Pending |
| Safety/reset changes | ternary validation, fuel/N2O/electric/fluids fixtures | Pending |
| Translation changes | labels excluded from technical IDs/seeds/DNA/Race | Pending |
| AI | explicit `driveInLane`, adaptive polls, optional mode readback confirmation | Pending |
| HUD runtime | module graph and live mount passed; Runtime styling/usability failed | Failed |
| Persistence | settings schema 9, UI-preference migration, DNA/lineup preservation | Pending |
| Performance | bounded profiler/budgets, low-GC buffers, UI diffs, aggregated diagnostics | Pending |
| Conflicting mods | warning-only structured evidence; nothing auto-disabled | Pending |
| Package install | deterministic ZIP/checksum/manifest from central metadata | Pending exact-ZIP install |

See the [v0.7.1 live report](../testing/v0.7.1/LIVE_TEST_REPORT.md), the
[v0.7.0 failure](../testing/v0.7.0/LIVE_TEST_REPORT.md), and the
[v0.6.9 visual/gameplay report](../testing/v0.6.9/LIVE_TEST_REPORT.md).
