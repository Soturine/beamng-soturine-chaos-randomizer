# Replay and Restore Semantics

These actions are intentionally different.

| Action | Saved base model/config | Saved final snapshot | Selection rerun | Locks |
| --- | --- | --- | --- | --- |
| Restore Snapshot / Exact | Auto-loaded | Applied and strictly verified | No | Ignored |
| Restore Compatible | Auto-loaded | Applied with explicit remap/omit/clamp deviations | No | Ignored |
| Replay Generation | Auto-loaded and frozen | Used only for final comparison | No | Explicit original/current policy |
| Pure Seed Replay | May be reselected by the original operation | Not applied | Yes | Normal operation settings |

Replay Generation always begins with the saved model and normalized base configuration, even when another model is active. After the actual target spawns it reruns target-specific preflight, then repeats the saved generator version's parts/tuning/paint stages. It reports `exact`, `close`, or `partial`; equality uses full normalized fields plus fingerprints, never fingerprints alone.

`original` lock policy uses the saved profile. `current` uses the current Locks tab; preserved current locks are explicit deviations and can make replay partial. The UI never chooses this policy implicitly.

Pure Seed Replay is an advanced, warned action. It invokes the original Random Config/Scramble/Full Random selection path with the saved seed, so recent content, available mods, game version, or generator behavior can change the result. It is not a snapshot-restore promise.

All destructive variants share the operation token, correlated target ID, one history transaction, timeout, cancellation, safety validation, final read-back, and rollback rules. Missing saved model/configuration blocks before unsafe substitution; a partial Compatible result requires authorization.
