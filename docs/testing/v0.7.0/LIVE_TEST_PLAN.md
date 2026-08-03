# v0.7.0 live BeamNG test plan

Status: **Stopped after first-case failure**. The downloaded v0.7.0 release ZIP
returned the `/stores` 404 before the HUD mounted. One case failed and the
remaining 81 were blocked; this plan is retained to define inherited v0.7.1
regression coverage.

## Environment

- Current BeamNG 0.39 build with exact build number recorded.
- Clean UI cache and profile; Gridmap; backup of Chaos Randomizer user data.
- Only the v0.7.0 ZIP active; no v0.6.9, BeamLR, or Driver Assistance.
- Install from the published ZIP, not source or a local development folder.

## Planned matrix

| IDs | Area | Cases | Evidence |
|---|---|---:|---|
| E01–E06 | Environment, artifact hash, cache, profile, Gridmap, backups | 6 | Environment record and logs |
| D01–D09 | One selector entry, icon/name/version, Vue load, no Angular, console, remove/re-add, restart, layout | 9 | Screenshots and log excerpts |
| C01–C09 | 20 Random Car, 20 Scramble, 20 Full Random, cancel, failure, partial, Details, compact, orphan count | 9 | Run sheets and diagnostics |
| G01–G13 | Garage 0/10/100/500, search/filter/sort/page, thumbnail, save/restore/replay/compare/mutate, JSON/package | 13 | Library backup, screenshots, logs |
| R01–R15 | Race 1/4/8/12, player/spectator, presets/policy, cancel/retry, Placement/formations/narrow track, Drive/AI/cleanup | 15 | Run sheets and ownership counts |
| V01–V10 | 80/100/125/150/200%, 720p/1080p/1440p/4K, ultrawide/multi-monitor/safe area/HDR | 10 | Screenshots at declared settings |
| I01–I07 | Mouse, keyboard, Xbox, DualSense, directional focus, Back, dialog/compact navigation | 7 | Input checklist and video/screens |
| L01–L04 | en-US, pt-BR, live switch, long/fallback strings | 4 | Paired screenshots and console |
| Y01–Y05 | 100 tabs, 100 compact toggles, 100 Details, 50 remove/add, 50 remount equivalents | 5 | Subscription/timer/memory samples |
| P01–P04 | v0.6.9 comparison, Garage 500, Race 12, long lifecycle/memory | 4 | FPS, 1% low, frame time, UI latency, Lua percentiles, hook/bytes, memory |
| **Total** |  | **82** |  |

Every row records Passed, Failed, Pending, or Blocked with actual result,
environment, artifact SHA-256, steps, evidence, and issue reference. A skipped
case remains Pending unless an objective blocker is recorded.

No performance improvement may be claimed without the P-series execution.
