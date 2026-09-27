# v0.7.10 live results

Authoritative status: **Partially executed by the owner on 2026-09-27; failed**.

| Field | Value |
| --- | --- |
| Release version | 0.7.10 |
| Validation owner | repository owner |
| Artifact | `soturine_chaos_randomizer_0.7.10.zip` mounted from the user mods folder |
| Environment | BeamNG.drive 0.39.4.0.20972 / Direct3D 11, Gridmap V2 |
| Evidence | owner report and screenshots; game log `beamng.log` (no Lua, Vue or CEF error recorded) |

| Result | Count |
| --- | ---: |
| Executed | 2 |
| Passed | 0 |
| Failed | 2 |
| Pending | 13 |
| Blocked | 0 |

| # | Case | Status | Observation |
| ---: | --- | --- | --- |
| 1 | Balanced, 4 vehicles, player participates | Pending owner validation | not reported |
| 2 | Preview visible | Failed | Partial pass: spheres, footprints, headings, `[OK]` labels and the player marker were visible in the world (renderer path, `debugDrawer`, `ColorF`/`vec3` bridge confirmed live). Failed: markers stayed at the planned coordinates when the car moved; after using the preview the whole app became a black rectangle without header, tabs or content and stopped responding; the preview a user finds first was hidden in Advanced options while "Preview formation" was disabled with 0 NPCs; the "Automatic (player when participating)" origin label was truncated. |
| 3 | Generate 3 NPCs | Pending owner validation | not reported |
| 4 | Position All, one click | Pending owner validation | not reported |
| 5 | Line | Pending owner validation | not reported |
| 6 | Grid | Pending owner validation | not reported |
| 7 | Single File Ahead | Pending owner validation | not reported |
| 8 | Single File Behind | Pending owner validation | not reported |
| 9 | Follow me | Pending owner validation | not reported |
| 10 | Chase | Pending owner validation | not reported |
| 11 | Flee | Pending owner validation | not reported |
| 12 | Remove → regenerate | Pending owner validation | not reported |
| 13 | Custom (official off, no mods) | Pending owner validation | not reported |
| 14 | Maximum Chaos | Pending owner validation | not reported |
| 15 | Narrow UI (320–720 px) | Failed | origin select label truncated in the Formation step |

Causes and fixes are in the [v0.7.11 root cause report](../v0.7.11/ROOT_CAUSE_REPORT.md).
