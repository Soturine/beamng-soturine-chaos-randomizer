# v0.7.12 live results

Authoritative status: **Pending owner validation; not executed**.

| Field | Value |
| --- | --- |
| Release version | 0.7.12 |
| Validation owner | repository owner |
| Required artifact | exact ZIP downloaded from the GitHub v0.7.12 experimental prerelease |
| Target | BeamNG.drive 0.40.4.0 (build 296339) |
| Prior owner evidence | v0.7.10 on BeamNG 0.39.4.0.20972 / Direct3D 11; no 0.40 session yet |

| Result | Count |
| --- | ---: |
| Executed | 0 |
| Passed | 0 |
| Failed | 0 |
| Pending | 18 |
| Blocked | 0 |

Use only the downloaded ZIP with no other copy of the mod enabled. Record the
renderer and map. Cases 1-6 are P0: if one fails, stop, keep
`%LOCALAPPDATA%\BeamNG\BeamNG.drive\current\beamng.log` and a screenshot, and
record the step.

| # | Case | Expected | Status |
| ---: | --- | --- | --- |
| 1 | Boot 0.40.4, add the app from UI Apps | app renders, tabs work, no Lua error in the console | Pending owner validation |
| 2 | Events → Formation → Show preview, drive and turn | markers follow and rotate with the car; Hide removes them at once | Pending owner validation |
| 3 | App stays interactive after the preview | header, tabs and buttons visible and clickable, no black panel | Pending owner validation |
| 4 | Generate 3 opponents (4 cars total) | 3 cars generated, none left behind on failure | Pending owner validation |
| 5 | Position All, one click | all 3 cars move in one run; Line and Grid are straight | Pending owner validation |
| 6 | Walk (on foot) into one opponent, then Regenerate | that car is kept, the app says a player is inside it | Pending owner validation |
| 7 | Follow me preset | opponents follow; status reaches Running after "Checking AI" | Pending owner validation |
| 8 | Stop, then Reset AI | opponents stop; Reset clears destination and route | Pending owner validation |
| 9 | Record my route: drive ~30 s, stop | "Route ready: N points" | Pending owner validation |
| 10 | Recorded route mode, Start | each opponent starts from its own slot and follows the route | Pending owner validation |
| 11 | Random Car, Scramble, Full Random (Balanced) | each finishes with a readable result; Undo restores | Pending owner validation |
| 12 | Full Random on Maximum Chaos | finishes or reports a readable failure; no orphan car | Pending owner validation |
| 13 | Cherrier Percheron: Scramble and Full Random | truck stays drivable or the failure is reported; no crash | Pending owner validation |
| 14 | On foot: press Scramble | refused with "You are on foot" | Pending owner validation |
| 15 | Garage: save DNA, restart the game, restore | DNA persists and restores | Pending owner validation |
| 16 | Split-screen with 2 players: player 2 configures their own car while player 1 runs Scramble | only player 1's car changes | Pending owner validation |
| 17 | Split-screen: player 2 sits in an opponent; Remove that opponent | refused; player 2 keeps the car | Pending owner validation |
| 18 | Ctrl+L with the app open | app recovers; no stale operation | Pending owner validation |

Automated contract tests do not execute BeamNG, prove visible markers, AppHost
pixels, physical AI movement, split-screen behaviour or live performance. No
earlier result is carried forward as a v0.7.12 pass or failure.
