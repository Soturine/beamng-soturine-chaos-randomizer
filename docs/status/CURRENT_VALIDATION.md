# Current validation

Current published release: **0.7.8 experimental prerelease**, targeting BeamNG
0.39.4. Its deterministic ZIP/checksum/manifest and independent
post-publication download verification passed for package commit
`7316cc78e8d6831e03d073ae21adbb4140cc58a6`.

Automated validation passed for the release-candidate freeze and covers the bounded placement solver, formation/payload
normalization, content-driven child sizing, responsive status, ledger-derived
coverage projection, ownership regressions and deterministic packaging. It is
not a live BeamNG result.

Owner live status for v0.7.8: **Failed cases recorded** - 5 executed / 0 passed /
5 failed / 2 pending / 0 blocked on BeamNG 0.39.4.0.20972 with Direct3D 11.
See the [A-G live plan](../testing/v0.7.8/LIVE_TEST_PLAN.md) and
[live results](../testing/v0.7.8/LIVE_RESULTS.md). The observations prove
specific v0.7.8 defects; they do not validate a later correction.

The prior [v0.7.7 live results](../testing/v0.7.7/LIVE_RESULTS.md) preserve the
earlier dead-space/overflow, Formation `.filter`, `position_blocked` and
`lineup_staging_unsafe` failures. v0.7.8 improved those areas, but its owner
run found new end-to-end Race protocol, cleanup, formation, Preview, AI,
Balanced and narrow-layout failures.

Publication evidence is recorded in the
[post-release verification](../testing/v0.7.8/POST_RELEASE_VERIFICATION.md).

Headless visual screenshot tests: not implemented.
