# UI Design and Accessibility

The 0.6.0 UI keeps **Randomize**, **Locks**, **Garage**, **Compare**, and
**Share**, and adds production destinations for **Chaos Lineup**, **Spawn
Director**, and **AI Director**. Compatibility remains a read-only report inside
Garage details. The visual system is graphite/black with restrained orange
emphasis, soft card borders, and no debug-console presentation.

- Randomize keeps **Random Car**, **Scramble**, and **Full Random** as the three direct actions. Random Car maps to `randomConfig`. Reroll Unlocked and mutation strengths are contextual secondary tools under Advanced and remain absent without selected DNA.
- Locks exposes vehicle/configuration toggles, four presets, lock/unlock/invert tools, evidence categories, composite wheel/tire and engine/drivetrain controls, current-part locking, slot search, counts, paths, and unresolved evidence.
- Garage provides debounced search, filters, sort, grid/list, paginated lazy cards, storage meter, metadata, lineage, capture/remove image, restore/replay/reroll/mutate/compare/share/duplicate/rename/favorite/delete actions, and explicit replay lock policy.
- Compare renders bounded field differences by category and supports using or mutating the left base.
- Share separates JSON preparation/file export, ZIP export, parsed JSON import, fixed-inbox ZIP preview, dependency/privacy/checksum feedback, and final confirmation.
- Chaos Lineup exposes only three presets, explicit partial/metadata/drivability
  acceptance, verified-metadata variety rules, failure limits/actions, and
  eight-card pagination.
- Spawn Director exposes bounded layouts/custom point, heading evidence,
  spacing/ground/clearance/interval, preview, sequential start/cancel, and one
  managed-vehicle row per handle with generation/status/respawn/remove.
- AI Director exposes capability-honest modes, NavGraph explanation,
  destination exact/snap, route editing, audited speed/aggression, stagger,
  finish/stuck policy, group controls, and per-vehicle recording commands.

The app defaults to 330×430 with a 300×340 minimum. Collapsed shows the
identity/status strip. Compact becomes a recording-friendly **CHAOS DIRECTOR**
view with ready count, destination, speed/aggression, managed-vehicle stepper,
and Start/Stop. Standard and expanded reveal progressively more context;
production screens may scroll without permanently resizing the main panel.
Recovery cards expose safe spawn, retry/quarantine, and inert diagnostics copy
when appropriate.

Controls have visible `:focus-visible` treatment, labels, tooltips for every
navigation destination, polite live regions, a progressbar, confirmation before
destructive operations, and cancel/rollback feedback. While Busy, concurrent
destructive actions are disabled but Cancel, Copy diagnostics, phase details,
and recovery information remain available. Concrete lifecycle phase,
pause/resume wait, operation/phase/target generations, stale callbacks, and
stalled warning are shown instead of a bare Busy label. Layouts reflow below
390 and 320 pixels, preserve minimum hit sizes, wrap long content, bound scroll
areas, and honor reduced-motion preferences. Keyboard, 125–200% scaling,
controller integration, screen-reader output, and real UI overflow remain
Pending until observed in BeamNG.

Only fixed method names cross the UI bridge. Settings and Garage search use separate cancelled debounces. Full DNA, export text, thumbnail bytes, and full details are delivered only by explicit one-off events, not normal state refreshes.
