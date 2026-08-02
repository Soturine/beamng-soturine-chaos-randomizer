# Soturine's Chaos Randomizer 0.6.9

Release title: **v0.6.9 — P1 Performance, Profiling and Efficiency**

Status: **Experimental prerelease — live BeamNG performance validation pending**.

Automated validation: Passed

Automated detail: 65 passed, 1,099 subtests passed; 394 Lua cases and 49 JavaScript checks.

Live BeamNG 0.39 validation: Pending owner validation

Live BeamNG validation: Pending owner validation

Live cases: 0 executed / 0 passed / 0 failed / 64 pending / 0 blocked

## Highlights

- Opt-in bounded profiling exposes count/total/min/max/mean/last and
  p50/p95/p99 for 18 required runtime stages.
- Configurable idle, busy, Race, UI, and index budgets report amortized excess
  evidence without aborting operations.
- Low-GC vehicle iterators use safe fallbacks and owned reusable buffers.
- OOBB XYZ capability detection and generation-scoped dimension caching reduce
  repeated placement/preview measurements without reusing recycled IDs.
- A versioned, checksummed, privacy-bounded registry cache uses BeamNG/mod/
  aliases/settings fingerprints and transactional readback.
- Catalog rebuild is incremental, cancellable, restartable, and atomic; partial
  snapshots never replace the last complete index.
- Initial/explicit UI state remains full while responsive progress uses
  debounced diffs with hook/byte/suppression counters.
- Diagnostics are fingerprinted, deduplicated, rate-limited, bounded, compact
  when Details is closed, and fully sanitized on explicit export.
- Polling starts fast, backs off while stable, wakes on events, rejects stale
  generations, and stops at terminal state.
- Managed AI confirms readable mode state before Running; unsupported readback
  keeps the fallback and records `mode_confirmation_unavailable`.
- Race 1/4/8/12 and generator-6 Random Car, Scramble, Full Random, Race, Vehicle
  DNA replay, and pure-seed vectors are covered without changing determinism.

## Validation boundary

The recorded 11-scenario Lua matrix is a synthetic microbenchmark, not FPS or
live gameplay proof. No BeamNG world, physics, rendering, GC, RAM/VRAM, HUD, or
third-party content performance case was executed. All 64 owner cells remain
Pending.

## Preserved scope

Chaos, Garage, Race, Race Policy, Vehicle DNA, compatibility target/minimum,
generator version 6, and the Angular compatibility host are preserved.

## Roadmap

v0.7.0 = Vue migration and architecture modernization

post-v0.7.0 = fresh audit after BeamNG 0.39.x hotfixes

## Assets

- `soturine_chaos_randomizer_0.6.9.zip`
- `soturine_chaos_randomizer_0.6.9.zip.sha256`
- `soturine_chaos_randomizer_0.6.9.manifest.json`

Install the attached ZIP, not GitHub's automatic source archive. Verify both
companion assets and keep only one Randomizer version enabled.
