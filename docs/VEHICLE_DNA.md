# Vehicle DNA

Vehicle DNA is a portable, bounded description of a completed Chaos Randomizer result. It stores normalized metadata needed to explain, compare, and attempt restoration; it does not contain mod files or prove that two installations have identical content bytes.

## Creation contract

An entry can become available only after an operation completes its lifecycle confirmation, final safety validation where applicable, a fresh configuration capture, a fresh hierarchical slot scan, normalization, schema validation, and fingerprint generation. The UI then offers **Save Vehicle DNA**. Saving is never automatic.

Random Car results are eligible after their configuration lifecycle/read-back confirmation. The stored operation value remains `randomConfig` for backward compatibility. Scramble and Full Random results additionally pass the final safety scan. A failed capture leaves the gameplay operation result intact but disables saving and records a diagnostic reason.

## Four distinct operations

### Restore Exact

Exact mode first performs a read-only registry preflight. If a different model is active, the report is `target_inspection_required`; after explicit restore initiation, the same transaction captures history, loads the saved normalized/model-scoped base configuration, and performs the target-tree preflight. Model, base configuration, slot topology, selected parts, tuning ranges, paint-layer count, and known environment evidence must then be available and unambiguous. Resolution order is:

1. exact path + slot ID + parent part;
2. exact path + slot ID;
3. unique slot ID + parent part + model;
4. incompatible when missing or ambiguous.

Exact mode never uses RNG, recent selections, session blacklists, suspect state, a random compatible part, current/default fallback, or omission. It restores the base, then applies only the shallowest changed slot depth per pass, waits for the phase-specific reload, reads a fresh tree, and continues. The pass budget is derived from saved/current depth and clamped to 12–128, with a 120-second deadline and no-progress/repeated-state guards. Tuning and paint values use their saved values. A final strict read-back must match every saved slot/tuning/paint field and slot/paint topology; otherwise the transaction rolls back. Results are `exact` or `failed`—never “exact enough.”

### Restore Compatible

Compatible mode uses the same two-stage preflight and resolution order. It may preserve an empty optional slot, omit a missing optional part, remap a uniquely proven slot, clamp a tuning value to a current range, or omit unsupported paint layers only when the report records the deviation and the user explicitly confirms a partial restore. A partial discovered only after loading the target also requires that prior authorization or the transaction rolls back. Required/core parts are never omitted. It never chooses a random fallback. The final read-back verifies every subset value actually applied and safety validation runs before completion. Final status is `compatible`, `partial`, or `failed`.

### Replay Generation

Replay Generation freezes the saved base model and normalized configuration, restores that base, and replays only the saved parts/tuning/paint generation stages using the recorded generator version, root seed, and settings. `randomConfig` DNA therefore validates its saved base and does not select another vehicle. The explicit `original` lock policy uses the saved generation profile; `current` uses current settings and records preserved decisions as partial deviations. The result is Exact, Close, or Partial according to field read-back and deviations; fingerprints are advisory and never replace comparison.

### Pure Seed Replay

Pure Seed Replay is a separate advanced operation that reruns the original top-level generator action, including model/configuration selection. It can differ if BeamNG, enabled content, algorithms, filters, or other environment inputs changed. New work uses generator 5 and `SCR5-XXXX-XXXX`. Generator-4 `SCR4-...`/legacy text keeps its recorded version and is not silently replayed through generator 5; snapshot restore remains supported without RNG replay.

## Persistence

The installed 0.38.6 source exposes `jsonReadFile` and `jsonWriteFile`; the latter supports a temp-write plus `FS:renameFile` mode. The library uses one bounded store:

```text
/settings/soturineChaosRandomizer/vehicleDNA/library.json
```

Before replacing an existing primary, the adapter writes:

```text
/settings/soturineChaosRandomizer/vehicleDNA/library.last-known-good.json
```

Every logical save validates the complete candidate library, writes it through the observed temp/rename helper, reads it back, and compares it. Startup uses the primary, then last-known-good, then an empty library. This is a recovery strategy, not a claim of transactional or crash-proof filesystem atomicity.

Limits are 100 entries, 128 KiB canonical data per entry, 1 MiB for the library, 2,048 slots, 2,048 tuning variables, 32 paint layers, 20 tags, 32 nested levels, 10,000 imported elements, and 4,096 characters per string. The UI reports entry, byte, element, and largest-entry usage. The restore parts pipeline has a depth-derived bounded budget rather than a fixed pass count.

## Locks, mutations, and Garage metadata

Vehicle DNA can retain the lock profile used during generation without changing its final snapshot. Restore ignores creative locks. Reroll Unlocked and mutations use current locks, but first restore and verify the saved parent's actual final model/configuration/slots/tuning/paints. Model-dependent locks carry their bound model/configuration and cannot be silently applied elsewhere. Deterministic Small/Medium/Wild children preserve parent/root/index/strength/seed lineage and never edit the saved parent. Garage metadata adds optional pins, ratings, tags, notes, collections, sort order, and managed thumbnail metadata without changing schema version 1.

## Import and export

`.vdna.json` uses a versioned share envelope and one controlled export filename. `.vdna.zip` uses a fixed export/inbox, five-entry allowlist, CRC/SHA manifest, strict schema identity, optional bounded managed PNG, and preview/confirmation before persistence. An entry ID or name never chooses a path. Pasted text is capped and parsed with `JSON.parse` into a data object before BeamNG bridge serialization. Lua discards unknown top-level fields except the bounded `extensions` object, rejects non-JSON types, cycles, non-finite numbers, oversized/deep structures, invalid schema, and duplicate paths/names.

No import value becomes Lua or JavaScript source, selects a method name, accesses the network, or chooses a filesystem path. Exporter compatibility is retained only as bounded metadata; the receiver recomputes `localCompatibility` from its own mounted registry and reports local missing mods/configuration/parts.

See [Locks](LOCKS.md), [Mutations](MUTATIONS.md), [Gallery](GALLERY.md), [Sharing](SHARING.md), and [Replay Semantics](REPLAY_SEMANTICS.md).

## Fingerprints

Canonical serialization sorts object keys, preserves array order, normalizes finite numbers, escapes strings, and rejects cycles, unsupported types, excessive depth/elements/path length/string length. Settings, environment, base identity, final state, dependencies, and starting state have separate fingerprints. Stored field fingerprints are recalculated during schema validation. These fingerprints are deterministic change detectors—not cryptographic signatures, mod hashes, compatibility proof, or a replacement for field-by-field Exact verification.
