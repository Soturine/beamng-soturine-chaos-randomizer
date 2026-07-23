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
index_seconds median=0.020 range=0.019..0.023
slots=120
depth=120
candidates=2400
scan_seconds median=0.001 range=0.001..0.002
plan_seconds median=0.000 range=0.000..0.001
```

The console timer has millisecond resolution, so a reported `0.000` means below that resolution rather than no work. These are synthetic metadata shapes on one machine, not universal pass/fail promises. Re-run after material changes and report the environment; do not compare machines as if the values were deterministic.

## Budgets and bounds

- Registry normalization is linear in registered models/configs and is cached across normal operations; Reindex/mod-state changes invalidate it.
- Slot scan and mutation planning are bounded by the currently loaded tree/candidate set, not all installed ZIP contents.
- Mutation passes are Chaos-derived and hard-capped at five; descendants use a later fresh snapshot.
- Per-frame update work is constant-time except a scheduled stress step or one interval-limited paint read-back.
- Paint confirmation is capped by two seconds and 12 attempts.
- Diagnostics retain 200 records; history is settings-bounded to 1–50 entries.
- Part suspects retain at most 128 records, eight fingerprints each, with a 900-second inactive TTL.
- Developer stress is capped at 50 sequential operations and 300 seconds.

## Runtime metrics

Public state exposes index build/cache-hit counts and the last operation's total duration, reload count, slot scan time, mutation planning time, tree depth, slot count, and candidate count. Diagnostics record pass metrics and safety status. Absolute machine paths are never included.

## Regression fixtures

The Lua suite constructs a deterministic 250-model/5,000-config registry and scans 100- and 160-level trees without hard timing assertions. It also verifies bounded diagnostics/suspects and index reuse. `tests/lua/profile.lua` provides the larger 500-model/5,000-config and 120-level/2,400-candidate measurement above.
