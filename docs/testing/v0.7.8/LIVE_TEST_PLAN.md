# v0.7.8 live test plan

Status: **Pending owner validation; not executed**.

Use only the exact ZIP downloaded from the public v0.7.8 prerelease. Before
testing, record the BeamNG build, renderer, map, language, UI scale/safe zone,
installed mods, player vehicle, ZIP filename, bytes and SHA-256. Automated
fixtures do not satisfy any case below.

| ID | Scenario | Required procedure and acceptance |
| --- | --- | --- |
| A | Scramble observability | On a vanilla vehicle, run Scramble at Chaos 25, 50 and 100. Compare before/after parts, tuning and paint, then open Details. The compact summary and full ledger counts must agree with final read-back; selected/attempted must not be mislabeled as changed, and a Partial result must remain explicit. |
| B | UI sizing | Exercise Chaos, Garage, Events and Settings in normal and compact modes at widths 320/360/400/480/600/720. Default normal height must follow useful content without severe empty space; explicit AppHost resizing must remain stable; no status, action or panel may overflow. |
| C | Formation | Open Events > Formation, traverse all formation modes, change spacing and heading, switch pt-BR/en-US/es-ES and reopen the dropdown at 320/360/400 px. No error boundary or `.filter is not a function` may occur; the chosen canonical formation must remain selected. |
| D | Preview on Gridmap | Stop the player in a wide flat Gridmap area, enable world preview with Automatic origin and calculate generation positions. Placement data must be ready without a false `position_blocked`; if the renderer draws, marker count/visible state must be explicit, otherwise the calculated-position fallback must remain usable. |
| E | Blocked-candidate recovery | Place an obstacle or vehicle on the first ideal candidate and calculate again. The solver must reject that candidate, choose a bounded nearby safe alternative, report attempts/reasons, and leave the obstacle, player, camera focus and unrelated vehicles unchanged. |
| F | Race generation | Generate four total vehicles (player plus three opponents) with Balanced and Maximum Chaos on a wide valid area. Generation must proceed without a false `lineup_staging_unsafe`; verify world cardinality, unique slot ownership, player protection, generation staging distinct from final formation and cleanup limited to Race-owned vehicles. |
| G | UI error containment | Produce a recoverable Race failure at narrow width. The full message must stay inside the App, Retry/Dismiss/Details must remain usable and scoped to the matching operation, and a successful retry must clear the obsolete error. |

Do not mark a case Passed without reviewed evidence from the downloaded
published asset. A rendered Preview frame proves only renderer visibility for
that exact run; calculated placement data and generation readiness remain
separate evidence axes.
