# Vehicle DNA

Vehicle DNA is a portable, bounded description of a completed Chaos Randomizer result. It stores normalized metadata needed to explain, compare, and attempt restoration; it does not contain mod files or prove that two installations have identical content bytes.

## Creation contract

An entry can become available only after an operation completes its lifecycle confirmation, final safety validation where applicable, a fresh configuration capture, a fresh hierarchical slot scan, normalization, schema validation, and fingerprint generation. The UI then offers **Save Vehicle DNA**. Saving is never automatic.

Random Config results are eligible after their configuration lifecycle/read-back confirmation. Scramble and Full Random results additionally pass the final safety scan. A failed capture leaves the gameplay operation result intact but disables saving and records a diagnostic reason.

## Three distinct operations

### Restore Exact

Exact mode first performs a read-only preflight. Model, base configuration, slot topology, selected parts, tuning ranges, paint-layer count, and known environment evidence must be available and unambiguous. Resolution order is:

1. exact path + slot ID + parent part;
2. exact path + slot ID;
3. unique slot ID + parent part + model;
4. incompatible when missing or ambiguous.

Exact mode never uses RNG, recent selections, session blacklists, suspect state, a random compatible part, current/default fallback, or omission. It restores the base, then applies only the shallowest changed slot depth per pass, waits for the phase-specific reload, reads a fresh tree, and continues. Tuning and paint values use their saved values. A final strict read-back must match every saved slot/tuning/paint field and slot/paint topology; otherwise the transaction rolls back. Results are `exact`, `failed`, or `unverified`—never “exact enough.”

When the target model is not loaded, the installed APIs available to this project do not expose a proven target slot tree without loading it. Preflight therefore reports `unverified` and blocks Exact instead of mutating first and calling that a preflight.

### Restore Compatible

Compatible mode uses the same preflight and resolution order. It may omit a missing optional slot, clamp a tuning value to a current range, or omit unsupported paint layers only when the report records the deviation and the user confirms a partial restore. Required/core parts are never omitted. It never chooses a random fallback. The final read-back verifies every subset value actually applied and safety validation runs before completion. Final status is `compatible`, `partial`, or `failed`.

### Replay Seed

Replay Seed reruns the saved generator operation and validated settings. It is not a restore. The result can differ if BeamNG, enabled content, starting state, filters, or other environment inputs changed. Generator version 4 uses `SCR4-XXXX-XXXX`; legacy `XXXX-XXXX` input remains accepted with the same underlying generator sequence. Manual-seed selection ignores hidden recent history.

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

Limits are 100 entries, 128 KiB canonical data per entry, 1 MiB for the library, 2,048 slots, 2,048 tuning variables, 32 paint layers, 20 tags, 32 nested levels, 10,000 imported elements, and 4,096 characters per string. The restore parts pipeline is capped at 12 parent-first passes.

## Import and export

The default export is **Copy DNA JSON**. Optional file export writes one controlled filename under the same settings folder; an entry ID or name is never used as a path. Pasted text is capped and parsed with `JSON.parse` into a data object before BeamNG bridge serialization. Lua discards unknown top-level fields except the bounded `extensions` object, rejects non-JSON types, cycles, non-finite numbers, oversized/deep structures, invalid schema, and duplicate paths/names.

No import value becomes Lua or JavaScript source, selects a method name, accesses the network, or chooses a filesystem path.

## Fingerprints

Canonical serialization sorts object keys, preserves array order, normalizes finite numbers, escapes strings, and rejects cycles, unsupported types, excessive depth/elements/path length/string length. Settings, environment, base identity, final state, dependencies, and starting state have separate fingerprints. Stored field fingerprints are recalculated during schema validation. These fingerprints are deterministic change detectors—not cryptographic signatures, mod hashes, compatibility proof, or a replacement for field-by-field Exact verification.
