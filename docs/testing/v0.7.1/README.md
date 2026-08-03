# v0.7.1 validation evidence

v0.7.1 is a focused hotfix for the native Runtime UI Vue module graph failure
observed in v0.7.0. It does not broaden the feature scope.

- [Automated test report](AUTOMATED_TEST_REPORT.md)
- [Module graph report](MODULE_GRAPH_REPORT.md)
- [Live BeamNG test plan](LIVE_TEST_PLAN.md)
- [Live BeamNG test report](LIVE_TEST_REPORT.md)
- [Requirements matrix](REQUIREMENTS_MATRIX.md)
- [Release checklist](RELEASE_CHECKLIST.md)

Automated source and extracted-ZIP validation: **Passed**.

Live BeamNG 0.39.2.1 validation: **Failed**. Final bounded result:
**9 Executed / 3 Passed / 6 Failed / 0 Pending / 88 Blocked**. The module graph
and mount passed, but Runtime CSS, usability, latency, Full Random, Race, and
stability failed.
