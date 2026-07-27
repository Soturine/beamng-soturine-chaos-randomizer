# Live test report — 0.6.3

Status: **Failed — owner-reproduced live regressions**.

| Field | Value |
| --- | --- |
| Candidate version | `0.6.3` |
| Target commit | Annotated `v0.6.3` target recorded in `release-manifest.json` |
| Validation owner | Repository owner |
| Candidate artifact | `soturine_chaos_randomizer_0.6.3.zip` |
| Last reproduced ZIP bytes | `241492` |
| Last reproduced ZIP SHA-256 | `486a66da60bfac75d08f1a9584568142846074c110996962e99af2e610d4e9c7` |
| BeamNG build | Owner environment; exact build was not captured with the reports |
| Profile/map | Owner environment; exact profile/map was not captured |
| Vehicles/mods | Multiple Random Car, Full Random, and Scramble targets; exact list was not captured |

| Result | Count |
| --- | ---: |
| Executed | 0 |
| Passed | 0 |
| Failed | 0 |
| Pending | 110 |
| Blocked | 0 |

The formal 110-case matrix above was not executed row by row, so those counts
remain honest and unchanged. Outside that matrix, the owner ran the published
v0.6.3 prerelease and reproduced at least three blocking flow failures. The
exact number of attempts was not captured and is therefore not invented here.
These observations make v0.6.3 a failed live candidate even though they cannot
be converted into exact matrix totals after the fact.

Observed failures:

- Random Car and Full Random could remain at 22% in
  `tracking_target_identity`.
- Scramble could remain at 57% in `waiting_parts_reload`.
- Pausing and unpausing could release the wait, showing an invalid lifecycle
  dependency even though timeout accounting itself used a real clock.
- Failure recovery could restore stock, the previous vehicle, or discard the
  newly randomized result instead of preserving a stable partial result.
- Uncertain combustion-fuel discovery/read-back could escalate to rollback.
- Missing optional, mod-defined, or not-yet-ready parts could be classified too
  aggressively as critical/required and escalate to rollback.
- A large Settings window height could remain sticky after returning to the
  smaller Chaos tab.
- The compact fox mark was rejected by the owner as visually unsuitable.
- The README did not provide enough evergreen installation, usage,
  troubleshooting, compatibility, and validation guidance.

The detailed evidence and remediation contract are recorded in
[KNOWN_LIVE_FAILURES.md](KNOWN_LIVE_FAILURES.md). Automated and mocked results
do not overwrite live evidence. The strict live-validated gate correctly
remains closed for v0.6.3.
