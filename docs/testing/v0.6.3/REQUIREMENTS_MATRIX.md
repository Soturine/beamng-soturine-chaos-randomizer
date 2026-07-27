# Requirements matrix — 0.6.3

`Automated verified` means executed deterministic evidence, never live BeamNG proof. P0 gameplay rows remain release-blocking until the exact artifact passes the live plan.

| ID | Requirement | Implementation/evidence | Automated | Live |
| --- | --- | --- | --- | --- |
| P0-01 | Random Car, Scramble, Full Random without pause dependency | monotonic clocks, update-driven pipeline, mocked unpaused/pause variants | Verified | Pending |
| P0-02 | No 22% target stall | logical target, candidate-only returned ID, coherent player discovery | Verified | Pending |
| P0-03 | No 57% parts stall | ownership release/rebind per reload, bounded readable-tree retry | Verified | Pending |
| P0-04 | Do not discard correct target with changed ID | validated rebind and final unbound read | Verified | Pending |
| P0-05 | No recovery loop/old callback reuse | generations, invalidation, fingerprint visit limit | Verified | Pending |
| P0-06 | Busy always terminal | terminal phase guard and state-machine properties | Verified | Pending |
| P0-07 | Writes remain target-bound | adapter preconditions and operation continuation context | Verified | Pending |
| P0-08 | Combustion fuel at least 10% | storage classifier, bounded correction and readback | Verified | Pending |
| P0-09 | Slider orange fill | real track/fill element and 0/50/79/100 JS tests | Verified | Pending visual |
| P0-10 | v0.6.1 fox restored | Git blob/hash comparison | Verified bytes | Pending visual |
| P0-11 | Chaos content sizing | rendered-content measurement, manual floor, loop guard | Verified JS/static | Pending visual |
| P1-01 | Dynamic vehicle/config index | mounted registry and evidence source classifier | Verified | Pending mods |
| P1-02 | Dynamic recursive part slots | scanner, parent-first convergence and bounds | Verified | Pending mods |
| P1-03 | Dynamic iterative tuning | fixed-point/cycle signatures and metadata revisions | Verified | Pending mods |
| P1-04 | Chaos 100 classifies all eligible | slot/tuning/paint ledgers | Verified | Pending |
| P1-05 | Malformed content degrades honestly | capability/status and skip reasons | Verified | Pending |
| P1-06 | Dead tuning module resolved | duplicate removed; tests use production pipeline | Verified architecture | Not applicable |
| P1-07 | CRC32 deduplicated | shared module and canonical vectors | Verified | Not applicable |
| P1-08 | Independent adapter capabilities | player and exact-ID read paths detected separately | Verified | Pending API |
| P1-09 | Orphan modules rejected | production require graph from documented entrypoints | Verified | Not applicable |
| P1-10 | Evergreen docs and archive | current guides/status plus preserved historical evidence | Source verified | Not applicable |
| P1-11 | Test categories/counts honest | separate reports and runner metrics | Verified | Pending live |
| P2-01 | Reduce risky central ownership | explicit operation context and shared coverage context | Verified | Pending |
| P2-02 | Canonical Race domain | `raceManager` plus legacy facade | Verified | Pending |
| P2-03 | Safe UI separation | exported pure UI math; gameplay remains Lua | Verified | Pending visual |
| P2-04 | Performance instrumentation | bounded percentiles and UI event rate | Verified collector | Pending measurements |
| REL-01 | Reproducible package/manifest/checksum | package builder, validator, checksum, manifest v3 | Verified exact candidate | Pending install |
| REL-02 | Version metadata synchronized | VERSION/app/main/HTML/release notes | Verified | Not applicable |
| REL-03 | Tag/release only after live gate | tag workflow runs exact-artifact live validator | Verified gate | Blocking |
| HIST-01 | Preserve v0.6.2 tag/release/assets/history | initial Git/GitHub audit; no rewrite/force push | Verified audit | Not applicable |

Detailed executed tests are listed in [AUTOMATED_TEST_REPORT.md](AUTOMATED_TEST_REPORT.md); row-level gameplay evidence belongs only in [LIVE_TEST_REPORT.md](LIVE_TEST_REPORT.md).
