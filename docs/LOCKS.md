# Vehicle DNA Locks

Locks define which dimensions creative operations must preserve. They are settings schema 4 data, persist independently of the Garage, and are normalized on every load and write.

## Lock types

- **Vehicle** keeps the current model. **Configuration** keeps the loaded base configuration.
- **Category** uses evidence from slot ID, description, path, and allow/deny types. Known categories include body, engine, transmission, drivetrain, suspension, brakes, steering, wheels, tires, aero, interior, electronics, accessories, props, tuning, and paint. Unclassified evidence stays `other`.
- **Slot** preserves a stable hierarchical path. **Part** additionally records the current part and parent evidence; a missing or changed path is reported as unresolved, never silently substituted.
- **Tuning** can preserve all variables or named variables. **Paint** can preserve all paint, a layer, or one of the five supported fields.

Profiles are capped at 2,048 slot/part locks, 2,048 tuning locks, and 32 paint layers. Imported paths cannot contain traversal. Four quick presets only adjust categories: Everything unlocks all categories; Visual, Mechanical, and Accessories lock the categories outside their named creative set.

## Operation semantics

| Operation | Lock source | Result |
| --- | --- | --- |
| Restore Snapshot | none | Locks are ignored; the saved final snapshot is authoritative. |
| Replay Generation | explicit `original` or `current` | Saved locks reproduce the original policy. Current locks can cause recorded `replay_current_lock_preserved` deviations and a partial replay. |
| Reroll Unlocked | current settings | Only unlocked dimensions may change. An all-locked no-op is valid and still produces pending DNA. |
| Mutate | current settings | The saved base is loaded, then the deterministic child mutation respects current locks. |

Part, tuning, and paint randomizers use independent derived substreams for creative operations. Adding an unrelated lock therefore does not shift the random choices of an unlocked category. Restore remains separate from this creative policy.

## Public API

`getVehicleDNALocks`, `updateLockProfile`, `lockVehicle`, `lockConfiguration`, `lockCategory`, `lockSlot`, `unlockSlot`, `lockPart`, `lockCurrentParts`, `lockTuning`, `lockPaint`, and `applyLockPreset` validate their inputs. The UI bridge exposes these through a fixed allowlist; a user string never becomes a method name.
