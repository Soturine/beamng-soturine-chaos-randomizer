# Interactive Test Plan 0.6.0

This is the live BeamNG evidence plan for the master requirements and the
pause-state lifecycle addendum. No 0.6.0 gameplay/UI run has been performed yet.
Current result: **0 Passed / 0 Failed / 60 Pending / 0 Blocked / 0 Not
applicable**. The corrected delivery policy permits publication with this exact
disclosure; it does not convert any row into a pass.

Only a test executed in BeamNG.drive 0.38.6.0.19963 against the exact candidate
commit may change from Pending. Automated tests, installed-source inspection,
or screenshots from an older version do not count as an interactive pass.

## Evidence record

For every execution record date/time, tester, OS, BeamNG build, mod commit and
ZIP SHA-256, map, vehicle/configuration, content source/version, initial pause
and damage state, settings/seed, phase sequence, final target ID/model/config,
result code, Busy release, relevant diagnostics, and screenshot/log filenames.
Do not attach paid/private content.

Allowed status values are Passed, Failed, Pending, Blocked, and Not applicable.
A failure remains Failed until a new execution on a fixed candidate has its own
evidence.

## Master functional matrix

| ID | Scenario and acceptance evidence | Status | Evidence |
|---|---|---|---|
| M-I001 | Official simple vehicle: Random Car, Scramble, Full Random; semantics and final read-back correct. | Pending | — |
| M-I002 | Official deep tree: more than five levels converge; slot ledger terminal and target unchanged. | Pending | — |
| M-I003 | Adjustable turbo: discovered after parts, changed/read back/classified. | Pending | — |
| M-I004 | Adjustable nitro: generic metadata path, no name allowlist or action execution. | Pending | — |
| M-I005 | Adjustable suspension: dynamic category and localized rejected-value rollback. | Pending | — |
| M-I006 | Adjustable transmission: change/read-back without erasing other categories. | Pending | — |
| M-I007 | Adjustable differential: metadata, bounds, read-back, and ledger correct. | Pending | — |
| M-I008 | Five representative mods: record name/version/source and all three action outcomes. | Pending | — |
| M-I009 | ID-changing mod: returned/callback/player chain stabilizes on the correct target. | Pending | — |
| M-I010 | Auxiliary-vehicle mod: auxiliary never becomes the mutation target; ownership is proven/bounded. | Pending | — |
| M-I011 | Broken `heritage` configuration: bounded failure, recovery-only target, Busy released. | Pending | — |
| M-I012 | Two-competitor Lineup: sequential Full Random, DNA/checkpoints/status, spawn. | Pending | — |
| M-I013 | Four-competitor Lineup: independent seeds, variety, incremental recovery. | Pending | — |
| M-I014 | Eight-competitor Lineup: sequential spawn, managed IDs, stagger and performance. | Pending | — |
| M-I015 | Sixteen-competitor Lineup: bounds, pagination, one concurrent load, best-effort performance. | Pending | — |
| M-I016 | Map with NavGraph: exact/snap preview, reachable route and reasoned AI start. | Pending | — |
| M-I017 | Map/area without route: “No reachable NavGraph route”; no fake path. | Pending | — |
| M-I018 | Destination: multiple managed vehicles reach/finish using radius, speed and timeout evidence. | Pending | — |
| M-I019 | Route A→B→C→D: add/remove/reverse/loop/finish and cleanup. | Pending | — |
| M-I020 | Chase/Follow: real player/managed target; target removal stops with reason. | Pending | — |
| M-I021 | Stagger: vehicles start at configured distinct times, not the same frame. | Pending | — |
| M-I022 | Free camera: place, preview, exact/snap, cancel, clear; no permanent prop. | Pending | — |
| M-I023 | Local and total recovery: prior target restored or honest fallback; Cancel/Busy correct. | Pending | — |
| M-I024 | UI at 100/125/150/200% and 300×340: keyboard/focus/long text/compact director/no overflow. | Pending | — |

## Pause-state lifecycle matrix

Random Car has no parts/tuning/paint stage; its rows for those moments pass only
if those stages are absent and the operation remains cancellable/diagnosable.

| ID | Scenario and acceptance evidence | Status | Evidence |
|---|---|---|---|
| A-I001 | Random Car while running: completes without a pause toggle. | Pending | — |
| A-I002 | Random Car already paused: waits only if simulation is required; no deadlock/rollback. | Pending | — |
| A-I003 | Random Car paused immediately after click: correct ownership and resumable phase. | Pending | — |
| A-I004 | Random Car paused after vehicle appears: target identity remains confirmed. | Pending | — |
| A-I005 | Random Car parts checkpoint: no parts mutation stage is entered. | Pending | — |
| A-I006 | Random Car tuning checkpoint: no tuning stage is entered. | Pending | — |
| A-I007 | Random Car paint checkpoint: no paint stage is entered. | Pending | — |
| A-I008 | Random Car resumed from waiting: resumes exactly the pending load phase. | Pending | — |
| A-I009 | Random Car in slow motion: same seed/project choices and no false timeout. | Pending | — |
| A-I010 | Scramble while running: completes without a pause toggle. | Pending | — |
| A-I011 | Scramble already paused: safe planning proceeds; physics-dependent work waits visibly. | Pending | — |
| A-I012 | Scramble paused immediately after click: current target remains bound. | Pending | — |
| A-I013 | Scramble paused after a reload appears: ID chain remains correctly owned. | Pending | — |
| A-I014 | Scramble paused during parts: tree convergence does not reset target identity. | Pending | — |
| A-I015 | Scramble paused during tuning: no permanent Busy; Cancel/Copy remain available. | Pending | — |
| A-I016 | Scramble paused during paint: no false timeout or stale paint write. | Pending | — |
| A-I017 | Scramble resumed from waiting: no pipeline restart or duplicate write. | Pending | — |
| A-I018 | Scramble in slow motion: deterministic choices and distinct real/simulation clocks. | Pending | — |
| A-I019 | Full Random while running: completes without a pause toggle. | Pending | — |
| A-I020 | Full Random already paused: spawn ownership is retained; waiting is explicit. | Pending | — |
| A-I021 | Full Random paused immediately after click: no mutation can reach the prior car. | Pending | — |
| A-I022 | Full Random paused after new vehicle appears: identity excludes the changing parts tree. | Pending | — |
| A-I023 | Full Random paused during parts: no cross-target write; ledger stays on its generation. | Pending | — |
| A-I024 | Full Random paused during tuning: no Busy deadlock or delayed tuning on recovery. | Pending | — |
| A-I025 | Full Random paused during paint: no false timeout or delayed paint on recovery. | Pending | — |
| A-I026 | Full Random resumed from waiting: only the pending phase resumes. | Pending | — |
| A-I027 | Full Random in slow motion/frame-step: seed stable; no false target switch. | Pending | — |
| A-I028 | Vanilla profile distributed across pause rows; record target/tree/recovery evidence. | Pending | — |
| A-I029 | Simple mod profile distributed across pause rows; record version and source. | Pending | — |
| A-I030 | Mod with controllers: no controller/equipment action is executed as tuning. | Pending | — |
| A-I031 | ID-changing mod: record full ID chain and stale callback count. | Pending | — |
| A-I032 | Large-tree mod: mutable tree converges without reclassifying vehicle identity. | Pending | — |
| A-I033 | Broken configuration: recovery invalidates all old plans and finishes failed-recovered. | Pending | — |
| A-I034 | Original with broken engine: original is not promoted to completed-good automatically. | Pending | — |
| A-I035 | Non-drivable/uncertain vehicle: acceptance stays explicit; no false drivability claim. | Pending | — |
| A-I036 | Regression: bad-engine A → Full Random B appears → pause → resume; B never mutates A, no Busy deadlock, no pause required to progress. | Pending | — |

## Release disclosure

Real BeamNG gameplay validation remains pending.
The pause-state lifecycle correction is statically implemented and covered by
automated simulations, but interactive confirmation is still pending.

The release may be published with 0 Passed / 0 Failed / 60 Pending. Future live
executions must still use the exact artifact identity and evidence fields above.
