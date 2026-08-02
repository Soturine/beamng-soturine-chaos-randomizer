# Soturine's Chaos Randomizer

Soturine's Chaos Randomizer is an experimental BeamNG.drive HUD App for
deterministic vehicle chaos. It can load a random vehicle, scramble the active
vehicle, run the complete bounded pipeline, save and restore Vehicle DNA, and
orchestrate Race placement and AI workflows.

Current release: **0.7.0**, an experimental prerelease with a native Runtime UI
Vue frontend. The minimum supported game version is **BeamNG.drive 0.39**.
Automated checks cover the packaged source and deterministic harnesses; gameplay,
rendering, physics, controller hardware, and live performance remain owner work.

Live BeamNG 0.39 validation: Pending owner validation

## Install or upgrade

1. Download `soturine_chaos_randomizer_0.7.0.zip` from the
   [v0.7.0 release](https://github.com/Soturine/beamng-soturine-chaos-randomizer/releases/tag/v0.7.0).
   Do not use GitHub's automatic source archive.
2. Put the ZIP, without extracting it, in the BeamNG user folder's `mods`
   directory.
3. Remove or disable every older Chaos Randomizer ZIP. Only one version may be
   active.
4. Start BeamNG 0.39, enable the mod, open HUD Apps, and add
   **Soturine's Chaos Randomizer**.
5. Confirm `0.7.0` appears in the orange header.

The release also provides a SHA-256 file and a JSON manifest. A valid package
has `lua/`, `ui/`, `settings/`, `COMPATIBILITY.json`, `LICENSE`, `NOTICE`, and
`VERSION` at its root.

Version 0.6.9 is the last Angular release and the last release declaring a
0.38.6 minimum. Version 0.7.0 does not package an Angular fallback because the
installed 0.39 AppHost already chooses a colocated `app.vue` as the native app
entry, while no supported single-entry mechanism provides an older-runtime
fallback without risking two mounts or two subscriptions.

## Native Vue UI

The app has four tabs:

- **Chaos** — Random Car, Scramble, Full Random, locks, mutation, recovery,
  result details, progress, safe cancel, and diagnostics.
- **Garage** — Vehicle DNA save, search, filter, sort, pagination, details,
  exact/compatible restore, replay, mutation, metadata, thumbnails, comparison,
  and JSON/package sharing.
- **Race** — Cars, Placement, Drive, the complete Race Policy, competitor
  recovery, formations, managed vehicles, destination/route, and AI controls.
- **Settings** — seed, content, safety, performance, persistence,
  compatibility, and language.

Each tab has a tab-specific compact representation. Details state is also kept
per tab. The native AppHost owns the outer window geometry; the app responds to
host resize without private resize APIs and retains per-tab user-size
observations for deterministic layout decisions.

The interface uses real buttons and labels, visible focus, scoped UINav,
directional tab navigation, Back/Cancel handling, focus-trapped confirmation
dialogs, high-contrast tokens, and reduced-motion behavior. Mouse, keyboard,
and controller paths have automated structural coverage; hardware execution is
still Pending.

## Languages

The UI includes:

- English (`en-US`), the fallback catalog;
- Brazilian Portuguese (`pt-BR`).

The game language is used by default. Settings can override the locale for the
app. Translation affects presentation only: seeds, model/configuration keys,
locks, Vehicle DNA, Race Policy IDs, ordering, and deterministic generation do
not depend on translated labels. See [i18n](docs/I18N.md).

## Determinism and safety

Random Car selects one eligible model/configuration. Scramble keeps the active
base and mutates its discoverable slot tree, tuning, and paint. Full Random
combines both in one transaction. Success is based on bounded coherent
readback, not on UI callbacks.

The backend preserves the P0 ownership, cardinality, stale-callback, rollback,
quarantine, registry, path-identity, migration, and ternary-safety contracts.
It also preserves the P1 profiler, frame budgets, low-GC iteration, reusable
buffers, caches, incremental indexing, dirty UI diffs, diagnostics aggregation,
adaptive polling, and AI confirmation.

Generator version remains 6 and Vehicle DNA schema remains 1. Settings schema
is 9 because it now stores versioned UI preferences and Race Policy values.

## Data and privacy

Settings, lock preferences, Vehicle DNA, lineups, caches, and migration reports
remain in the BeamNG user data area managed by the mod. Upgrading does not
discard valid libraries. Keep a backup before live testing import, restore, or
large Garage/Race scenarios.

Diagnostics redact personal paths and contain no credentials. The UI accepts
only allowlisted, schema-checked commands. Import text is parsed as data,
bounded to 128 KiB at the bridge, and never interpolated as Lua code. The
package contains no CDN, remote runtime asset, npm runtime, `node_modules`, or
source map.

## Troubleshooting

- If the app does not appear, verify BeamNG 0.39+, remove old mod ZIPs, clear
  the UI cache, reload the UI, and check `beamng.log` for the extension name.
- If state appears stale, remove and re-add the HUD App. A remount requests one
  full state and does not restart an active backend operation.
- If a command is unavailable, open Details or Settings → Compatibility. The
  UI reports capability degradation instead of pretending the action ran.
- If a restore or import warns, review the compatibility/preflight report
  before confirmation.
- For deeper recovery and data locations, see
  [Troubleshooting](docs/TROUBLESHOOTING.md) and
  [Installation](docs/INSTALLATION.md).

## Validation and development

The automated gate runs Python, production Lua 5.1 fixtures, JavaScript/Vue
service and state tests, SFC compilation with pinned Vue 3.5 tooling, static
accessibility/i18n/parity/security checks, deterministic packaging, checksum,
and manifest verification.

```text
npm ci --ignore-scripts
npm run test:ui
npm run validate:sfc
python -m unittest discover -s tests -v
python tools/package_mod.py
python tools/validate_package.py
```

Development dependencies validate source only and are never included in the
mod ZIP. See [testing evidence](docs/testing/v0.7.0/README.md),
[architecture](docs/UI_VUE_ARCHITECTURE.md), and the
[UI protocol](docs/UI_PROTOCOL.md).

## Release status

Version 0.7.0 is an experimental prerelease. Automated validation does not
replace the [live test plan](docs/testing/v0.7.0/LIVE_TEST_PLAN.md). Results must
be recorded against the downloaded release ZIP before any stronger gameplay,
compatibility, visual, input, or performance claim is made.

License: [MIT](LICENSE). Security policy: [SECURITY.md](SECURITY.md).
