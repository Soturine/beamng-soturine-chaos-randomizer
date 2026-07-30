# Live test plan — v0.6.8

Use only the downloaded `soturine_chaos_randomizer_0.6.8.zip` after verifying
its `.sha256` and `.manifest.json`. Start each row at Pending. Record Passed,
Failed, or Blocked only after executing the exact steps; attach the required
evidence and never infer a result from automated tests.

## Core BeamNG 0.39 matrix

| ID | Area | Setup and steps | Expected result | Required evidence | Result |
|---|---|---|---|---|---|
| L01 | Version | Clean 0.39 profile; add HUD; open diagnostics | Detected version, primary 0.39, minimum 0.38.6, `primary_target`, no false tested-build claim | Full build, state JSON, screenshot | Pending |
| L02 | Version warning | Run exact ZIP on an available non-primary supported/newer build | Honest `supported_legacy` or `newer_unverified` warning; actions remain capability-gated | Build and warning screenshot/log | Pending |
| L03 | Registry cold start | Launch, open HUD immediately, request state repeatedly | States progress warming/partial/ready without false empty terminal index | Timestamped state/log series | Pending |
| L04 | Registry cache | Reach ready; trigger reindex while registry is busy/warming | Prior model/config counts remain usable until a complete replacement exists | Before/during/after counts | Pending |
| L05 | Registry mod enable | Enable a vehicle mod in-session | Cache marked stale, bounded retry occurs, new complete index appears | Mod/version and state series | Pending |
| L06 | Registry mod disable | Disable the same mod during idle | Removed content disappears only after ready snapshot; temporary read does not erase all | Counts and selected keys | Pending |
| L07 | Registry operation | Start Random Car during registry warm-up and after ready | No infinite Busy; bounded warming result or safe cached selection, then normal ready action | Phase clocks and terminal result | Pending |
| L08 | Official subgroups | Inspect Cherrier Vivace/Tograc configurations | Registry model/config/path identities remain distinct from subgroup/display labels | Diagnostics for two configs | Pending |
| L09 | Official subgroups | Inspect T-Series/TC-Series configurations | No display-name/basename substitution or ambiguous silent selection | Keys, paths, displayed labels | Pending |
| L10 | Official subgroups | Inspect Wentward Bus subgroup configurations | Family/group presentation does not alter technical selection or DNA identity | Two DNA exports and state | Pending |
| L11 | Config names | Create/load a custom config whose `info.json` name differs from `.pc` filename | Exact filename/path wins technically; display name remains presentation-only | File names, HUD, DNA base | Pending |
| L12 | Ambiguity | Install two configs with equal display labels/signature-like state | Ambiguity is visible or scoped by registry/path; no silent cross-model match | Registry dump and result | Pending |
| L13 | Case path | Install a mixed-case unpacked config/mod and run reindex/load | Physical path preserves case and loads; comparison remains case-insensitive only internally | On-disk path, log, state | Pending |
| L14 | Path safety | Attempt bounded import/reference containing `..`, URI, drive or UNC path | Rejected before filesystem access; no external file read/write | Submitted value and error/log | Pending |
| L15 | Random Car cardinality | Record world IDs; run Random Car 20 times | Each terminal success has exactly one accepted player result; no owned orphan remains | Before/after IDs each run | Pending |
| L16 | Scramble cardinality | Run Scramble 20 times on one official car | Controlled identity is retained; no new world vehicle created | IDs and terminal summaries | Pending |
| L17 | Full Random cardinality | Run Full Random 20 times | Source/result cleanup leaves one accepted player car; Race/external cars untouched | World ID ledger | Pending |
| L18 | Callback order | Induce rapid replace/switch/spawn callbacks | Callback order is advisory; stable readback accepts one correct candidate | Callback log and transaction | Pending |
| L19 | Multiple candidates | Reproduce/induce two candidates in one transaction | Transaction rejects ambiguous cardinality and removes only its unaccepted created IDs | World snapshots and cleanup | Pending |
| L20 | External safety | Park external/Race vehicles nearby; cancel/timeout replacement | External/accepted vehicles remain; only proven owned orphan can be deleted | Ownership and ID ledger | Pending |
| L21 | Low memory | Under controlled low-memory warning, request Random Car/Race spawn | Immediate `DENIED_LOW_MEMORY`, no retry loop, no blacklist, no half-created slot | Memory warning, result, quarantine | Pending |
| L22 | No safe position | Attempt Race spawn in a deliberately obstructed/invalid placement area | No false low-memory/invalid-content label; bounded unknown/no-space evidence and no orphan | Placement, result, IDs | Pending |
| L23 | Spawn slot race | Start/cancel Race spawn rapidly while another slot is pending | Slot becomes terminal once; delayed candidate is ignored/reaped if owned | Slot lifecycle and IDs | Pending |
| L24 | Instability cause | Use content that produces an explicit 0.39 instability removal cause | Cause correlates to current operation/ID and becomes `INSTABILITY_CONFIRMED`; one recovery path | Game cause/log, generations | Pending |
| L25 | Unknown removal | Delete current candidate manually without explicit instability cause | `UNKNOWN_FAILURE`, not invalid content; no persistent blacklist; bounded recovery | Destroy event and quarantine | Pending |
| L26 | Stale removal | Deliver/observe late destroy after cancel/rollback/new generation | Stale event cannot mutate new state or trigger second recovery | Generation log and terminal state | Pending |
| L27 | Invalid config quarantine | Use a reproducibly invalid config and repeat selection | Confirmed invalid content is skipped/quarantined within policy and another bounded candidate is tried | Config key, reason, counts | Pending |
| L28 | Manual retry | Fix/disable cause, use Retry quarantined, then reindex | Temporary/domain quarantine clears explicitly; persistent false penalty does not survive | Before/after quarantine | Pending |
| L29 | Combustion safety | Randomize official combustion cars including engine reset/reload | Ternary result uses coherent parts/powertrain/fuel/fluid evidence; no zero oil/fuel success | Safety report and vehicle state | Pending |
| L30 | Multi-tank | Test a vehicle with two or more combustion tanks | Every correlated tank has independent 10% floor/readback; unresolved tank is Pending warning | Storage/tuning readback | Pending |
| L31 | Hybrid | Test hybrid with fuel tank plus electric battery | Fuel floor applies only to combustion tank; battery is not classified as fuel | Storage classifications | Pending |
| L32 | N2O/air/hydraulic | Test N2O bottle, pressure tank and hydraulic storage | None is clamped or counted as combustion fuel | Before/after storage data | Pending |
| L33 | EV/trailer/prop | Opt in and run applicable actions | No invented combustion oil/fuel requirement; honest not-applicable/degraded result | Classification and terminal result | Pending |
| L34 | Core versus optional | Remove optional part, then a confirmed core dependency | Optional absence remains allowed/uncertain; confirmed core loss is invalid and recovers once | Part tree and safety reasons | Pending |
| L35 | AI lane on/off | Start supported AI modes with Drive in lane on, then off | Command/state explicitly carries `on`/`off`; result is not inherited from 0.39 default | Vehicle-Lua/diagnostic commands | Pending |
| L36 | AI start failure | Remove target/NavGraph or make initial queue fail | AI entry becomes `failed`, has `lastAttemptAt`, and has no false `startedAt`/running state | AI state and reason | Pending |
| L37 | HUD host | Add/remove/re-add legacy Angular HUD through 0.39 Runtime UI manager | App mounts each time, keeps bridge contract, and leaves no duplicate listeners | UI video and console | Pending |
| L38 | HUD resize cycles | Cycle four tabs and compact/expanded 50 times | Active tab/state retained; no growing blank area or cumulative height drift | Video plus first/final sizes | Pending |
| L39 | HUD Details cycles | Open/close Details 50 times per tab | Each tab returns to its own base/user height | Size ledger/screenshots | Pending |
| L40 | HUD user resize | Manually resize each tab, switch/remount, compact/expand | Per-tab user/automatic size policy remains stable and bounded | Four size records | Pending |
| L41 | HUD teardown | Remove HUD while delayed requests/resize/content mutation are pending | Timers and observers stop; no post-destroy exception or duplicate request on re-add | UI console/log | Pending |
| L42 | Translation selection | Switch language; repeat fixed-seed Random Car on unchanged registry | Technical choice/seed/DNA IDs stay the same; only presentation labels change | Two languages, keys, DNA | Pending |
| L43 | Translation locks | Save locks/DNA in one language; restore/use in another | Locks and exact/compatible matching bind internal keys, not translated text | Lock profile and result | Pending |
| L44 | Translation Race | Export lineup in one language; import/generate in another | Race policies/seeds/competitor technical identities remain stable | Lineup JSON and IDs | Pending |
| L45 | Settings migration | Start with real v0.6.7 settings fixture/profile; launch 0.6.8 | Schema becomes 7, user values preserved, last-known-good backup/readback/report exist | Before/after/backups/report | Pending |
| L46 | DNA preservation | Start with v0.6.7 DNA library and thumbnails | Entries, lineage, metadata and files remain; no empty overwrite | Counts/fingerprints/files | Pending |
| L47 | Lineup preservation | Start with v0.6.7 lineup library | Entries/policy/participation remain; backup/readback recorded | Before/after JSON/report | Pending |
| L48 | Migration failure | Make settings/lineup target temporarily unwritable or force mismatch | Candidate fails, prior data is restored/read back or write fails closed; no empty library | Permissions/error and exact bytes | Pending |
| L49 | BeamLR coexistence | Enable current BeamLR with 0.6.8; open diagnostics/run bounded action | Structured warning only; BeamLR is not disabled; Randomizer terminal state remains honest | Versions, conflict record, logs | Pending |
| L50 | Driver Assistance | Enable Driver Assistance (angelo234); repeat | Structured warning only with extension/path evidence and recommendation; nothing disabled | Versions and conflict record | Pending |
| L51 | Other randomizer | Enable another vehicle-randomizer mod | Generic conflict warning is visible; no automatic disable or destructive cross-cleanup | Mod/version, warning, IDs | Pending |
| L52 | Multiplayer sync | Enable BeamMP/KissMP-equivalent sync in safe offline/test context | Sync conflict warning only; unsupported/coexistence limitations explicit | Plugin/mod version and warning | Pending |
| L53 | Package install | Fresh user folder; install only downloaded ZIP | HUD appears, 0.6.8 shown, central metadata readable, no wrapper/source files | ZIP hash, root listing, screenshot | Pending |
| L54 | Performance bound | Idle HUD, reindex, 20 Chaos actions, eight-car Race | No unbounded log/listener/vehicle growth; telemetry windows and UI remain responsive | Timings, memory, IDs, telemetry | Pending |

## Explicitly required mod/content coverage

| ID | Area | Setup and steps | Expected result | Required evidence | Result |
|---|---|---|---|---|---|
| L55 | Config pack | Use a maintained config pack with renamed labels/mixed-case files; fixed-seed Random Car | Technical path/key selects correctly; source ownership is mod/user as evidenced | Exact pack/version/path and DNA | Pending |
| L56 | Full vehicle mod | Use a maintained full vehicle mod with non-stock config structure | Registry, spawn, readback, safety and cleanup reach honest terminal state | Mod/version, key/path, log | Pending |
| L57 | Part/wheel pack | Use maintained part and wheel packs in Full Random | Dynamic slots are discovered; optional/unknown metadata degrades honestly; no unrelated blacklist | Mods/versions, tree diff | Pending |
| L58 | Automation export | Opt in to a current Automation vehicle and run Random Car/Full Random | Automation classification is explicit; unsupported stages skip safely; no false drivability claim | Export/build and result | Pending |

## Other representative mods

| ID | Area | Setup and steps | Expected result | Required evidence | Result |
|---|---|---|---|---|---|
| L59 | Complex powertrain mod | Use a mod with hybrid/dual-motor/multi-storage or forced induction/N2O | Ternary safety and reset/readback remain bounded; uncertain metadata stays warning | Mod/version and safety evidence | Pending |
| L60 | Large mixed mod set | Enable at least ten unrelated vehicle/config/part mods; reindex and run fixed seeds/Race | Registry reaches ready within budget, seeds use technical IDs, failures isolate, HUD remains responsive | Complete mod list, counts, telemetry | Pending |

Totals at publication: 0 executed / 0 passed / 0 failed / 60 pending / 0 blocked.
