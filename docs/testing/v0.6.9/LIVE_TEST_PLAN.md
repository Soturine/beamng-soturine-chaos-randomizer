# Live BeamNG 0.39 performance plan — v0.6.9

Status: **Pending owner validation**.

Use only the downloaded `soturine_chaos_randomizer_0.6.9.zip` after verifying
the attached checksum and manifest. Automated/synthetic results cannot pass a
row in this plan.

## Required environment

- BeamNG.drive 0.39 exact build recorded in evidence;
- clean BeamNG cache and Gridmap;
- only v0.6.9 of this mod enabled;
- BeamLR and Driver Assistance disabled;
- backup of settings, Vehicle DNA, lineups, and screenshots;
- identical graphics/traffic/simulation settings across comparable runs;
- profiling reset immediately before each case.

## Measurements for every case

Record average FPS, 1% low, frame time, `onUpdate` p50/p95/p99, GC, RAM, VRAM,
`guihooks/s`, `diagnostics/s`, total vehicle count, managed count, and orphan
count. Also record exact game build, artifact SHA-256, map, vehicle count, seed,
catalog fingerprint, settings, active mods, duration/iterations, and whether
Details/compact mode was open.

## Matrix

Each scenario has four independent cases: 1, 4, 8, and 12 total vehicles.
Where a gameplay action naturally controls only the player vehicle, park the
remaining external vehicles first and verify ownership isolation. Every cell
starts Pending.

| IDs | Scenario | 1 vehicle | 4 vehicles | 8 vehicles | 12 vehicles | Required observation |
|---|---|---|---|---|---|---|
| L01–L04 | idle | Pending | Pending | Pending | Pending | 120 s steady HUD, profiling on/off comparison, no growing hooks/diagnostics/orphans |
| L05–L08 | Random Car | Pending | Pending | Pending | Pending | 20 fixed-seed actions, cardinality/ownership preserved |
| L09–L12 | Scramble | Pending | Pending | Pending | Pending | 20 fixed-seed actions, same player identity, no extra world vehicle |
| L13–L16 | Full Random | Pending | Pending | Pending | Pending | complete pipeline, deterministic result, bounded waits and cleanup |
| L17–L20 | Race generation | Pending | Pending | Pending | Pending | generate requested scale, no duplicate seeds/handles, progress responsive |
| L21–L24 | Placement | Pending | Pending | Pending | Pending | preview then place, dimension cache evidence, no repeated all-OOBB reads |
| L25–L28 | Drive | Pending | Pending | Pending | Pending | managed state transitions and distributed observation remain responsive |
| L29–L32 | AI | Pending | Pending | Pending | Pending | Destination/Route/Chase/Follow/Traffic, readback or honest unavailable fallback |
| L33–L36 | Details | Pending | Pending | Pending | Pending | closed/open comparison of hooks, bytes, diagnostics serialization |
| L37–L40 | compact | Pending | Pending | Pending | Pending | minimum payload, responsive progress, stable remount/observer cleanup |
| L41–L44 | Garage | Pending | Pending | Pending | Pending | 100 then 500 entries; page/search/filter/thumbnail/compare remain bounded |
| L45–L48 | reindex | Pending | Pending | Pending | Pending | full rebuild chunks, real progress, last valid catalog retained |
| L49–L52 | mod activation | Pending | Pending | Pending | Pending | enable/disable a vehicle mod, fingerprint invalidates, one restart, ready atomically |
| L53–L56 | cancel | Pending | Pending | Pending | Pending | cancel Chaos/index/Race/AI at active phases, no stale poll/callback resumes |
| L57–L60 | cleanup | Pending | Pending | Pending | Pending | owned orphan queue batches; external vehicles untouched; no repeated delete |
| L61–L64 | cache restart | Pending | Pending | Pending | Pending | cold miss, warm hit, corrupt cache fallback, manual invalidation/readback |

## Outcome rules

- Passed requires execution with complete measurements and expected ownership,
  determinism, lifecycle, and bounded-growth evidence.
- Failed remains Failed even if a later rerun passes; append the rerun.
- Blocked records the external blocker and evidence.
- Do not claim an FPS, latency, GC, RAM, VRAM, hook, or diagnostic improvement
  without a controlled live comparison against recorded baseline evidence.

Totals at publication: 0 executed / 0 passed / 0 failed / 64 pending / 0 blocked.

