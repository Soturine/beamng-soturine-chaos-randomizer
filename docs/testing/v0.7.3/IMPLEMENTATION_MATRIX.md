# v0.7.3 implementation matrix

Status vocabulary: `Automated: Pending/Passed/Failed`; `Live: Pending owner validation/Passed/Failed`.

The historical failures below were observed against v0.7.2 on BeamNG 0.39.2.1. Development targets the locally inspected BeamNG 0.39.4.0 installation. On 2026-08-07, the official 0.39 hotfix index still exposed release notes only through 0.39.3, so no undocumented 0.39.4 behavior is attributed to the engine.

| ID | Severity | Failure / cause | Contract and implementation target | Automated evidence | Live case | State | Resolving commit |
| --- | --- | --- | --- | --- | --- | --- | --- |
| UI-072-01 | P0 | `spawnDirector.managed` map reached code expecting an array | Normalize deterministically at ingress; component remains defensive | state normalization + mounted component | UI-PLACEMENT-01 | Automated: Pending; Live: Pending owner validation | pending |
| UI-072-02 | P0 | Vue render failure escaped the Race subtree | App/tab boundaries preserve shell, navigation, backend, and diagnostic actions | injected render-failure tests | UI-BOUNDARY-01 | Automated: Pending; Live: Pending owner validation | pending |
| UI-072-03 | P1 | Compact content did not alter usable geometry | Per-tab compact/expanded metrics; no private AppHost API | 50-cycle layout tests | UI-COMPACT-01 | Automated: Pending; Live: Pending owner validation | pending |
| UI-072-04 | P1 | Lock UI exposed raw paths and repeated actions | Human categories, grouped manager, technical-ID disclosure | DOM/i18n tests | UI-LOCKS-01 | Automated: Pending; Live: Pending owner validation | pending |
| UI-072-05 | P1 | Race policy exposed internal keys | Translated labels and progressive disclosure | DOM raw-key guard | UI-RACE-01 | Automated: Pending; Live: Pending owner validation | pending |
| UI-072-06 | P1 | Visible strings bypassed i18n | Catalog parity and stable-code presentation | locale/DOM guard | UI-I18N-01 | Automated: Pending; Live: Pending owner validation | pending |
| UI-072-07 | P1 | Old status leaked between tabs | Expiring, scoped, deduplicated status records | fake-clock status tests | UI-STATUS-01 | Automated: Pending; Live: Pending owner validation | pending |
| UI-072-08 | P1 | Garage names were needlessly truncated | Responsive list with tooltip only on real truncation | mounted narrow/wide tests | UI-GARAGE-01 | Automated: Pending; Live: Pending owner validation | pending |
| UI-072-09 | P2 | Settings and Race lacked hierarchy | Quick setup plus advanced disclosure | mounted disclosure tests | UI-DENSITY-01 | Automated: Pending; Live: Pending owner validation | pending |
| UI-072-10 | P2 | Empty screens lacked contextual action | Localized guidance and valid next action | mounted empty-state tests | UI-EMPTY-01 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-01 | P0 | Native HTML selects were unusable | Shared adapter over official 0.39.4 `BngSmartSelect`; no native selects | component interaction suite | UI-SELECT-01 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-02 | P0 | Placement crashed on `.some` | Same contract as UI-072-01 | state/component tests | UI-PLACEMENT-01 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-03 | P0 | One component unmounted the HUD | Same contract as UI-072-02 | boundary tests | UI-BOUNDARY-01 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-04 | P0 | Full Random retained simultaneous clones | One source plus at most one operation-owned temporary; serial replacement | cardinality/fault tests | GAME-FULL-01 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-05 | P0 | Rollback violated in-flight cardinality | Phase snapshots and ownership-scoped serial cleanup | rollback phase invariants | GAME-FULL-02 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-06 | P0 | Scramble lost concrete identity | Same object, zero spawn/replacement, explicit instability failure | pipeline call counters | GAME-SCRAMBLE-01 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-07 | P0 | Transitional reads became critical failures | Ternary, generation-bound evidence with bounded recheck | Safety state/fault tests | GAME-SAFETY-01 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-08 | P0 | Old callbacks changed new operations | Single-use callback/phase tokens with operation, generation, vehicle and slot proof | reordered/duplicate/property tests | GAME-CALLBACK-01 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-09 | P1 | Full Random entered long recovery chains | Cooperative bounded steps and short centralized limits | fake-clock/scheduler tests | PERF-FULL-01 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-10 | P1 | Random Car used excessive work | Dedicated one-candidate pipeline and metrics | no-Full-Random-call tests | GAME-RANDOM-CAR-01 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-11 | P1 | Compact did not change geometry | Same contract as UI-072-03 | layout tests | UI-COMPACT-01 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-12 | P1 | Progress was duplicated, English, inconsistent | Structured phase/overall progress; frontend translation | monotonic/i18n tests | UI-PROGRESS-01 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-13 | P1 | Race counters mixed planned and generated | Planned/spawning/bound/ready/failed counters | state projection tests | UI-RACE-COUNT-01 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-14 | P1 | Old statuses persisted | Same contract as UI-072-07 | status lifecycle tests | UI-STATUS-01 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-15 | P1 | Internal IDs appeared in normal UI | Human labels; diagnostic disclosure only | raw-ID DOM guard | UI-TECH-01 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-16 | P2 | Advanced settings were dense | Same contract as UI-072-09 | disclosure tests | UI-DENSITY-01 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-17 | P0 | Race slots lacked independent vehicles | Exclusive operation and slot ownership | N-slot physical-ID tests | GAME-RACE-01 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-18 | P0 | Candidate was reused across slots | Candidate/accepted ID uniqueness ledger | cross-slot callback tests | GAME-RACE-02 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-19 | P0 | Slot rollback affected the lineup | Slot-filtered cleanup only | slot A/B rollback test | GAME-RACE-03 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-20 | P0 | Race accumulated duplicate candidates | At most one unaccepted temporary per slot and bounded global total | phase cardinality tests | GAME-RACE-04 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-21 | P0 | Cleanup lacked ownership proof | Destructive actions require current operation and slot proof | external-vehicle preservation tests | GAME-CLEANUP-01 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-22 | P0 | Player vehicle entered AI generation | Player is final member only and never Race-owned | player/staging invariant tests | GAME-RACE-05 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-23 | P1 | All slots failed but lineup said finished | `lineup_ready/partial/failed/cancelled` outcomes | aggregate-state tests | GAME-RACE-06 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-24 | P1 | Planned cards implied concrete binding | Stable planned/selecting/spawning/binding states | projection tests | UI-RACE-STATE-01 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-25 | P1 | Overall Race progress regressed | Monotonic aggregate; phase progress remains separate | retry progress tests | UI-PROGRESS-02 | Automated: Pending; Live: Pending owner validation | pending |
| LIVE-072-26 | P1 | Technical English leaked into localized UI | Backend codes and complete catalogs | backend/DOM language guards | UI-I18N-02 | Automated: Pending; Live: Pending owner validation | pending |

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
