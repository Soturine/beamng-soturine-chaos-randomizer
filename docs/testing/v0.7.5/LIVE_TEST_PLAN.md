# v0.7.5 live test plan

Execute only with the exact ZIP downloaded from the published GitHub v0.7.5
prerelease. Record each case with `EVIDENCE_TEMPLATE.md`. Automated results do
not satisfy these cases.

| Group | IDs | Cases | Required observations |
| --- | --- | ---: | --- |
| UI | UI-A01–UI-A10 | 10 | Expanded/compact; intrinsic height; 320/360/420/480/560/640/720 px; Locks; SmartSelect; Garage; Events; Details; all three locales; no raw phase IDs |
| Random Car | RC-B01–RC-B05 | 5 | Vanilla, light mod, heavy mod, ten-run sequence; no clone, false partial or false watchdog |
| Scramble | SC-C01–SC-C04 | 4 | Ten runs, same concrete ID, mod content, unknown telemetry/skips |
| Full Random | FR-D01–FR-D05 | 5 | Vanilla, FallGems-like content, heavy mod, unusual stable vehicle, recorded duration/reload/readback/outcome |
| Events with player | EV-E01–EV-E09 | 9 | Four total vehicles/three NPCs; visible Preview; off toggle; unique staging; player focus; retained READY slots; physical counts |
| Spectator | SP-F01–SP-F04 | 4 | Four NPCs, player excluded, distinct placement, player never a candidate |
| Regeneration | RG-G01–RG-G03 | 3 | Forced slot failure, transient checkpoint failure/retry, regeneration leaves 0/N Planned state |
| AI | AI-H01–AI-H07 | 7 | Follow, Convoy, Chase, Flee, Traffic, Roam/Swarm and Stop All on owned NPCs |

Total planned live cases: **47**.

Tag is not a v0.7.5 user-facing feature, so no Tag live case is counted. Its
foundation is automated-only and must not be described as implemented gameplay.

For every Race case capture player/candidate IDs, slot ownership, focus before/
during/after, staging/final transforms, Preview renderer state, world vehicle
delta, persistence state and terminal outcome. For performance cases capture
counts and timings without converting one machine/run into a general claim.
