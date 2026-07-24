# Performance

Performance work is bounded and evidence-based. Benchmarks are diagnostic, not brittle CI timing gates.

## Recorded synthetic measurement

Command:

```powershell
python tools/profile_fixtures.py
```

Measured in five consecutive runs on 2026-07-23 with the shipped BeamNG 0.38.6 Lua 5.1 console on Windows 10:

```text
models=500
configs=5000
index_seconds median=0.022 range=0.022..0.025
slots=120
depth=120
candidates=2400
scan_seconds median=0.001 range=0.001..0.001
plan_seconds median=0.000 range=0.000..0.001
```

The console timer has millisecond resolution, so a reported `0.000` means below that resolution rather than no work. These are synthetic metadata shapes on one machine, not universal pass/fail promises. Re-run after material changes and report the environment; do not compare machines as if the values were deterministic.

The final 0.5 candidate rerun reported `index_seconds=0.034`, `scan_seconds=0.002`, and `plan_seconds=0.000` for the same 500/5,000/120/2,400 shape. It remains diagnostic evidence, not a timing gate.

## Budgets and bounds

- Registry normalization is linear in registered models/configs and is cached across normal operations; Reindex/mod-state changes invalidate it.
- Slot scan and mutation planning are bounded by the currently loaded tree/candidate set, not all installed ZIP contents.
- Mutation passes are depth-derived and bounded by no-progress/repeated-state/operation guards; descendants use a later fresh snapshot and trees beyond twelve levels can complete.
- Per-frame update work is constant-time except a scheduled stress step or one interval-limited lifecycle/paint read-back. Lifecycle candidates/events are capped at 16/32 and success requires five stable frames/two coherent scans.
- Paint confirmation is capped by two seconds and 12 attempts.
- Diagnostics retain 200 records; history is settings-bounded to 1–50 entries.
- Part suspects retain at most 128 records, eight fingerprints each, with a 900-second inactive TTL.
- Part recovery permits two retries per slot, eight per pass, four batch rollbacks, twelve operation retries, and 128 quarantined candidates. Load recovery opens its circuit breaker after three consecutive failures.
- Developer stress is capped at 50 sequential operations and 300 seconds.
- Vehicle DNA libraries are capped at 100 entries and 1 MiB canonical JSON; each entry is capped at 128 KiB, 2,048 slots, 2,048 tuning variables, 32 paint layers, and 20 tags.
- Canonical/import traversal is capped at 32 levels, 10,000 elements, 4,096 characters per string, and 512 characters per canonical path.
- Garage pages expose eight summaries at a time; the pure summary helper never returns more than 25.
- Garage search is debounced, compatibility/details/comparison/export/import are explicit lazy requests, and only the current eight-card page receives managed thumbnail URLs. Periodic state excludes full DNA, export text, and thumbnail bytes.
- Lock profiles are capped at 2,048 slot/part locks, 2,048 tuning locks, and 32 paint layers. Lineage depth is 32 and comparison output is capped at 4,096 differences.
- Managed images are capped at 100, 500x281, and 256 KiB each. Share archives are capped at 512 KiB, five entries, 256 KiB per entry, and 512 KiB total stored/uncompressed content.
- Vehicle DNA restore applies only the shallowest changed slot depth per pass. Its budget is derived from saved/current tree depth plus safety margin, clamped to 12–128 passes, with a 120-second deadline and explicit no-progress/repeated-state guards. It performs no synchronous retry loop or per-frame tree scan.
- Only one primary library and one last-known-good copy are retained. No per-entry backup directory can grow without bound.

## Runtime metrics

Public state exposes `replacementEvents`, `candidateVehicles`, `rebindCount`, `stabilizationFrames`, `stabilizationScans`, `stabilizationMs`, `partBatchRetries`, `partBatchRollbacks`, `quarantinedCandidates`, and `fullRandomPostSpawnMs`, plus index build/cache-hit counts, `garageLoadMs`, `compatibilityMs`, `thumbnailLoadMs`, `compareMs`, `exportMs`, `importMs`, `storageBytes`, `storageElements`, and the last operation's total duration, reload count, slot scan time, mutation planning time, tree depth, slot count, and candidate count. Diagnostics record pass metrics and safety status. Absolute machine paths are never included.

## Regression fixtures

The Lua suite constructs a deterministic 250-model/5,000-config registry and scans 100- and 160-level trees without hard timing assertions. It also verifies bounded diagnostics/suspects and index reuse. `tests/lua/profile.lua` provides the larger 500-model/5,000-config and 120-level/2,400-candidate measurement above.
