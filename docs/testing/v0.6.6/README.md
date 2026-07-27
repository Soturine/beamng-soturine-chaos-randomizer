# v0.6.6 live-fix candidate

This workspace is the Stage A evidence and validation area for
`0.6.6-live-fix-candidate`.

The candidate is being implemented directly on `main` and will be pushed only
after all automated gates pass. It must not be
tagged or published as `v0.6.6` until the repository owner executes and
approves the live matrix.

Current evidence state:

- automated validation: pending final verification;
- owner live validation of this candidate: not started;
- release authorization: not granted;
- public tag/release: forbidden during Stage A.

The environment-cleanup observations and remaining reproduced failures are
recorded in [OWNER_EVIDENCE.md](OWNER_EVIDENCE.md). Root-cause conclusions,
candidate identity, automated results, and the executable live matrix are kept
in separate files so automated evidence cannot be confused with gameplay
evidence.

Candidate evidence:

- [root-cause analysis](ROOT_CAUSE_ANALYSIS.md)
- [safety precedence](SAFETY_PRECEDENCE.md)
- [automated test report](AUTOMATED_TEST_REPORT.md)
- [live test plan](LIVE_TEST_PLAN.md)
- [live test report](LIVE_TEST_REPORT.md)
- [owner checklist](OWNER_TEST_CHECKLIST.md)
