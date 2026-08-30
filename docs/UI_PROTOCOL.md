# UI protocol v2

## v0.7.9 stable result and Preview codes

Terminal outcomes are `COMPLETED`, `COMPLETED_WITH_SKIPS`,
`COMPLETED_WITH_WARNING`, `PARTIAL_APPLIED`, `FAILED_TIMEOUT`,
`FAILED_STALLED`, `FAILED_RUNTIME_INTEGRITY`, `FAILED_NO_CHANGE`,
`FAILED_ROLLED_BACK`, `FAILED_SPAWN`, `FAILED_BIND`, `FAILED_RELOAD`,
`FAILED_PERSISTENCE` and `CANCELLED`. Applied state is independently
`APPLIED`, `APPLIED_WITH_SKIPS`, `APPLIED_WITH_WARNING`, `PARTIALLY_APPLIED`,
`NOT_APPLIED` or `ROLLED_BACK`; verification confidence is independently
`CONFIRMED`, `UNCERTAIN`, `NOT_APPLICABLE` or `UNSUPPORTED_TELEMETRY`.

Preview states are `PREVIEW_DISABLED`, `PREVIEW_DATA_READY`,
`PREVIEW_RENDER_AVAILABLE`, `PREVIEW_RENDERING`, `PREVIEW_RENDERED`,
`PREVIEW_FAILED` and `PREVIEW_STALE`. Formation business values are the stable
`AUTO_BEST_FIT`, `GRID`, `LINE`, `SIDE_BY_SIDE_GRID`, `STAGGERED_GRID`,
`SPLIT_LEFT_RIGHT`, `SINGLE_FILE_BEHIND`, `SINGLE_FILE_AHEAD` and `RADIAL`
codes. Legacy runtime or translated values normalize only at ingress; runtime
names are produced only at the backend command boundary. Phase, outcome and
Preview codes are translated by the frontend and appear raw only in explicit
technical disclosure.

Race readiness publishes separate generation, placement, drivability and AI
axes. Policy failures include profile, rule, severity, evidence and decision;
placement readiness never implies renderer visibility.

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
