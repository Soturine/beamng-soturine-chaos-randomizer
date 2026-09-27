# Current validation

Current release: **0.7.11 experimental prerelease**, targeting BeamNG.drive
0.39.4.x. Automated validation runs through `npm run verify` (static, UI, Lua
and Python contracts, then the deterministic package).

Owner live status for v0.7.11: **Pending owner validation; not executed** -
0 executed / 0 passed / 0 failed / 13 pending / 0 blocked. Use the exact
downloaded release asset and record results in
[v0.7.11 live results](../testing/v0.7.11/LIVE_RESULTS.md).

The v0.7.10 owner session is historical evidence: world Preview geometry was
visible (renderer confirmed), while Preview follow, UI after Preview,
discoverability and the origin label fit failed. See
[v0.7.10 live results](../testing/v0.7.10/LIVE_RESULTS.md) and the
[v0.7.11 root cause report](../testing/v0.7.11/ROOT_CAUSE_REPORT.md).

The v0.7.9 owner session (BeamNG 0.39.4.0.20972, Direct3D 11) is historical
evidence: 5 executed / 0 passed / 2 failed / 10 pending / 3 blocked - Preview
visibility and Position All failed, AI behavior cases were blocked. See
[v0.7.9 live results](../testing/v0.7.9/LIVE_RESULTS.md) and the
[v0.7.10 root cause report](../testing/v0.7.10/ROOT_CAUSE_REPORT.md).

The v0.7.8 owner run remains historical evidence: 5 executed / 0 passed /
5 failed / 2 pending / 0 blocked on BeamNG 0.39.4.0.20972 with Direct3D 11.
Maximum Chaos generation, Move Up/Down, physical Remove and sequential
placement were partially functional, but protocol, cleanup, formation,
Preview, AI, Balanced and narrow-layout acceptance failed. Those outcomes are
preserved in [v0.7.8 live results](../testing/v0.7.8/LIVE_RESULTS.md) and are not
treated as v0.7.9 validation.

The v0.7.9 public assets are independently verified in its
[post-release record](../testing/v0.7.9/POST_RELEASE_VERIFICATION.md). Historical
v0.7.8 publication evidence remains unchanged.

Headless visual screenshot tests: not implemented.
