# Live test plan — v0.6.7

Use only the downloaded `soturine_chaos_randomizer_0.6.7.zip` after verifying
its `.sha256` and `.manifest.json`. Record every case as Passed, Failed, or
Blocked with evidence; Pending is the initial state.

| ID | Live case | Initial |
|---|---|---|
| L01 | Race configured for eight; Random Car creates no Race entity | Pending |
| L02 | Race configured for eight; Scramble keeps player ID and creates no entity | Pending |
| L03 | Race configured for eight; Full Random creates one player replacement only | Pending |
| L04 | Generate Cars is the only action that creates Race slots/formations | Pending |
| L05 | Random Car repeated 20 times never leaves two accepted player cars | Pending |
| L06 | Scramble repeated 20 times never changes controlled vehicle identity | Pending |
| L07 | Full Random repeated 20 times never leaves source plus accepted duplicate | Pending |
| L08 | Failure before replacement preserves source with no orphan | Pending |
| L09 | Failure after replacement restores exactly one usable vehicle | Pending |
| L10 | Repeated rollback/cancel is idempotent | Pending |
| L11 | Delayed Race spawn callback during Chaos is ignored and owned orphan removed | Pending |
| L12 | Delayed Chaos callback during Race cannot complete a Race slot | Pending |
| L13 | Callback after timeout/cancel/rollback cannot mutate terminal state | Pending |
| L14 | External nearby vehicle is never deleted by orphan cleanup | Pending |
| L15 | Concrete ID rebind survives A→B→C replacement callbacks | Pending |
| L16 | Auxiliary/trailer callback is not mistaken for player target | Pending |
| L17 | Four same-seed Race slots generate independent candidate sequences | Pending |
| L18 | Retry of competitor two does not change competitor three seed/result | Pending |
| L19 | New Race generation removes only prior managed Race vehicles | Pending |
| L20 | Cancel Generation cancels Race only and closes waiting slots | Pending |
| L21 | Player participates: total four means one player plus three AI | Pending |
| L22 | Spectator: total four means four AI and no player requirement | Pending |
| L23 | Spectator can focus/switch among managed competitors | Pending |
| L24 | Left and Right formations place all retained IDs on requested side | Pending |
| L25 | Split formation alternates left/right without overlap | Pending |
| L26 | Single-file ahead/behind respects anchor heading | Pending |
| L27 | Staggered and side-by-side grids preserve order | Pending |
| L28 | Circular formation uses safe radius and ground projection | Pending |
| L29 | Automatic spacing increases for truck/bus bounding boxes | Pending |
| L30 | Narrow map reduces columns and falls back to single file visibly | Pending |
| L31 | Placement Preview moves nothing before Confirm | Pending |
| L32 | Confirm Placement moves existing IDs and creates no duplicate | Pending |
| L33 | Placement failure exposes Retry/Skip/Stop without half-hidden state | Pending |
| L34 | Drive cannot start while formation is nonterminal | Pending |
| L35 | Race policy opens/closes without losing any option | Pending |
| L36 | Balanced, Maximum Chaos, and Mods Showcase changes are visible | Pending |
| L37 | Manual policy edit marks preset Custom | Pending |
| L38 | Export/import preserves participation, policy, formation, and spacing | Pending |
| L39 | Confirmed missing core infrastructure is rejected | Pending |
| L40 | Unavailable oil/fuel probe reports unknown/pending, not invalid | Pending |
| L41 | Proven zero/below-safe combustion oil is rejected | Pending |
| L42 | Invalid configuration quarantine tries another bounded candidate | Pending |
| L43 | Chaos/Garage/Race/Settings compact modes show tab-specific controls | Pending |
| L44 | Compact→expand preserves the same active tab and policy state | Pending |
| L45 | Fifty tab and compact/expand cycles show no growing blank area | Pending |
| L46 | Details open/close 50 times restores original tab height | Pending |
| L47 | Settings→Race→Chaos restores each tab's own size immediately | Pending |
| L48 | Eight-car generation remains responsive with no vehicle accumulation | Pending |
