# 0.5.0-alpha.2 — Mod Vehicle Lifecycle, Creative Integrity & Compact UI Hotfix

This prerelease fixes the lifecycle and recovery defects observed by the maintainer on alpha.1 while retaining an honest alpha support boundary.

## Highlights

- The visible **Random Config** action is now **Random Car**. It still uses the internal `randomConfig` operation and does not mutate parts, tuning, or paint after spawn.
- Full Random now succeeds only after the selected target stabilizes and the post-spawn Scramble/tuning/paint/final-read-back pipeline finishes. Spawn-only success is gone.
- Replacement and reload tracking tolerates bounded multi-ID mod lifecycles, delayed read-back, auxiliary vehicles, trailers, props, and destroyed intermediates while still cancelling a real manual switch.
- Scramble rescans transient/deep trees and can roll back only an incompatible part batch, quarantine the candidate, try an alternative, and continue.
- A broken configuration no longer leaves the app permanently unusable: recovery tries the previous snapshot, last-known-good target, and safe official fallback, then always cleans state.
- Reroll Unlocked and Small/Medium/Wild mutations restore and verify the parent's actual final state before creating an immutable child. Model-bound locks cannot silently float to another model.
- Import preserves exporter compatibility as metadata and recomputes local compatibility. Exact thumbnails verify complete state; all PNGs receive bounded structural and CRC validation.
- The UI defaults to 330×430, supports collapsed/compact/standard/expanded modes, moves Reroll into Advanced, hides irrelevant mutation controls, and adds recovery/diagnostic actions. The UI App icon is a sharper 250×120 orange/black randomizer mark.

## Backward compatibility

Vehicle DNA remains schema version 1. The internal operation enum remains `randomConfig`, `scramble`, and `fullRandom`, so old randomConfig entries remain valid. New deterministic work uses generator version 5 and `SCR5-...` seeds because selection/retry/mutation substreams changed. Generator-4 snapshots remain restorable and old seed text is parsed as its old version; it is never silently treated as generator 5. Replay that requires unavailable generator-4 behavior reports the limitation instead of claiming a new sequence is equivalent.

## Validation status

The automated suite registers all 113 requested regressions in addition to the existing coverage. Installed BeamNG `0.38.6.0.19963` source was reaudited. The 50-case alpha.2 interactive plan is currently **0 Passed / 0 Failed / 50 Pending**.

The alpha.1 maintainer observations—104 enabled mods, 212 vehicles, 5,681 configurations and external screenshots—motivated these fixes, but are not alpha.2 passes. No alpha.2 third-party mod vehicle testing is claimed.

## Known limitations

- Third-party mod support is best-effort because vehicle lifecycles, controllers, slot trees, and metadata are mod-defined.
- Safety is metadata-based and cannot prove generic drivability.
- Recovery and retries are intentionally bounded; a fully broken previous/last-known-good/official ladder can still fail, but the UI should remain usable.
- The project controls UI App metadata. The installed source did not establish a safe public contract for overriding every outer Mod Manager description field, so no speculative `mod_info` file is shipped.
- Undo, lifecycle quarantine, and the load-failure circuit breaker are session state.
- No beta, release candidate, stable release, `1.0`, or BeamNG Repository submission is part of this release.

See [Mod Vehicle Lifecycle](../MOD_VEHICLE_LIFECYCLE.md), [alpha.1 maintainer observations](../INTERACTIVE_TEST_REPORT_0.5.0-alpha.1.md), and [the alpha.2 interactive plan](../INTERACTIVE_TEST_PLAN_0.5.0-alpha.2.md).
