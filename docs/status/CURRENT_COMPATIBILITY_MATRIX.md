# Current compatibility matrix

Candidate: 0.6.4. Inspected BeamNG target: `0.38.6.0.19963`.

| Surface | Automated/source evidence | Live status |
| --- | --- | --- |
| Official vehicles/configurations | dynamic registry + callback-free pipelines pass | Pending |
| User configs/config packs | normalized path/scoped identity fixtures pass | Pending |
| Full vehicle mods / ID churn | returned/recreated/destroyed/stale candidates pass | Pending |
| Part/wheel packs | dynamic candidates/provenance/optional policy pass | Pending |
| Automation/trailers/props | opt-in type and honest safety degradation pass | Pending |
| Deep/dynamic trees | bounded rescans/new/disappearing descendants pass | Pending |
| Dynamic/mod tuning | fixed point/revision/cycle/clamp/malformed metadata pass | Pending |
| Fuel/hybrid/multiple tanks | combustion-only correlation and warning policy pass | Pending |
| Incomplete mod metadata | non-standard required/unknown evidence is nonfatal uncertain | Pending |
| Race/Placement/AI | manager/ownership/route/command fixtures pass | Pending |
| UI tabs/resize/DPI/input | JS policy/static assets pass; CEF behavior unexecuted | Pending |
| Package install | deterministic package/checksum/manifest gates required | Pending exact-ZIP install |

`Pending` is neither failure nor success. Record content/build/artifact details
in the [v0.6.4 live report](../testing/v0.6.4/LIVE_TEST_REPORT.md).
