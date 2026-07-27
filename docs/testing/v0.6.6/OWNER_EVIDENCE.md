# Owner evidence after environment cleanup

Evidence source: repository owner, BeamNG.drive `0.38.6`, testing the v0.6.5
live-clock candidate after removing BeamLR and the hidden
`scripts/driver_assistance_angelo234` scripts.

## Confirmed environment result

- Random Car and Full Random no longer hard-freeze at 22%.
- Scramble no longer hard-freezes at 57%.
- Operations advance without pause/unpause.
- Responsive per-tab sizing remains correct: Settings can expand and the other
  tabs return to their compact height.

This evidence attributes the old hard freeze to a third-party conflict or
amplification. It does not prove that the randomizer fixed BeamLR or Driver
Assistance, and the v0.6.6 work must not disable either mod automatically.

## Remaining reproduced Chaos failures

The owner repeatedly observed:

```text
Critical or required parts are missing after reload; vehicle recovery completed
Critical or required parts are missing after reload; current target restored to its clean candidate baseline
Final vehicle safety evidence is invalid; vehicle recovery completed
Falta óleo no motor
Motor incapacitado
```

The validator can reject a visibly useful partial result, for example:

```text
Chaos partial result: 51 parts, 15 tuning values, 2 paints
```

and then restore the previous vehicle, previous configuration, clean candidate,
or an earlier state. The evidence covers Random Car, Scramble, Full Random,
official vehicles, mod vehicles, and mod configuration packs.

## Remaining reproduced Race failures

- Placement appears disabled or has no useful effect.
- Generate Cars does not reliably retain the requested number of vehicles.
- Four requested cars can behave like repeated randomization of one target.
- Cards can report Partial or Failed while the expected vehicles are absent.
- Competitors are not reliably retained under unique managed vehicle IDs.
- Generation can replace the player vehicle instead of building a lineup around
  it.

## Visual identity evidence

The current mark is not immediately recognizable as a fox at small sizes and
can read as a dog, husky, skull, or mask. Stage A therefore requires a new,
original vector identity and deterministic transparent raster variants.

## Evidence boundary

These are owner-reproduced inputs to the implementation. No item in this file is
a v0.6.6 pass result. The candidate live report must remain all-pending until
the owner executes the final ZIP in BeamNG and records evidence.

