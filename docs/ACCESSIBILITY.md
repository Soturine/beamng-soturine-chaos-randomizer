# Accessibility and input

The v0.7.0 Vue UI treats mouse, keyboard, and controller navigation as one
interaction model.

Implemented contracts:

- real buttons, inputs, selects, textareas, labels, tabs, and progress roles;
- stable DOM order and visible `:focus-visible` treatment;
- official scoped UINav containers and directional tab actions;
- Back closes the current dialog or active Details layer before changing tabs;
- confirmation dialogs trap focus and return it to the invoking control;
- tooltips supplement visible labels and are not the sole information source;
- icon buttons have accessible labels;
- progress and global status use polite live regions;
- disabled controls remain visibly distinct without relying only on color;
- `prefers-reduced-motion` suppresses nonessential transitions/animation;
- forced-colors rules preserve boundaries and progress indication;
- compact mode retains tab-specific essential controls.

Automated validation inspects roles, labels, navigation directives, dialog
semantics, focus tokens, reduced motion, high contrast, and 100 lifecycle/layout
cycles. It does not claim screen-reader, Xbox controller, DualSense, HDR, or CEF
focus behavior was executed. Those cases remain in the live matrix.

Known limitation: the installed native HUD App contract exposes AppHost-owned
geometry but no documented programmatic resize service equivalent to the old
Angular event. The UI therefore uses bounded scrolling and responsive content,
and never steals focus or forces an undocumented resize during navigation.

Live BeamNG 0.39 validation: Pending owner validation
