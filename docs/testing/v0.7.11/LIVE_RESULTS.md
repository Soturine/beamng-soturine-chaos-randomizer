# v0.7.11 live results

Authoritative status: **Pending owner validation; not executed**.

| Field | Value |
| --- | --- |
| Release version | 0.7.11 |
| Validation owner | repository owner |
| Required artifact | exact ZIP downloaded from the GitHub v0.7.11 experimental prerelease |
| Target | BeamNG.drive 0.39.4.x |
| Prior owner evidence | v0.7.10 on BeamNG 0.39.4.0.20972 / Direct3D 11 (see v0.7.10 live results) |

| Result | Count |
| --- | ---: |
| Executed | 0 |
| Passed | 0 |
| Failed | 0 |
| Pending | 13 |
| Blocked | 0 |

Run in this order with the exact downloaded ZIP. If any of steps 1–8 fails,
stop, keep `beamng.log` and a screenshot, and record the step.

| # | Case | Expected | Status |
| ---: | --- | --- | --- |
| 1 | Open Events → Formation without generating | Formation step usable, no empty card | Pending owner validation |
| 2 | Show preview | markers appear; "Preview on · estimated sizes" | Pending owner validation |
| 3 | App stays interactive | header, tabs and buttons visible and clickable | Pending owner validation |
| 4 | Drive the player forward | markers move with the car | Pending owner validation |
| 5 | Turn the player 90° | formation rotates with the car | Pending owner validation |
| 6 | Markers follow | player marker stays on the car | Pending owner validation |
| 7 | Hide preview | markers disappear at once | Pending owner validation |
| 8 | Show preview again | markers reappear at the current position | Pending owner validation |
| 9 | Generate 3 NPCs | preview refreshes with real sizes | Pending owner validation |
| 10 | Position All | all three move in one run | Pending owner validation |
| 11 | Line | straight line | Pending owner validation |
| 12 | Grid | rows and columns | Pending owner validation |
| 13 | Follow me | NPCs follow the player | Pending owner validation |

Automated contract tests do not execute BeamNG, prove visible markers, AppHost
pixels, physical AI movement or live performance. No v0.7.10 result is carried
forward as a v0.7.11 pass or failure.
