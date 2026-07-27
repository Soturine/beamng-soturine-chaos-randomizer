# Current validation

Current published baseline: 0.6.3 Experimental prerelease. Active remediation:
0.6.4 on `fix/v0.6.4-live-lifecycle`.

Automated lifecycle, adapter, dynamic tuning, energy storage, UI math, package, workflow, source-contract, and architecture tests are implemented. Exact final counts and commands are recorded in [AUTOMATED_TEST_REPORT.md](../testing/v0.6.3/AUTOMATED_TEST_REPORT.md).

Live BeamNG status for v0.6.3: **Failed — owner-reproduced live regressions**. The reproducible candidate is
`soturine_chaos_randomizer_0.6.3.zip`, 241,492 bytes, SHA-256
`486a66da60bfac75d08f1a9584568142846074c110996962e99af2e610d4e9c7`.
The formal live matrix remains 0 executed / 0 Passed / 0 Failed / 110 Pending /
0 Blocked because the owner reports were not recorded row by row. At least
three blocking flow failures were reproduced outside that matrix; the exact
attempt count is unknown and is not invented. See
[KNOWN_LIVE_FAILURES.md](../testing/v0.6.3/KNOWN_LIVE_FAILURES.md).

The v0.6.3 failures include 22% target tracking, 57% parts reload waiting,
pause/unpause dependence, destructive fallback after non-critical uncertainty,
fuel and missing-parts misclassification, sticky tab height, a rejected fox
mark, and insufficient evergreen documentation. v0.6.4 is not considered live
validated until the owner executes its published candidate.
