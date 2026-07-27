# Current validation

Current source: **0.6.4 Experimental prerelease candidate** on
`fix/v0.6.4-live-lifecycle`, based exactly on published v0.6.3 commit
`ef0cf1a258a234a4ef8f8808e59ae983a0c162a6`.

Automated lifecycle, adapter, recovery, fuel/parts policy, dynamic convergence,
UI math/assets, architecture, security, package, workflow, and release-gate
coverage passes locally. Exact categories and distinct counts are in the
[automated report](../testing/v0.6.4/AUTOMATED_TEST_REPORT.md).

Live BeamNG status: **Pending owner validation — not executed**. The required
report is 0 executed / 0 Passed / 0 Failed / 110 Pending / 0 Blocked. The
installed build/source `0.38.6.0.19963` was inspected, but no interactive world,
UI, vehicle, physics, performance, or representative-mod run occurred in this
workspace.

The published v0.6.3 live candidate is historically Failed from owner-
reproduced 22%/57% stalls, pause-toggle dependence, wrong fallback, fuel/parts
uncertainty, sticky height, rejected fox, and insufficient README. v0.6.4 has
automated regressions for each but is not labeled fixed in gameplay until the
owner executes the exact downloaded prerelease asset.
