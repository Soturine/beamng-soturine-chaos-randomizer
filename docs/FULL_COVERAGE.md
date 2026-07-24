# Full Coverage

Version 0.6.0 makes coverage an observable classification contract. It does not
promise that every eligible value changes.

## Public action semantics

- **Random Car** loads one complete eligible configuration and stops. Its
  compatible internal operation ID remains `randomConfig`; it creates no
  mutation ledgers.
- **Scramble** keeps the current model and runs parts, tuning, paint, final
  read-back, and validation on that target.
- **Full Random** loads a new model/configuration and then runs the same central
  Scramble pipeline. It cannot complete after the base spawn alone.
- **Chaos Lineup** invokes Full Random sequentially; it does not contain a
  reduced mutation algorithm.

## Chaos and coverage

At Chaos 100, every eligible and unlocked slot, public tuning variable, and
supported paint field is selected for an attempt and receives a final ledger
classification. At lower Chaos values, project-owned deterministic substreams
select a subset; eligible entries outside it are classified
`not_selected_by_chaos`.

Coverage and change are separate:

- a selected entry can be `unchanged_no_alternative`, `readback_clamped`,
  `unsupported`, `quarantined`, or another terminal state;
- a changed entry must have confirmed read-back;
- `Completed` means every discovered eligible entry has a terminal,
  evidence-backed classification and final validation passed;
- it does not mean every value changed.

## Ledgers

`slotCoverageLedger.lua`, `tuningCoverageLedger.lua`, and
`paintCoverageLedger.lua` are separate bounded ledgers. Each binds once to its
`operationId`, target generation, model, and configuration identity. A ledger
is closed on cancellation or recovery and cannot migrate to a recovery target.

The slot ledger uses a composite identity derived from model, configuration,
hierarchical path, parent path, slot type/ID, depth, generation, and observed
part. Homonymous slots under different parents therefore do not collide.
Aggregate diagnostics report discovered, eligible, selected, attempted,
changed, unchanged, rejected, disappeared, quarantined, locked, and terminal
counts without copying the complete tree every frame.

## Tree convergence

Target identity and parts-tree convergence are independent:

1. the target is confirmed from operation/generation, returned/callback/player
   ID evidence, model, configuration, and ownership;
2. the loaded tree is scanned only after target confirmation;
3. ancestor changes defer descendants;
4. reload/read-back exposes the new real tree;
5. new slots are added and disappeared slots are classified;
6. bounded no-progress, repeated-state, time, pass, depth, candidate, and
   absolute limits terminate honestly as Partial when needed.

The target fingerprint deliberately excludes the parts tree. A changing tree
can never reset identity or retarget a write by itself.

## Failure and rollback

Failed batches are isolated through bounded binary or individual replay.
Confirmed and suspect quarantine remain distinct; a failure in the second item
does not punish the first. A localized rollback preserves already confirmed
unrelated changes. Total recovery starts only after local recovery is exhausted
or the target is no longer safe.

`Keep Partial Result` is explicit and off by default. With it off, an
unaccepted Partial result recovers the prior vehicle. With it on, only a final
validated partial vehicle can remain, and its status stays Partial.

## Evidence status

Automated Lua/mocked coverage is recorded in [Testing](TESTING.md). Real
BeamNG vehicle/mod coverage remains Pending in the
[0.6.0 interactive plan](INTERACTIVE_TEST_PLAN_0.6.0.md); no static test proves
generic gameplay compatibility.
