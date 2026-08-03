# Current validation

Current source: **0.7.1 Experimental prerelease** on `main`.

Automated status: **Passed**. The final hotfix run records 50 Python test
methods, 398 unique Lua cases, 9,217 Lua assertions, 664 Lua requirement
mappings, 779 JavaScript/Vue assertions, compilation of 55 Vue SFC files, and
validation of 193 module references. The source tree and extracted release ZIP
both have zero directory imports, missing modules, case mismatches,
initialization cycles, and named-export errors.

The first v0.7.0 live attempt failed before the HUD mounted:
**1 Executed / 0 Passed / 1 Failed / 0 Pending / 81 Blocked**. Status:
**Failed — Vue module graph could not load**. Observed error:
`404 /ui/modules/apps/soturineChaosRandomizer/stores`.

v0.7.1 live BeamNG status: **Pending owner validation — not executed**.
The initial report is **0 Executed / 0 Passed / 0 Failed / 97 Pending /
0 Blocked**. Automated graph validation does not replace a live Runtime UI
mount in BeamNG 0.39.

See [the v0.7.1 evidence index](../testing/v0.7.1/README.md) and the
[historical v0.7.0 live report](../testing/v0.7.0/LIVE_TEST_REPORT.md).
