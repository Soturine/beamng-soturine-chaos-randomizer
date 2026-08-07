# Repository execution rules

## Runtime and package

- Production Lua must remain compatible with BeamNG.drive 0.39 and the Lua 5.1 fixture runner.
- The HUD App is a native Vue 3 Runtime UI app. Runtime code must not use CDNs, remote assets, `node_modules`, source maps, or raw Sass.
- Release compatibility targets BeamNG 0.39.4; 0.39.2.1 remains historical live-failure evidence and 0.39.3 is the minimum documented Runtime UI baseline.
- Only `lua/`, `ui/`, `settings/`, `locales/` (when present), `mod_info/` (when present), `COMPATIBILITY.json`, `LICENSE`, `NOTICE`, and `VERSION` may enter the mod ZIP.

## Evidence

- Automated tests do not prove live gameplay, visuals, controller input, renderer behavior, language rendering, or performance.
- Test records must distinguish `Automated`, `Executed live`, `Failed`, `Pending`, and `Not applicable`. Missing evidence is never a pass.
- Never claim D3D11, D3D12, Vulkan, UI scale, safe-zone, controller, or gameplay approval without evidence from the exact published ZIP.

## Runtime architecture

- Every operation has an `operationId`, domain, generation, phase sequence, cancellation state, deadline, and explicit ownership.
- Deferred callbacks must prove current operation, generation, phase/callback token, expected vehicle, and Race slot before causing side effects.
- Cleanup may remove only a vehicle whose current operation ownership is proven. Race cleanup additionally proves slot ownership.
- Full Random owns at most one unaccepted temporary vehicle at a time. Race owns at most one candidate per slot.
- Scramble never spawns or replaces a vehicle. Random Car uses its dedicated selection/spawn/bind/accept path, not Full Random mutation passes.
- The player vehicle is never a Race AI staging target or fallback. Each Race slot has exclusive physical ownership.
- Safety uses `VALID`, `INVALID_CONFIRMED`, and `UNKNOWN_OR_PENDING`; only confirmed invalid evidence may start destructive rollback.
- Visible protocol state uses stable codes and normalized structures. Translation belongs to the frontend, and one component failure must not unmount the HUD shell.

## Runtime UI

- Do not add native HTML `<select>` controls. Use the shared `ScrSelect` adapter backed by BeamNG's supported `BngSmartSelect`.
- Selection controls must support mouse, keyboard, scoped UINav/controller navigation, Back/Escape, disabled options, focus visibility, scrolling, scale, and safe zones.
- Technical IDs and internal policy keys stay in explicit diagnostics/developer disclosure, not the normal flow.
- Compact mode changes content and internal geometry for every tab. The 0.39.4 AppHost owns persisted outer placement; do not call private resizing APIs.
- Transient statuses expire and remain scoped. Overall progress is structured, translated, and monotonic.

## Version, legal, and documentation

- `VERSION` is the canonical current version; derived metadata is validated against it. Historical version references are not bulk-replaced.
- `LICENSE` is the legal source of truth (Apache-2.0). README is a stable entry point, CHANGELOG/releases hold history, and ROADMAP contains future work only.
- Architecture documentation is organized by system. The broad `main.lua` and `apiAdapter.lua` decomposition remains v0.8.0 debt.

## Validation and release

Run from the repository root:

```text
npm ci --ignore-scripts
npm run validate:sfc
npm run validate:graph
npm run validate:styles
npm run test:ui
python -m unittest discover -s tests -v
python tools/package_mod.py
python tools/validate_package.py
python tools/validate_release_gate.py --channel prerelease
```

Publish only the deterministic ZIP, its `.zip.sha256`, and its manifest. Never use GitHub's source archive as the mod package.
