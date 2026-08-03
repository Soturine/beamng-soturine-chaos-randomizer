# v0.7.0 validation evidence

This directory separates automated source/harness evidence from live BeamNG
execution.

- [Automated report](AUTOMATED_TEST_REPORT.md)
- [Feature parity](FEATURE_PARITY_MATRIX.md)
- [Requirements matrix](REQUIREMENTS_MATRIX.md)
- [Accessibility report](ACCESSIBILITY_REPORT.md)
- [i18n report](I18N_REPORT.md)
- [Performance report](PERFORMANCE_REPORT.md)
- [Live plan](LIVE_TEST_PLAN.md)
- [Live report](LIVE_TEST_REPORT.md)
- [Release checklist](RELEASE_CHECKLIST.md)

Automated validation covers production Lua, protocol/store/bridge logic, Vue
SFC compilation, static component contracts, deterministic packaging, and
regression fixtures. It does not execute the mod in a game world or render CEF
screenshots.

Live BeamNG 0.39 validation: **Failed — Vue module graph could not load**.
Final result: **1 Executed / 0 Passed / 1 Failed / 0 Pending / 81 Blocked**.
