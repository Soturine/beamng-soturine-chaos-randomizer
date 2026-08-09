# v0.7.4 live findings carried into v0.7.5

Status: **Executed live by the repository owner against the published v0.7.4 ZIP; failures observed**.

These findings are the ground truth for v0.7.5 work. They do not retroactively change the frozen v0.7.4 reports, and they do not prove any v0.7.5 correction live. Exact logs, seeds, vehicle names, counts, and renderer details not supplied by the owner are not invented.

| ID | Severity | Owner-observed behavior | Initial cause status | v0.7.5 invariant |
| --- | --- | --- | --- | --- |
| OUTCOME-074-01 | P0 | Successful Random Car, Scramble, or Full Random can be presented as partial/failed because later telemetry or verification is inconclusive | Hypothesis pending code confirmation | Applied outcome and confidence are separate; late non-fatal evidence cannot reverse a commit |
| WATCH-074-01 | P0 | `Operation watchdog stalled` can stop legitimate Random Car processing | Hypothesis pending code confirmation | Phase-aware semantic progress; terminal outcome immutable |
| PERF-074-01 | P1 | Full Random remains reload/readback heavy and can exceed its deadline | Hypothesis pending code confirmation | Bounded reload/readback/repair counts with no repeated discovery without reason |
| PREVIEW-074-01 | P0 | UI reports four preview markers/ready, but no world marker is visible | Hypothesis pending renderer-path confirmation | Data ready differs from successfully rendered/visible |
| PREVIEW-074-02 | P0 | Enabled preview may not turn off | Hypothesis pending preference round-trip confirmation | OFF clears overlay in the same logical cycle and persists through normalization |
| RACE-074-01 | P0 | Background Race generation steals player/camera focus until candidate removal | Hypothesis pending event-path confirmation | Player focus remains/restores to P while mutation continues on explicit candidate ID |
| RACE-074-02 | P0 | Race candidate spawns outside its planned staging/placement | Hypothesis pending spawn-path confirmation | Every slot owns a unique staging transform from first spawn |
| RACE-074-03 | P0 | Mods Showcase rejects stable unusual cars for critical/required parts | Hypothesis pending Safety-policy confirmation | Runtime integrity strict; mod metadata/drivability permissive under preset |
| RACE-074-04 | P0 | Candidate fails, is deleted, and subsequent slots repeat; accepted retention is not established live | Hypothesis pending ownership-path confirmation | Slot failure is local; prior accepted vehicles remain protected |
| RACE-074-05 | P0 | `Lineup storage failed` interrupts or cascades generation | Hypothesis pending persistence-path confirmation | Valid in-memory lineup continues through bounded checkpoint failure |
| RACE-074-06 | P0 | Regeneration can remain at `0/N`, with every competitor Planned | Hypothesis pending scheduler reset confirmation | Active+planned+idle starts slot 1 or terminates explicitly within a bound |
| I18N-074-01 | P1 | Raw phase IDs and technical English BeamNG notifications remain visible | Hypothesis pending presentation-path confirmation | Normal UI receives translated human labels; codes stay in Details |
| UI-074-01 | P1 | AppHost remains taller than minimal content | Hypothesis pending geometry-path confirmation | Closed disclosure returns to measured minimum intrinsic height |
| UI-074-02 | P1 | Locks remain too visually prominent | Confirmed presentation observation; code cause pending | Primary Chaos flow shows one compact summary/action |
| UI-074-03 | P1 | Compact is not truly compact on every tab | Confirmed presentation observation; code cause pending | Each tab has dedicated compact content and geometry |
| UI-074-04 | P1 | Text, selects, paths, lists, buttons, or footer can clip/overflow | Confirmed presentation observation; exact components pending | No application-level horizontal overflow at required widths/content sizes |
| UI-074-05 | P1 | Race/AI flow is fragmented and technical | Confirmed presentation observation; information-architecture cause pending | Guided Events flow separates simple presets from advanced controls |
| AI-074-01 | P1 | UI and AI adapter may disagree on supported modes, including suspected Flee mismatch | Hypothesis pending parity audit | Every visible mode has adapter support and a translated label |

## Evidence boundary

No v0.7.5 renderer, controller, UI-scale, safe-zone, gameplay, third-party mod, performance, Race, Preview, AI, or multiplayer result is live-passed. All new live cases start as **Pending owner validation** and must use the exact published v0.7.5 ZIP.
