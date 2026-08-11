# v0.7.6 live test plan

Execute only with the exact ZIP downloaded from the published GitHub v0.7.6 prerelease. Record each case with `EVIDENCE_TEMPLATE.md`; automated, jsdom, mounted UI and Lua fixture results do not satisfy live cases.

| Group | IDs | Cases | Required observations |
| --- | --- | ---: | --- |
| AppHost/UI | UI-A01-UI-A12 | 12 | Open normal and idle; visit every tab; 50 tab changes; advanced open/close; compact on/off 50 times; move/resize; remount; edit layout; HUD reset; safe area; scale; normal never self-collapses |
| Events/Race | EV-B01-EV-B20 | 20 | Preview on/off and visible frame; Position blocked+Retry; staging unsafe+Retry; regenerate; cancel; persistent/dismissed errors; player focus; 3 AI+player; spectator; Mods Showcase; slot 1 failure/slot 2 continuation; typed storage error+Retry; planned deadlock recovery; place all; remove owned NPCs; Stop AI; reset/reopen |
| Real mod matrix | MOD-C01-MOD-C07 | 7 | Simple vanilla; complex vanilla; FallGems; another real mod pack/config; incomplete metadata; slow first load; missing optional slots |
| Random Car | RC-D01-RC-D05 | 5 | About 20 executions split across vanilla, real mods, heavy first load, repeated replacement and external-world-change cases; no clone or frequent false watchdog |
| Scramble | SC-E01-SC-E04 | 4 | About 20 executions split across vanilla/mod/unknown telemetry/optional-skip cases; same physical identity; warnings/skips do not become generic partial |
| Full Random | FR-F01-FR-F06 | 6 | 10-20 executions across vanilla, real mods, wide part tree, slow first load, deadline and external-world-change cases; no clones; correct cardinality; no raw phase code |

Total planned live cases: **54**.

## Required environment matrix

- BeamNG.drive 0.39.4, exact full build recorded.
- D3D11, D3D12 and Vulkan where available; unavailable combinations are recorded as `Not applicable`, never Passed.
- Mouse, keyboard and scoped UINav/controller; Back/Escape and focus return.
- en-US, pt-BR and es-ES; multiple UI scales, safe zones and AppHost widths.
- Clean profile plus the named real-mod combinations above.

For every Race case capture player/candidate IDs, operation/generation/slot ownership, camera and focus before/during/after, staging/final transforms, Preview renderer state and drawn marker count, world delta, persistence state and terminal outcome. For randomizer cases capture source/candidate/accepted IDs, expected remove/add sets, applied-state and confidence axes, reload/readback counts and phase durations. A machine/run timing is evidence for that run only.
