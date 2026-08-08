# UI protocol v2

The native Vue UI and GE Lua backend communicate through a centralized,
versioned protocol. Public compatibility methods remain backend-only; Vue calls
`dispatchUICommand` through one serialized bridge.

## State envelopes

Full, reset, and diff events carry protocol/state version, event type, domain,
operation/target generations, timestamp, dirty sections, and payload. State
versions are monotonic. Stale diffs are ignored; one full snapshot is requested
after a gap; a full/reset envelope may explicitly rebase state. Unknown types,
domains, versions, or payload shapes fail closed.

Domains are `all`, `core`, `chaos`, `garage`, `race`, `settings`,
`capabilities`, `diagnostics`, and `performance`. A domain diff cannot replace
unrelated collections. Incoming objects are cloned/normalized before stores
publish them.

## Commands

Commands include protocol version, unique command ID, source view, name, and
bounded typed arguments. The Lua router validates an allowlist, argument schema,
payload size, and source; duplicate IDs return their original result. Free-form
Lua code, executable imports, raw paths, and arbitrary method names are rejected.

## Progress

Progress is data, not a backend-authored presentation sentence:

```text
operationId  raceId  slotId  phase
phaseProgress  overallProgress  pass  attempt
```

Fractions are clamped and monotonic within their generation. Race aggregates
terminal slot states without hiding configured, opponent, ready, failed, or
cancelled counts. Vue translates the phase and formats the percentage; raw
technical codes remain available only in diagnostics.

Terminal Chaos outcomes use `SUCCESS`, `SUCCESS_WITH_WARNING`,
`FAILED_NO_CHANGE`, `FAILED_ROLLED_BACK`, or `CANCELLED`. Preview projection
uses `kind` (`staging` or `finalGrid`) and publishes origin, heading, formation,
spacing, plus per-slot transform, estimated/actual-bounds availability,
ground/overlap/position and visual status. Preview telemetry contains no
physical vehicle IDs.

## Results and status

Backend results publish stable code, success/partial state, scope, operation
context, and structured details. The UI converts them into localized scoped
status records with deduplication and expiry. A stale operation cannot leave a
banner in another tab. Retry actions are explicit and never issued by an error
boundary automatically.

## Recovery and teardown

The bridge and store coordinator maintain exactly one subscription path. On
unmount they dispose the event helper, outstanding requests, timers, status
records, and layout resources. Protocol recovery requests are coalesced so a
burst of gaps cannot create a reload loop.
