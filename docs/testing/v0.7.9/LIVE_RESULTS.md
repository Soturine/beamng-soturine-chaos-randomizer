# v0.7.9 live results

Authoritative status: **Partially executed by the owner on 2026-09-27; failed**.

| Field | Value |
| --- | --- |
| Release version | 0.7.9 |
| Validation owner | repository owner |
| Artifact | `soturine_chaos_randomizer_0.7.9.zip` mounted from the user mods folder |
| Environment | BeamNG.drive 0.39.4.0.20972 / Direct3D 11 |
| Evidence | owner report, game log `beamng.log`, persisted lineup `lineup-015B3BDA` |

| Result | Count |
| --- | ---: |
| Executed | 5 |
| Passed | 0 |
| Failed | 2 |
| Pending | 10 |
| Blocked | 3 |

| Case | Status | Observation |
| --- | --- | --- |
| A - Balanced clean Race | Pending owner validation | not reported |
| B - Maximum Chaos | Pending owner validation | not reported for this session |
| C - Remove/regenerate | Pending owner validation | not reported |
| D - Single File Ahead | Pending owner validation | not reported |
| E - Single File Behind | Pending owner validation | not reported |
| F - Line | Pending owner validation | not reported |
| G - Side-by-side Grid | Pending owner validation | not reported |
| H - Explicit Camera origin | Pending owner validation | not reported |
| I - Position All UX | Failed | did not position every opponent; last run had 0 placeable opponents |
| J - Preview visibility | Failed | 4 markers calculated, nothing drawn; log: `preview_renderer_unavailable`, 1227 frames attempted, 0 drawn |
| K - Follow | Blocked | Behavior blocked: 0 NPCs ready for AI |
| L - Chase/Flee | Blocked | Behavior blocked: 0 NPCs ready for AI |
| M - Traffic/Roam | Blocked | Behavior blocked: 0 NPCs ready for AI |
| N - Narrow UI | Pending owner validation | not reported |
| O - Repeated placement click | Pending owner validation | not reported |

Additional observation outside the A-O plan: Race Custom with 4 vehicles and
the player participating produced 1 Partial and 2 Failed slots
(`no_eligible_vehicles`), leaving 0 opponents ready for generation, placement,
drivability or AI. Causes and fixes are in the
[v0.7.10 root cause report](../v0.7.10/ROOT_CAUSE_REPORT.md).
