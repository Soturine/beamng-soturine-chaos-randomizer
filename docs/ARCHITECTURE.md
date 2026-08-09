# Architecture

## v0.7.5 outcome, Event and authority boundaries

`operationOutcome` owns terminal outcome and confidence classification;
`progressWatchdog` owns phase-aware liveness. Race composition uses
`racePreview`, `raceFocusGuard`, `raceScheduler` and `lineupPersistence` so
renderer, focus, scheduler and disk failure cannot silently share one success
flag. `formationEnum` is the stable protocol boundary.

`vehicleIdentity` adds owner/network/environment/authority evidence to local
vehicle IDs. `domainOperations` still owns mutation/cleanup authorization and
rejects remote or unknown-authority cleanup. `contactDetector` and
`playgroundMode` are packaged foundations, not a user-facing Tag implementation.
Broad `main.lua` composition remains v0.8.0 decomposition debt.

The GE Lua backend owns game state and safety. The native Runtime UI Vue app is
a projection and command surface; it never becomes authoritative for vehicle
identity, ownership, generation, or persistence.

## Bootstrap

`soturineChaosRandomizer.lua` loads the extension. `main.lua` currently wires
modules, public compatibility methods, update hooks, event ingress, and state
publication. BeamNG access is isolated behind `apiAdapter.lua` and focused
adapters. This composition root is deliberately conservative but remains the
largest architectural debt.

## Operation lifecycle

Every Chaos, Race, and Garage operation receives an operation ID and generation.
Target-changing phases also receive a target generation. Terminal states are
success, partial, failed, cancelled, or timed out; cleanup is part of terminal
completion. Callback tokens bind domain, operation, generation, phase, slot,
expected vehicle, and one-time consumption.

## Vehicle identity

Logical identity (model/config keys) and concrete identity (BeamNG object ID)
are separate. Registry key, display label, and `.pc` filename are never assumed
equal. A candidate becomes a target only after current readback confirms its
operation generation and logical identity. Reused IDs and stale callbacks cannot
rebind newer work.

## Ownership and cardinality

`runtime/operationContext.lua`, `runtime/domainOperations.lua`, and
`managedVehicleRegistry.lua` record source, candidate, accepted, rejected,
temporary, and auxiliary IDs. Cleanup removes only proven operation-owned
objects. Scramble owns no temporary vehicle; single-target replacement owns at
most one; Race assigns exclusive ownership to each stable slot. Peak owned
temporary count and unexpected world deltas remain diagnostic evidence.
Replacement transactions explicitly record expected removed and added IDs and
accepted IDs. Unrelated global world changes cannot fail or retarget the
operation and are never cleanup targets.

## Generation pipelines

Random Car selects, requests one replacement, binds it, validates readback, and
terminates. Scramble keeps the bound concrete object and mutates its parts,
tuning, and paint. Full Random composes replacement and mutation stages under
one transaction and one rollback boundary. Deterministic substreams prevent an
unrelated lock or retry from perturbing other decisions.

## Safety

Runtime integrity is ternary: valid, invalid confirmed, or unknown. Drivability
and chaos-policy acceptance are independent decisions. Unknown tree, readback,
or fluid evidence triggers bounded rereads and can produce a warning/partial
result; it does not authorize destructive recovery. Repair is surgical before
rollback. Recovery targets the original or last accepted snapshot only with
matching identity, generation, and ownership evidence.

## Scheduler and watchdog

Heavy work is divided into cooperative steps with central per-frame, phase,
slot, and operation limits. The semantic watchdog advances on meaningful phase
or output progress, not callback noise. Cancellation and timeouts enter aborting
and cleaning states before terminal publication.

## Race

Race uses Cars → Placement → Drive. Each configured slot has a stable slot ID,
derived seed, retry count, phase, progress, candidate/accepted IDs, owned
temporary IDs, and terminal reason. Overall outcomes distinguish ready, partial,
failed, and cancelled lineups. Placement and AI address only ready managed
entries; player participation is counted separately from generated opponents.
Background spawn focus is restored to the player immediately; subsequent writes
address only the explicit slot-owned target. Accepted IDs leave temporary
ownership, and failed/cancelled/skipped slots cannot persist DNA.

Generation-staging and final-grid previews are overlay projections over pure
placement plans. They expose transforms, headings, footprints, margins and
visual state without concrete vehicle IDs and cannot mutate world state.

## Garage and Vehicle DNA

Vehicle DNA is versioned inert data with normalized identity, parts, tuning,
paint, safety, lineage, and lock metadata. Storage writes are transactional and
read back before publication. Import is bounded and strips unknown fields.
Restore performs preflight, resolves compatibility, applies parent-first, and
verifies the result before marking success.

## State publication and UI protocol

`uiStateProjector.lua` publishes full or domain-diff protocol-v2 envelopes with
monotonic state versions. `uiCommandRouter.lua` validates a fixed allowlist and
idempotent command IDs. The UI requests one full recovery snapshot after a gap;
stale diffs are ignored. Progress is structured (`phase`, `phaseProgress`,
`overallProgress`, operation/generation/slot context) and translated in Vue.

## Vue stores and projectors

One `app.vue` mounts one AppShell. Store projectors normalize map-or-array
collections without mutating incoming state. Error boundaries exist at app,
tab, and failure-prone Race-step scope. Backend status is converted into scoped,
expiring, deduplicated records. Teardown disposes subscriptions, timers,
observers, and command resources.

## Internationalization

The internal Vue catalogs translate app content and fall back to humanized safe
labels, never raw keys in normal UI. Packaged BeamNG locale catalogs translate
the host-visible app name and description. Internal IDs remain language-neutral
and are shown only in diagnostic/developer disclosure.

## Packaging

`VERSION` is canonical and `tools/sync_version.py` validates derived metadata.
`tools/package_mod.py` collects `lua/`, `ui/`, `settings/`, `locales/`, legal and
compatibility files in sorted order, normalizes text newlines, fixes ZIP metadata,
and emits SHA-256 plus a manifest. The validator rejects wrappers, traversal,
development content, source maps, malformed names, metadata drift, and
non-reproducible bytes.

## Testing

Lua tests execute production modules through a compatible interpreter or the
installed BeamNG console. Node tests cover pure UI services and mounted Vue
behavior. Python validates documents, topology, package policy, fixtures, and
release gates. Sanitized 0.39.4 fixtures are automated evidence; only the owner
can turn versioned live cases into BeamNG results.

## v0.8.0 debt

The planned decomposition is: `main.lua` → bootstrap/routing,
`chaosCoordinator`, `raceGenerationCoordinator`, `garageCoordinator`, shared
`operationLifecycle`, `runtimeUpdateLoop`, `eventRouter`, `statePublisher`, and
focused `apiAdapter` services. None of that decomposition is claimed in the
current release.
