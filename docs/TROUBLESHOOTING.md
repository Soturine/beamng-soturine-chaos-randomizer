# Troubleshooting

## v0.7.6 diagnostic distinctions

- A completed operation with unsupported telemetry is a warning, not a partial
  mutation. Compare `terminalOutcome`, `appliedState` and
  `verificationConfidence` in Details.
- For Preview, inspect renderer availability, requested/rendered marker counts
  and the last error; `PREVIEW_DATA_READY` does not mean visible.
- For a Race stuck at Planned, capture scheduler, pending-next, active operation,
  slot generation and persistence state. The self-heal must schedule a planned
  slot or explicitly close an abandoned slot.
- Authority errors are protective: remote or unknown-authority vehicles are not
  mutable or removable by this mod.

## App missing or blank

Confirm the named release mod ZIP—not a source archive—is enabled and no older
copy is active. Verify the ZIP root and checksum, preserve `beamng.log`, then
reload the UI and re-add the HUD app. A missing module, CSS, locale, or asset is
a package failure and should include the exact internal path in the report.

## A view reports a render error

The error boundary should keep the app shell and other tabs mounted. Copy the
diagnostic payload before retrying. Record active tab, locale, compact state,
last command, operation/generation, and the first stack entry. Retry must not
duplicate the prior command.

## Select cannot be opened or changed

Record mouse/keyboard/controller input, focus state, selected value, option
shape, disabled/empty state, UI scale, and locale. Every dropdown is `ScrSelect`
over `BngSmartSelect`; a native `<select>` or a raw technical value in normal UI
is a defect.

## Busy or progress stalls

Do not use pause/frame-step as a workaround. Open Details, copy diagnostics, and
use **Cancel safely**. Record phase, phase/overall progress, watchdog age,
pending callbacks/writes/timers, operation and target generations, and concrete
vehicle ID. A deadline must end in aborting/cleaning/terminal state.

## Random Car or Full Random creates extra vehicles

Stop further operations and preserve the world vehicle list plus transaction
ownership diagnostics. Do not manually delete a candidate before evidence is
captured. A single-target operation may have the source plus at most one owned
temporary in flight and exactly one accepted target at completion.

## Scramble changes or replaces the vehicle

Capture object ID, model/config identity, parts/tuning readback, generation, and
instability/removal events. Scramble must use zero spawn/replace calls and keep
the same concrete object unless the game removes it, in which case it must fail
clearly without touching another vehicle.

## Race slot is missing, duplicated, or controls another vehicle

Export slot ID, derived seed, attempt, phase, candidate/accepted IDs, owned
temporary IDs, managed handle, and generation for every competitor. Placement
and AI are allowed only for terminal-ready managed entries. Stop AI before
manual vehicle cleanup.

## Registry/config names look wrong

Do not infer identity from the visible label or `.pc` filename. Reindex once and
record model registry key, config registry key/path, display label, family,
subgroup, source, and whether the registry was warming up or ready.

## Compact layout leaves empty space

Record tab, inner content dimensions, outer AppHost frame, UI scale, alignment,
safe zones, locale, and saved layout history. The app controls internal compact
content; BeamNG controls the outer persisted HUD frame. Do not patch a private
AppHost method.

## Renderer, VRAM, or OOM incident

Record BeamNG build, renderer, GPU vendor/model, VRAM, map, traffic count,
world/owned vehicle counts, peak owned temporary count, operation, and phase.
Classify only with evidence as `mod_cardinality_violation`,
`mod_memory_pressure`, `engine_renderer_known_issue`, or `unknown`. Suspecting a
driver issue does not relax the mod's ownership/cardinality limits.

## Preparing a report

Use the versioned [evidence template](testing/v0.7.4/EVIDENCE_TEMPLATE.md).
Attach the downloaded artifact identity, minimal reproduction, expected and
actual terminal state, diagnostic export, and relevant log window. Keep live
status **Pending owner validation** until the owner completes the case.
