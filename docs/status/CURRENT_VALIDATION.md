# Current validation

Current published release: **0.7.8 experimental prerelease**, targeting BeamNG
0.39.4. The deterministic ZIP/checksum/manifest identity and publication
verification are recorded with the tagged freeze.

Automated validation passed for the release-candidate freeze and covers the bounded placement solver, formation/payload
normalization, content-driven child sizing, responsive status, ledger-derived
coverage projection, ownership regressions and deterministic packaging. It is
not a live BeamNG result.

Live status: **Pending owner validation** - 0 executed / 0 passed / 0 failed /
7 pending / 0 blocked. See the [A-G live plan](../testing/v0.7.8/LIVE_TEST_PLAN.md)
and [live results](../testing/v0.7.8/LIVE_RESULTS.md).

The prior [v0.7.7 live results](../testing/v0.7.7/LIVE_RESULTS.md) now preserve
the owner-observed dead-space/overflow, Formation `.filter`, `position_blocked`
and `lineup_staging_unsafe` failures that motivated this release. Those
observations do not prove the v0.7.8 corrections live.

Headless visual screenshot tests: not implemented.
