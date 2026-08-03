# Native Vue UI architecture

Version 0.7.0 uses one native Runtime UI Vue HUD App. The entry is the
`app.vue` colocated with the stable `app.json` under the existing app ID. There
is no Angular wrapper, second selector entry, iframe, runtime npm dependency, or
parallel subscription path.

## Topology

```text
app.json -> app.vue -> AppShell
                    |-> common components
                    |-> Chaos components
                    |-> Garage components
                    |-> Race components
                    |-> Settings components
                    |-> nine stores
                    |-> command/state/i18n/lifecycle services
                    `-> responsive-layout composable and SCSS
```

The installed BeamNG 0.39 AppHost discovers `app.vue` beside `app.json`, marks
the app as Vue-capable, and selects that path before the legacy Angular host.
The broader `ui/ui-vue/mods/README.md` contract remains useful for SFC,
component, bridge, slots, and UINav conventions, but HUD App discovery uses the
colocated file contract implemented here.

## State ownership

Lua remains authoritative for operations, lifecycle, target ownership, Garage,
Vehicle DNA, Race, settings, compatibility, diagnostics, and performance.
Frontend stores own only presentation state such as active tab, compact mode,
per-tab Details, Race step, Garage section/view, dialog state, focus, and host
size observations.

Nine stores isolate `core`, `chaos`, `garage`, `race`, `settings`,
`compatibility`, `diagnostics`, `performance`, and `uiLayout`. Full snapshots
replace domain state without retaining references to the incoming payload;
diffs patch only their declared domain. Technical IDs never depend on labels.

## Lifecycle

`useEvents` is the official Runtime UI subscription helper and registers its
own scope cleanup. The root subscribes exactly once to full state, state diff,
and diagnostics-copy events. Remount loads the extension idempotently and asks
for one full state; it never starts or resets a backend operation.

ResizeObserver, media-query listeners, Garage debounce timers, command bridge,
and local protocol state have explicit teardown. Automated tests exercise 100
layout instances and 100 lifecycle registries. Live remove/add and CEF memory
evidence remain Pending.

## Layout and input

The outer AppHost owns placement and user resize. No undocumented host-resize
API is called. The UI fills its host, records a user size per tab, chooses
narrow/medium/wide layout classes, scrolls bounded content, and keeps tab-
specific preferred expanded/compact sizes. This deliberately avoids the legacy
Angular programmatic-resize loop; automatic outer-window growth on tab changes
is an evidence-backed divergence, with stable scrollable content as the safe
fallback.

Scoped UINav handles directional focus and Back. Native buttons, inputs,
labels, tab roles, progress semantics, modal focus trapping, visible focus,
forced-color rules, and reduced motion cover mouse, keyboard, and controller
paths structurally.

## Dependencies and build

BeamNG loads source SFCs and modules directly, so no runtime bundle is built.
Pinned Vue compiler and Sass packages are development-only validation tools.
`node_modules` and source maps are forbidden in the ZIP.

The v0.7.1 source and extracted-ZIP module graphs pass. Live BeamNG 0.39
AppHost mounting remains Pending owner validation.
