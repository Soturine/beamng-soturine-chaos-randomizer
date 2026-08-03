# UI migration decision — v0.7.0

## Decision

Version 0.7.0 packages only the native Vue frontend and requires BeamNG.drive
0.39. Version 0.6.9 is the final Angular release and the final release with a
0.38.6 minimum.

There is no packaged Angular fallback. This avoids two visible apps, two mounts,
two state subscriptions, duplicate commands, and competing resize or preference
state.

## Evidence

The following contracts were inspected before implementation:

- official BeamNG UI and HUD App creation documentation;
- official translation documentation and current language guidance;
- installed BeamNG 0.39.2.1 `ui/ui-vue/mods/README.md`;
- installed `lua/ge/extensions/ui/apps.lua` app discovery;
- installed Vue AppHost and AngularAppSlot selection logic;
- installed native Vue HUD Apps including AI Control, Advanced Wheel Debug,
  Task List, Messages, Traffic, Vehicle Radar, and Replay;
- installed bridge, event service, settings service, common components,
  tooltips, scoped UINav directives, and app overlay code.

The installed loader derives a Vue path by placing `app.vue` beside the app
manifest and sets a Vue capability on that one app record. AppHost renders the
Vue implementation first when it exists. The broader mod README describes
native module/route development under `ui/ui-vue/mods`; forcing this HUD App
into that topology would ignore the actual discovery contract.

The specifically named `AnnasToolbox` example was not present in the inspected
0.39.2.1 installation. Multiple shipped native HUD Apps supplied the equivalent
contract, and the absence is recorded rather than replaced by an invented path.

## Documentation divergence

The public App Creation page still describes the older Angular directive
workflow, while the installed 0.39 loader and official native apps implement
the colocated Vue path. For v0.7.0, installed source is the primary contract for
this undocumented transition. Public documentation remains a useful reference
for app metadata and HUD App behavior, not for choosing the frontend loader.

## Migration scope

- `app.js`, `app.html`, and `app.css` were removed from the runtime package.
- `app.vue`, modular components, stores, services, catalogs, composables, and
  SCSS replace them.
- The directive/app ID remains stable for user layout continuity.
- Settings migrate from schema 8 to 9. Locale and Race Policy preferences are
  stored in Lua; the previously persisted v0.6.7 Race Policy localStorage value
  is imported once and removed only after backend success.
- Ephemeral active tab, Details, current dialog, transient filters, and focus are
  not invented as durable legacy data.
- Generator version 6 and Vehicle DNA schema 1 remain unchanged.

## Parity and divergence

All feature rows have an automated Vue destination and representative fixture.
The intentional layout divergence is that the native AppHost, rather than
private Angular resize events, owns the outer window. Per-tab content remains
available through bounded scrolling, compact summaries, and host resize.
Actual visual sizing at every scale is in the live plan.

Official references:

- <https://documentation.beamng.com/modding/ui/>
- <https://documentation.beamng.com/modding/ui/app_creation/>
- <https://documentation.beamng.com/modding/programming/languages/>

Historical outcome: v0.7.0 failed before mount on a directory-style import;
v0.7.1 contains the module graph hotfix and remains Pending owner validation.
