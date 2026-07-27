# Soturine's Chaos Randomizer 0.6.2

**Gameplay Lifecycle, Recovery Integrity, Full Feature Audit & UI Polish Hotfix**

This is an **Experimental pre-1.0 prerelease** with best-effort third-party mod support. Automated tests and installed BeamNG 0.38.6 source inspection pass. No final v0.6.2 ZIP was executed in a live BeamNG world in this workspace, so this release does **not** claim interactively validated gameplay fixes.

Download `soturine_chaos_randomizer_0.6.2.zip` from this release's **Assets**, not GitHub's automatic source archive. Verify it with `soturine_chaos_randomizer_0.6.2.sha256`; `release-manifest.json` binds the ZIP to the exact tag commit and evidence counts.

## Fixed in the implementation

- Make vehicle verification coherent for one expected ID instead of mixing player ID, player object and global configuration reads.
- Confirm new-target ownership before mutable parts-tree convergence and keep all parts, tuning, paint, DNA and completion work bound to that target generation.
- Keep monotonic deadlines, Cancel, watchdog, UI publication, stale-work cleanup, recovery and Busy release active while paused or waiting.
- Reject callbacks, timers, mutation batches, tuning and paint plans owned by an old operation/phase/target/recovery generation.
- Separate original, candidate-base, readable, completed-good and recovery snapshot roles; only promote a clean result after final readback, closed ledgers and zero pending work.
- Use six bounded recovery tiers with explicit snapshot selection, recovery generations, candidate/state fingerprints and terminal loop detection.
- Isolate new-operation and retry randomness while retaining deterministic fixed seeds, replay, restore and single-option behavior.
- Ensure Race Cars leave non-terminal states within bounds and expose audited Cars, Placement and Drive/AI controls with capability reasons.
- Remove dead Chaos space, dynamically resize the host, correct percentage fill/thumb endpoints and use a compact symmetric local fox mark.

## Audited

- Chaos: Random Car, Scramble, Full Random, Undo, Cancel, recovery and diagnostics.
- Garage: save, metadata, details, Exact/Compatible restore, replay, mutations, reroll, Compare, JSON/package Share and thumbnails.
- Race: Cars/presets/failure decisions, Placement/managed ownership, destination/route and Drive/AI group controls.
- Settings: General, Safety, Seed, Locks, Advanced, Diagnostics and capability degradation.
- Vehicle, placement and AI adapters; lifecycle hooks; README, architecture, lifecycle, UI, compatibility, testing, roadmap and release workflows.

The [feature audit](../FEATURE_AUDIT_0.6.2.md) maps every exported public entry point to its dependencies, automated evidence, live status, limitation and documentation. Vehicle DNA schema 1, generator 6, `SCR6` seeds, v0.6.0/v0.6.1 saved data and legacy `lineup` storage/API reads remain compatible.

## Root-cause status

The v0.6.1 mixed-view verification defect is **confirmed from source**: its ID, object and parts/configuration reads were not proven to describe one vehicle during replacement/reload. The link from that race to the reported pause-triggered convergence and old-snapshot restoration is **partially confirmed** by source and deterministic fixtures. Whether the v0.6.2 implementation eliminates every observed case in real gameplay is **still unresolved** until live execution.

## Interactive status

v0.6.2: **0 Passed / 0 Failed / 80 Pending / 0 Blocked**. Automated fixtures are not counted as live passes.

The eight actually reproduced v0.6.1 results remain historical **Failed** evidence:

- pause-independent Random Car;
- pause-independent Scramble;
- pause-independent Full Random;
- target ownership after spawn;
- no return to the previous vehicle;
- Busy/stall recovery;
- recovery-loop prevention;
- Full Random complete pipeline (Failed/Partial observation).

See the exact [v0.6.2 plan](../archive/releases/0.6.2/LIVE_TEST_PLAN.md), [v0.6.2 report](../archive/releases/0.6.2/LIVE_TEST_REPORT.md), [requirements matrix](../archive/releases/0.6.2/REQUIREMENTS_MATRIX_0.6.2.md), and preserved [v0.6.1 report](../archive/releases/0.6.1/LIVE_TEST_REPORT.md).

## Known limitations

- External vehicle mods may contain their own Lua errors. The randomizer can detect/degrade/recover within its boundary but cannot repair third-party mods.
- Capability availability varies by map, vehicle and BeamNG build; unavailable/unsupported controls show a reason.
- Safety is metadata evidence, not a physics/drivability guarantee.
- Scripted/Recorded AI playback is unsupported in the audited portable contract; recording commands alone do not enable playback.
- Actual driving, raycast placement, UI scale/rendering, restart/corruption recovery and representative mod compatibility remain Pending.
