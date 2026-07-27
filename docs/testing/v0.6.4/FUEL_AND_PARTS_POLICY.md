# Fuel and parts policy — 0.6.4

## Evidence rule

The randomizer may correct or reject only what current, coherent evidence
proves. Missing metadata is not proof of danger. It is recorded as uncertainty
and cannot alone trigger destructive recovery.

## Energy classifications

| Classification | Guarded to 10% | Meaning |
| --- | --- | --- |
| `combustion_fuel` | yes, when correlated and readable | fuelTank/gasoline/diesel/kerosene evidence |
| `electric_energy` | no | electric battery/energy/kWh evidence |
| `nitrous` | no | n2o/nitrous storage or tuning |
| `air_pressure` | no | pneumatic/compressed-air pressure storage |
| `hydraulic` | no | hydraulic reservoir/pressure evidence |
| `unknown_storage` | no | insufficient storage metadata |
| `normal_tuning` | no | non-storage tuning variable |

Each combustion tank needs finite positive capacity and a correlated variable
or finite static starting value. Explicit `startingFuelCapacity` references are
strongest; source-part, storage-name, capacity, and canonical variable evidence
are secondary. Multiple tanks are evaluated independently and a shared variable
uses the highest required floor.

Outcomes:

- confirmed at/above 10%: no write, verified;
- confirmed below 10%: write the floor and require read-back;
- no combustion storage: not applicable;
- ambiguous variable/capacity/current value: uncertain warning;
- read API unavailable: unavailable warning;
- correction not confirmed after bounded attempts: correction-unconfirmed
  warning with the current vehicle preserved.

None of the warning paths is relabeled “safe”. They produce an honest partial
success and remain visible in diagnostics, result details, and Vehicle DNA when
capture is possible.

## Missing-part classifications

| Classification | Fatal | Policy |
| --- | --- | --- |
| `core_infrastructure_missing` | yes | BeamNG `coreSlot`/equivalent structural evidence is empty |
| proven baseline functional role lost | yes when protection enabled | topology evidence such as propulsion/power path disappeared |
| `optional_missing_allowed` | no | empty optional slot selected with Allow Missing |
| `optional_missing` | no | optional slot already empty while Allow Missing is off |
| `mod_metadata_required_unproven` | no | third-party non-standard `required` hint without `coreSlot` proof |
| parts tree temporarily unavailable | no initially | bounded real-time retry |
| parts tree remains unreadable | partial for public Chaos flows | preserve current stable target; do not restore stock solely for unreadability |

Allow Missing changes selection eligibility, not structural truth: a core slot
and proven critical functional role stay protected. Conversely, turning Allow
Missing off does not invent a part for an optional slot that was already empty.

DNA Exact/Compatible transactions retain their stricter saved-state rules and
can still fail/rollback when an explicitly required saved invariant cannot be
applied. The nonfatal public Chaos policy is not permission to report an Exact
DNA restore that diverged.
