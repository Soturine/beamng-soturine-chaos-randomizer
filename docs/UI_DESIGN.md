# UI Design and Accessibility

The v0.6.1 UI has exactly four top-level destinations: **Chaos**, **Garage**,
**Race**, and **Settings**. The graphite/black visual system uses restrained
orange emphasis and a lightweight local fox SVG in another orange tone. The fox
is decorative, subtle, and cannot consume the title's flexible text width.

## Information architecture

- **Chaos** contains Random Car, Scramble, Full Random, the Chaos slider,
  conditional fixed-seed/active-lock warnings, and operation status. It does
  not contain seed input or category lock chips.
- **Garage** contains **Saved**, **Compare**, and **Share**. Existing Vehicle DNA
  schema, restore, replay, mutation and inert transfer behavior is unchanged.
- **Race** is a single Cars → Placement → Drive workflow. Cars owns count,
  preset and competitor statuses; Placement owns formation/spacing/heading and
  spawn; Drive owns AI mode/destination or route/speed/aggression/stagger.
- **Settings** owns seed mode, fixed seed, lock persistence/categories, content
  policy, diagnostics, Undo and Reindex.

The internal names `lineup`, Spawn Director and AI Director remain where needed
for saved-data and API compatibility. Public controls and documentation use
Race/Race Cars.

## Size and modes

Expanded defaults to **340×320 px**, with a **300×220 px** minimum. Chaos is
designed to fit the default without normal scrolling; Garage and Race may use
contextual internal scrolling. Essential text is at least 12 px, ordinary
buttons have at least 32 px hit height, and primary actions are at least 44 px.

Only two semantic modes exist:

- **Expanded** exposes navigation and the selected workflow.
- **Collapsed** reduces height to roughly 120–150 px and retains identity,
  action/status/progress and Cancel while Busy.

The ambiguous C/S header controls and the near-duplicate compact/standard modes
were removed. Normal BeamNG app resizing remains available.

## Slider and operation feedback

The Chaos input has zero horizontal padding, a separate labels wrapper, and
explicit Chromium `::-webkit-slider-runnable-track` and
`::-webkit-slider-thumb` geometry. The 0/50/100 labels and thumb centers must be
verified at 100%, 125%, 150% and 200% display scale in BeamNG.

Busy status shows the phase, progress, safe Cancel, Details and diagnostic copy.
A stalled warning remains visible and actionable. Destructive concurrent
actions are disabled while cancellation and diagnostics remain available.

Controls retain labels, `:focus-visible` treatment, polite live regions,
progressbar semantics, bounded scroll areas, confirmations, and a fixed
allowlisted Lua bridge. Actual rendering, scaling, gamepad/screen-reader
behavior and fox appearance remain Pending in the v0.6.1 interactive plan.
