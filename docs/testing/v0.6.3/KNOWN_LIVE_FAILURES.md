# Known live failures — 0.6.3

This document preserves the repository owner's observations from the exact
published v0.6.3 prerelease. They are qualitative live evidence: no attempt is
made to fabricate missing timestamps, vehicle names, logs, screenshots, or an
exact run count.

| Area | Owner-observed result | v0.6.4 acceptance requirement |
| --- | --- | --- |
| Random Car | Stalled at 22% in `tracking_target_identity` | Complete without callback dependence and without pause/unpause |
| Full Random | Stalled at 22% in `tracking_target_identity` | Rebind the current player target from coherent read-back and continue all stages |
| Scramble | Stalled at 57% in `waiting_parts_reload` | Accept an already-applied tree and converge without requiring a reload callback |
| Pause lifecycle | Pause/unpause could release the wait | Housekeeping, observation, cancellation, and deadlines must progress from GE `onUpdate`, independent of simulation time |
| Recovery | Could restore stock/previous state or lose the new randomization | Preserve a readable, stable current/partial result when the uncertainty is non-critical |
| Fuel safety | Uncertain discovery/read-back could cause rollback | Correct confirmed sub-floor combustion fuel; report uncertainty without destructive recovery |
| Missing parts | Optional/mod/not-ready content could be treated as critical | Classify core, optional, allowed-missing, delayed, and unknown evidence separately |
| Window sizing | Settings height could remain sticky on Chaos | Auto-size each tab from current content; retain manual size only after a real user resize |
| Fox mark | Compact symmetric mark was visually rejected | Supply an original, friendly, readable flat fox in the header and 250×120 app icon |
| Documentation | README was too short | Publish an evergreen README and versioned validation/audit documents |

## Evidence limitations

- These failures were reported after publication rather than captured through
  the formal 110-case template.
- The exact BeamNG build, vehicle/mod list, map, log excerpts, screenshots, and
  attempt count were not included in the report.
- Automated tests can reproduce lifecycle state sequences but cannot be
  relabeled as BeamNG gameplay evidence.
- v0.6.4 must publish as an Experimental prerelease for owner validation when
  this workspace cannot execute the live matrix itself.
