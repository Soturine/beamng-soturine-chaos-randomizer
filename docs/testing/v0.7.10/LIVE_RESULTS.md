# v0.7.10 live results

Authoritative status: **Pending owner validation; not executed**.

| Field | Value |
| --- | --- |
| Release version | 0.7.10 |
| Validation owner | repository owner |
| Required artifact | exact ZIP downloaded from the GitHub v0.7.10 experimental prerelease |
| Target | BeamNG.drive 0.39.4.x |
| Prior owner evidence | v0.7.9 on BeamNG 0.39.4.0.20972 / Direct3D 11 (see v0.7.9 live results) |

| Result | Count |
| --- | ---: |
| Executed | 0 |
| Passed | 0 |
| Failed | 0 |
| Pending | 15 |
| Blocked | 0 |

Run the cases in this order with the exact downloaded ZIP. Record the ZIP name,
bytes and SHA-256, BeamNG build, renderer, map and language, and keep the game
log (`race_preview_runtime_probe`, `race_slot_recovery`) with each result.

| # | Case | Expected | Status |
| ---: | --- | --- | --- |
| 1 | Balanced, 4 vehicles, player participates | 3/3 generated or explained per-slot recovery | Pending owner validation |
| 2 | Preview visible | "Preview formation" shows spheres/footprints in the world; state `PREVIEW_RENDERED` | Pending owner validation |
| 3 | Generate 3 NPCs | no orphan vehicle after a rejected candidate | Pending owner validation |
| 4 | Position All, one click | "Positioning 1/3…3/3" in one run, all three move | Pending owner validation |
| 5 | Line | straight line, not degraded | Pending owner validation |
| 6 | Grid | rows and columns, not degraded | Pending owner validation |
| 7 | Single File Ahead | one file ahead of the player | Pending owner validation |
| 8 | Single File Behind | one file behind the player | Pending owner validation |
| 9 | Follow me | NPCs follow the player | Pending owner validation |
| 10 | Chase | NPCs chase the player | Pending owner validation |
| 11 | Flee | NPCs flee the player | Pending owner validation |
| 12 | Remove → regenerate | no cleanup/binding error, fresh lineup | Pending owner validation |
| 13 | Custom (official off, no mods) | variety relaxes; opponents generated or a clear terminal reason | Pending owner validation |
| 14 | Maximum Chaos | undrivable results reported honestly | Pending owner validation |
| 15 | Narrow UI (320–720 px) | no overflow, cut select or dead space | Pending owner validation |

Automated contract tests do not execute BeamNG, prove visible markers, physical
AI movement, AppHost pixels or live performance. No v0.7.9 result is carried
forward as a v0.7.10 pass or failure.
