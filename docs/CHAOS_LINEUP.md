# Chaos Lineup

Chaos Lineup creates a bounded production collection of 2–16 competitors. An
advanced data/API option can allow one competitor for testing. Each competitor
runs the complete central Full Random pipeline sequentially; concurrent vehicle
loads are not used.

## Generation and acceptance

The flow for each slot is: checkpoint the lineup, derive its independent seed,
run Full Random, classify all three ledgers, perform final read-back and safety
validation, create Vehicle DNA, then checkpoint the accepted result.

A competitor is `Ready` only when the target is confirmed, final validation
passed, Busy is false, DNA exists, and pending writes, timers, and callbacks are
all zero. Warnings produce `Ready with warnings`. Coverage partials or results
blocked by explicit acceptance policy remain `Partial`.

The creation controls explicitly choose whether to accept:

- partial competitors;
- metadata-uncertain competitors;
- potentially undrivable competitors.

Metadata is evidence, never proof of drivability. Accepting uncertainty keeps a
warning. Other generation states are `Failed`, `Skipped`, or a recorded
quarantined-candidate replacement.

## Seeds and variety

An episode seed has the form `RACE-XXXX-XXXX`. Competitor index, retry attempt,
and domain derive independent substreams; the central generator further forks
vehicle/configuration, part, slot, candidate retry, tuning, paint, naming,
spawn, and AI domains. Retrying competitor 2 cannot change competitor 3.

Variety options cover duplicate model/configuration/family avoidance, maximum
same family, class/propulsion/drivetrain/source/wheel/body preferences, and
official/mod/Automation/trailer/prop allow rules. Hard rules and preferences
use only verified current metadata. Missing evidence stays unknown and is not
invented. Presets are limited to Balanced, Maximum Chaos, and Mods Showcase.

## Failure handling

Each competitor has a target generation and bounded attempt count. Failure
closes the failed generation and its ledgers, recovers the prior target,
quarantines the failing candidate, and preserves earlier competitors. User
actions are Retry slot, Skip slot, verified official fallback, or Stop. A retry
gets a new target generation and independent attempt substream.

Initial creation, pre-competitor state, and every finished competitor are saved
incrementally. A storage checkpoint failure stops generation rather than
continuing with unrecorded progress.

## Collection and schema

`lineupSchemaVersion` remains 1. A lineup contains stable identity, name,
timestamps, episode/generator versions, settings, variety rules, competitors,
spawn plan, AI plan, warnings, and dependencies. Competitors carry position,
display name, DNA ID/portable DNA metadata, seed, model/configuration/source,
dependencies, compatibility, coverage, generation/race status, optional
thumbnail, notes, and target generation.

Race status is one of Pending, Ready, Eliminated, Qualified, Winner, DNS, or
DNF. Renaming changes display metadata only and never changes Vehicle DNA.

The `.lineup.json` import path is fixed and bounded. Unknown/executable fields
are discarded by schema sanitization, exporter compatibility claims are not
trusted, and compatibility is recalculated from local mounted content. Exports
contain data only—never mods, JBeam, textures, executables, or scripts.

## Evidence status

Schema, bounds, substreams, variety, acceptance, storage, data-only import, and
failure actions have automated evidence. Live 2/4/8/16 generation, mod
compatibility, and performance remain Pending in the interactive plan.
