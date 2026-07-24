# UI Design and Accessibility

The alpha.2 UI has five stable primary destinations: **Randomize**, **Locks**, **Garage**, **Compare**, and **Share**. Compatibility remains a read-only report inside Garage details. The visual system is graphite/black with restrained orange emphasis, soft card borders, and no debug-console presentation.

- Randomize keeps **Random Car**, **Scramble**, and **Full Random** as the three direct actions. Random Car maps to `randomConfig`. Reroll Unlocked and mutation strengths are contextual secondary tools under Advanced and remain absent without selected DNA.
- Locks exposes vehicle/configuration toggles, four presets, lock/unlock/invert tools, evidence categories, composite wheel/tire and engine/drivetrain controls, current-part locking, slot search, counts, paths, and unresolved evidence.
- Garage provides debounced search, filters, sort, grid/list, paginated lazy cards, storage meter, metadata, lineage, capture/remove image, restore/replay/reroll/mutate/compare/share/duplicate/rename/favorite/delete actions, and explicit replay lock policy.
- Compare renders bounded field differences by category and supports using or mutating the left base.
- Share separates JSON preparation/file export, ZIP export, parsed JSON import, fixed-inbox ZIP preview, dependency/privacy/checksum feedback, and final confirmation.

The app defaults to 330×430 with a 300×340 minimum. Collapsed shows the identity/status strip; compact keeps direct actions and essential feedback; standard and expanded reveal progressively more context. Recovery cards expose safe spawn, retry/quarantine, and inert diagnostics copy when appropriate.

Controls have visible `:focus-visible` treatment, labels, polite live regions, a progressbar, confirmation before destructive operations, and cancel/rollback feedback. Layouts reflow below 390 and 320 pixels, preserve minimum hit sizes, wrap long content, bound scroll areas, and honor reduced-motion preferences. Keyboard, 125–200% scaling, controller integration, screen-reader output, and real UI overflow remain Pending until observed in BeamNG.

Only fixed method names cross the UI bridge. Settings and Garage search use separate cancelled debounces. Full DNA, export text, thumbnail bytes, and full details are delivered only by explicit one-off events, not normal state refreshes.
