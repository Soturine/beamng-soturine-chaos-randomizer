# UI protocol v2

The native Vue UI and GE Lua backend communicate through a centralized,
versioned protocol. Existing public Lua methods remain available for backend
compatibility, while the Vue runtime calls only `dispatchUICommand`.

## State envelope

Full, reset, and diff events carry:

```text
protocolVersion      stateVersion          eventType
domain               operationId           operationGeneration
targetGeneration     timestamp             payload
dirtySections
```

Protocol version is `2`. State versions increase monotonically for every
published full state or diff. A normal stale version is ignored. A diff gap
requests one full state while recovery is pending. A full state may rebase any
version; an explicit reset may move the version backwards. Unknown event types,
domains, versions, or non-object payloads fail closed.

Domains are `all`, `core`, `chaos`, `garage`, `race`, `settings`,
`compatibility`, `diagnostics`, `performance`, and `uiLayout`. A domain diff is
routed only to its matching store.

P1 dirty publishing is preserved: initial mount and explicit recovery use full
state; bounded progress uses a `core` diff. The existing publisher continues to
measure hook rate, byte rate, full/partial counts, and suppressed publishes.

## Command envelope

```text
command
commandId
protocolVersion
arguments
sourceView
```

The frontend allowlist defines minimum and maximum argument counts. Commands
receive unique bounded IDs and a technical source view. The complete envelope
is serialized once with the official bridge serializer and passed as data to
the one dispatcher call. User/import text is never concatenated into Lua code.

Lua validates protocol version, identifiers, argument count, finite numbers,
key types, depth 12, 4,096 elements, 16 top-level arguments, and a 128 KiB
encoded limit. The router rejects unknown commands, catches handler errors, and
caches 128 terminal command results so a duplicate ID cannot execute twice.

Responses contain `success`, `terminal`, `protocolVersion`, `commandId`,
`code`, and either `result` or `message`. A handler returning false becomes a
structured rejection. Frontend display never infers backend success from a
button click.

## Lifecycle rules

- One full-state request occurs after mount.
- A gap may request one additional full state until recovery completes.
- Unmount disposes the command bridge and resets only frontend protocol state.
- Backend operation state is never reset by visual unmount.
- Operation and target generations remain backend authority for stale callback
  rejection.

Version 0.7.2 keeps UI protocol 2. Tab, Details, compact, and resize actions are
local and never request full backend state. A full snapshot is requested only
at mount or bounded sequence-gap recovery. Normal updates are domain-addressed
diffs (`core`, `chaos`, `garage`, `race`, `settings`, `compatibility`,
`diagnostics`, `performance`) and leave unrelated store object identities
untouched. Source and extracted-ZIP protocol graphs pass automated validation;
live BeamNG 0.39.2.1 execution remains Pending owner validation.
