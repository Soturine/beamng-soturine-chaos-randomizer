# UI design and accessibility

The UI has four top-level destinations: **Chaos**, **Garage**, **Race**, and
**Settings**. The graphite/black visual system uses restrained orange emphasis
and the local v0.6.1 fox artwork. The decorative fox cannot consume the title's
flexible text width.

## Information architecture

- **Chaos** contains Random Car, Scramble, Full Random, the Chaos slider,
  conditional seed/lock warnings, and operation status.
- **Garage** contains Saved, Compare, and Share for Vehicle DNA.
- **Race** follows Cars → Placement → Drive. Internal `lineup` names remain only
  at compatibility boundaries.
- **Settings** owns seed mode, locks, content policy, diagnostics, Undo, and
  Reindex.

## Size and modes

The manifest starts at 340×300 px with a 300×120 px minimum. Expanded height is
computed from rendered header, navigation, and body content, clamped to
240–720 px and the available screen. Collapsed height is content-based and
clamped to 120–220 px. A user's manual expanded height remains a floor. A
`MutationObserver` schedules measurement after content changes; a one-pixel
deadband and last-applied/manual-height tracking prevent resize feedback loops.

Expanded mode exposes navigation and the selected workflow. Collapsed mode
retains identity, action/status/progress, and Cancel while Busy. Contextual
views scroll only when measured content exceeds the safe viewport limit.

## Slider and operation feedback

The Chaos range input is transparent over a real track and orange fill element.
The fill width is the clamped `0–100%` value, so it does not depend on a custom
property inside a browser pseudo-element. The 0/50/79/100 calculations and
out-of-range clamping have JavaScript tests.

Busy status shows phase, progress, safe Cancel, Details, and diagnostic copy. A
stalled warning remains visible and actionable. Destructive concurrent actions
are disabled while cancellation and diagnostics remain available.

Controls retain labels, `:focus-visible` treatment, polite live regions,
progressbar semantics, bounded scroll areas, confirmations, and a fixed
allowlisted Lua bridge. Rendering, scaling, input behavior, no-scroll default
Chaos layout, and fox appearance remain Pending in the current [live test
plan](testing/v0.6.4/LIVE_TEST_PLAN.md).
