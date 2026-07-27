# Requirements matrix — 0.6.4

| ID | Requirement | Implementation evidence | Automated evidence | Live evidence |
| --- | --- | --- | --- | --- |
| R01 | Record actual v0.6.3 failures honestly | v0.6.3 `KNOWN_LIVE_FAILURES.md` and report | static/document review | owner report preserved |
| R02 | No timeout/pause workaround | `timeSource.lua`, `operationState.lua`, GE `onUpdate` orchestration | pause/no-toggle lifecycle cases | L01–L10 Pending |
| R03 | Separate logical and concrete targets | `runtime/operationContext.lua` | rebind/stale/destroyed tests | L11–L20 Pending |
| R04 | Callbacks are advisory | `vehicleTargetTracker.lua` | absent/duplicate/order tests | L21–L30 Pending |
| R05 | Observe independent config sources | `apiAdapter.getVerificationState` | fresh player + stale manager fixture | L31–L40 Pending |
| R06 | Accept already-applied phase state | target tracker evidence selection | no-callback public pipelines | L41–L50 Pending |
| R07 | Reject unrelated/stale targets | generations, player-0/model/config checks | switch/stale property tests | L51–L60 Pending |
| R08 | Explicit terminal outcomes | `finishOperation` outcome mapping | success/partial/cancel/recovery cases | R01–R10 Pending |
| R09 | Preserve stable nonfatal result | fuel/parts nonfatal flags and recovery gating | unreadable/uncertain fixtures | R11–R20 Pending |
| R10 | Combustion-only fuel floor | `energyStorageGuard.lua` | classification/single/multi/hybrid tests | F01–F10 Pending |
| R11 | Unknown fuel is not fatal | `ensureEnergyStorageFloor` warning paths | unresolved/unavailable tests | F11–F20 Pending |
| R12 | Classify missing parts | `slotScanner.lua`, `validator.lua` | optional/mod/core tests | P01–P10 Pending |
| R13 | Retry loading tree then preserve | bounded read retry and partial continuation | transient/persistent nil tests | P11–P20 Pending |
| R14 | Dynamic full-tree convergence | coverage ledgers and convergence limits | deep/dynamic/disappearing tests | D01–D10 Pending |
| R15 | Dynamic tuning fixed point | `tuningPipeline.lua` | revision/cycle/clamp/nonfinite tests | D11–D20 Pending |
| R16 | Auto tab sizing | JS auto/user/collapsed policy | 20-cycle sizing tests | U01–U10 Pending |
| R17 | No resize feedback loop | programmatic timestamp/source debounce | resize-mode JS assertions | U11–U20 Pending |
| R18 | Preserve orange slider | real fill + transparent native track | 0/1/50/99/100 JS/static | U21–U25 Pending |
| R19 | Original friendly fox in both assets | `fox-mark.svg`, `app-icon.svg`, `app.png` | XML/PNG/dimension/security checks | U26–U30 Pending |
| R20 | Evergreen README | root `README.md` | link/content/source review | documentation usability Pending |
| R21 | Required versioned evidence | `docs/testing/v0.6.4/` | release-document/static gates | owner fills report |
| R22 | Preserve old tags/releases | no tag mutation; release audit | Git refs and GitHub inventory | remote audit before/after |
| R23 | Reproducible signed candidate identity | package/checksum/manifest tools | package + prerelease gate | downloaded asset hash Pending |
| R24 | Direct main/tag/prerelease flow | package workflow + explicit release procedure | local/CI gates | GitHub audit at publication |
