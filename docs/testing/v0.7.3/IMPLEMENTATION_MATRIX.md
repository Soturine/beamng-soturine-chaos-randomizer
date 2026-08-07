# v0.7.3 implementation matrix

Status vocabulary: `Automated: Pending/Passed/Failed`; `Live: Pending owner validation/Passed/Failed`.

The historical failures below were observed against v0.7.2 on BeamNG 0.39.2.1. Development targets the locally inspected BeamNG 0.39.4.0 installation. On 2026-08-07, the official 0.39 hotfix index still exposed release notes only through 0.39.3, so no undocumented 0.39.4 behavior is attributed to the engine.

| ID | Severity | Failure / cause | Contract and implementation target | Automated evidence | Live case | State | Resolving commit |
| --- | --- | --- | --- | --- | --- | --- | --- |
| UI-072-01 | P0 | `spawnDirector.managed` map reached code expecting an array | Normalize deterministically at ingress; component remains defensive | state normalization + mounted component | LIVE-UI-01 | Automated: Passed; Live: Pending owner validation | 65d0863 |
| UI-072-02 | P0 | Vue render failure escaped the Race subtree | App/tab boundaries preserve shell, navigation, backend, and diagnostic actions | injected render-failure tests | LIVE-UI-19 | Automated: Passed; Live: Pending owner validation | ab1c669 |
| UI-072-03 | P1 | Compact content did not alter usable geometry | Per-tab compact/expanded metrics; no private AppHost API | 50-cycle layout tests | LIVE-UI-17 | Automated: Passed; Live: Pending owner validation | ab1c669 |
| UI-072-04 | P1 | Lock UI exposed raw paths and repeated actions | Human categories, grouped manager, technical-ID disclosure | DOM/i18n tests | LIVE-UI-20 | Automated: Passed; Live: Pending owner validation | ab1c669 |
| UI-072-05 | P1 | Race policy exposed internal keys | Translated labels and progressive disclosure | DOM raw-key guard | LIVE-GAME-04 | Automated: Passed; Live: Pending owner validation | ab1c669 |
| UI-072-06 | P1 | Visible strings bypassed i18n | Catalog parity and stable-code presentation | locale/DOM guard | LIVE-LANG-01 | Automated: Passed; Live: Pending owner validation | ab1c669 |
| UI-072-07 | P1 | Old status leaked between tabs | Expiring, scoped, deduplicated status records | fake-clock status tests | LIVE-UI-20 | Automated: Passed; Live: Pending owner validation | ab1c669 |
| UI-072-08 | P1 | Garage names were needlessly truncated | Responsive list with tooltip only on real truncation | mounted narrow/wide tests | LIVE-UI-05 | Automated: Passed; Live: Pending owner validation | ab1c669 |
| UI-072-09 | P2 | Settings and Race lacked hierarchy | Quick setup plus advanced disclosure | mounted disclosure tests | LIVE-UI-17 | Automated: Passed; Live: Pending owner validation | ab1c669 |
| UI-072-10 | P2 | Empty screens lacked contextual action | Localized guidance and valid next action | mounted empty-state tests | LIVE-UI-01 | Automated: Passed; Live: Pending owner validation | ab1c669 |
| LIVE-072-01 | P0 | Native HTML selects were unusable | Shared adapter over official 0.39.4 `BngSmartSelect`; no native selects | component interaction suite | LIVE-UI-12 | Automated: Passed; Live: Pending owner validation | 65d0863 |
| LIVE-072-02 | P0 | Placement crashed on `.some` | Same contract as UI-072-01 | state/component tests | LIVE-GAME-04 | Automated: Passed; Live: Pending owner validation | 65d0863 |
| LIVE-072-03 | P0 | One component unmounted the HUD | Same contract as UI-072-02 | boundary tests | LIVE-UI-19 | Automated: Passed; Live: Pending owner validation | ab1c669 |
| LIVE-072-04 | P0 | Full Random retained simultaneous clones | One source plus at most one operation-owned temporary; serial replacement | cardinality/fault tests | LIVE-GAME-03 | Automated: Passed; Live: Pending owner validation | 16b1a36 |
| LIVE-072-05 | P0 | Rollback violated in-flight cardinality | Phase snapshots and ownership-scoped serial cleanup | rollback phase invariants | LIVE-GAME-03 | Automated: Passed; Live: Pending owner validation | 16b1a36 |
| LIVE-072-06 | P0 | Scramble lost concrete identity | Same object, zero spawn/replacement, explicit instability failure | pipeline call counters | LIVE-GAME-02 | Automated: Passed; Live: Pending owner validation | 16b1a36 |
| LIVE-072-07 | P0 | Transitional reads became critical failures | Ternary, generation-bound evidence with bounded recheck | Safety state/fault tests | LIVE-GAME-13 | Automated: Passed; Live: Pending owner validation | 81ed1b5 |
| LIVE-072-08 | P0 | Old callbacks changed new operations | Single-use callback/phase tokens with operation, generation, vehicle and slot proof | reordered/duplicate/property tests | LIVE-GAME-11 | Automated: Passed; Live: Pending owner validation | 16b1a36 |
| LIVE-072-09 | P1 | Full Random entered long recovery chains | Cooperative bounded steps and short centralized limits | fake-clock/scheduler tests | LIVE-PERF-02 | Automated: Passed; Live: Pending owner validation | 16b1a36 |
| LIVE-072-10 | P1 | Random Car used excessive work | Dedicated one-candidate pipeline and metrics | no-Full-Random-call tests | LIVE-GAME-01 | Automated: Passed; Live: Pending owner validation | 16b1a36 |
| LIVE-072-11 | P1 | Compact did not change geometry | Same contract as UI-072-03 | layout tests | LIVE-UI-17 | Automated: Passed; Live: Pending owner validation | ab1c669 |
| LIVE-072-12 | P1 | Progress was duplicated, English, inconsistent | Structured phase/overall progress; frontend translation | monotonic/i18n tests | LIVE-UI-20 | Automated: Passed; Live: Pending owner validation | ab1c669 |
| LIVE-072-13 | P1 | Race counters mixed planned and generated | Planned/spawning/bound/ready/failed counters | state projection tests | LIVE-GAME-04 | Automated: Passed; Live: Pending owner validation | ab1c669 |
| LIVE-072-14 | P1 | Old statuses persisted | Same contract as UI-072-07 | status lifecycle tests | LIVE-UI-20 | Automated: Passed; Live: Pending owner validation | ab1c669 |
| LIVE-072-15 | P1 | Internal IDs appeared in normal UI | Human labels; diagnostic disclosure only | raw-ID DOM guard | LIVE-UI-20 | Automated: Passed; Live: Pending owner validation | ab1c669 |
| LIVE-072-16 | P2 | Advanced settings were dense | Same contract as UI-072-09 | disclosure tests | LIVE-UI-17 | Automated: Passed; Live: Pending owner validation | ab1c669 |
| LIVE-072-17 | P0 | Race slots lacked independent vehicles | Exclusive operation and slot ownership | N-slot physical-ID tests | LIVE-GAME-04 | Automated: Passed; Live: Pending owner validation | 5055306 |
| LIVE-072-18 | P0 | Candidate was reused across slots | Candidate/accepted ID uniqueness ledger | cross-slot callback tests | LIVE-GAME-04 | Automated: Passed; Live: Pending owner validation | 5055306 |
| LIVE-072-19 | P0 | Slot rollback affected the lineup | Slot-filtered cleanup only | slot A/B rollback test | LIVE-GAME-04 | Automated: Passed; Live: Pending owner validation | 16b1a36 |
| LIVE-072-20 | P0 | Race accumulated duplicate candidates | At most one unaccepted temporary per slot and bounded global total | phase cardinality tests | LIVE-GAME-04 | Automated: Passed; Live: Pending owner validation | 16b1a36 |
| LIVE-072-21 | P0 | Cleanup lacked ownership proof | Destructive actions require current operation and slot proof | external-vehicle preservation tests | LIVE-GAME-11 | Automated: Passed; Live: Pending owner validation | 16b1a36 |
| LIVE-072-22 | P0 | Player vehicle entered AI generation | Player is final member only and never Race-owned | player/staging invariant tests | LIVE-GAME-04 | Automated: Passed; Live: Pending owner validation | 5055306 |
| LIVE-072-23 | P1 | All slots failed but lineup said finished | `lineup_ready/partial/failed/cancelled` outcomes | aggregate-state tests | LIVE-GAME-04 | Automated: Passed; Live: Pending owner validation | 5055306 |
| LIVE-072-24 | P1 | Planned cards implied concrete binding | Stable planned/selecting/spawning/binding states | projection tests | LIVE-GAME-04 | Automated: Passed; Live: Pending owner validation | 5055306 |
| LIVE-072-25 | P1 | Overall Race progress regressed | Monotonic aggregate; phase progress remains separate | retry progress tests | LIVE-GAME-04 | Automated: Passed; Live: Pending owner validation | 5055306 |
| LIVE-072-26 | P1 | Technical English leaked into localized UI | Backend codes and complete catalogs | backend/DOM language guards | LIVE-LANG-01 | Automated: Passed; Live: Pending owner validation | ab1c669 |

## BeamNG 0.39.4 compatibility review

| Area | Evidence inspected | Impact |
| --- | --- | --- |
| Version | Local `integrity.json` reports `0.39.4.0` | Current development/runtime target |
| Public notes | Official hotfix/index pages list 0.39.1–0.39.3 only on 2026-08-07 | `0.39.4 changelog not yet publicly documented at implementation time` |
| Selects | Installed `bngSmartSelect.vue` and demo | Supported adapter target; native HTML select rejected |
| UINav | Installed `BngSmartSelect`, `BngSelect`, dropdown and scoped-nav source | Use official navigation; no global controller-release workaround |
| HUD metrics | Installed placement resolver writes scalable `em` sizes; AppHost exposes no child resize API | Use official scalable placement and responsive content; document outer-frame limitation |
| Safe zones | Root UI exposes `--safezone`; AppHost remains layout-owned | Test scale/alignment/safe-zone live, no private calls |
| AI lane policy | 0.39.3 public notes preserve `driveInLane` after traffic mode | Send only on explicit AI transition, not every frame |
