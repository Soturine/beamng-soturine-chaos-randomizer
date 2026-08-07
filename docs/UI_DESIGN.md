# UI design

The app is a native Runtime UI Vue HUD App with four destinations: **Chaos**,
**Garage**, **Race**, and **Settings**. The backend remains available if a
single view fails.

## Information hierarchy

Primary actions and current outcome appear first. Advanced policy, raw
diagnostics, technical IDs, and uncommon recovery actions use progressive
disclosure. Normal screens use human model, configuration, lock, phase, and
failure labels; paths and internal keys are restricted to developer/details
areas.

## Selection controls

All dropdown behavior goes through `ScrSelect`, a thin adapter over BeamNG's
official `BngSmartSelect`. It accepts primitive or `{value,label}` options,
normalizes values, emits one change, supports disabled/empty states, keyboard
and controller navigation, and lets the host component manage focus and
selected-item scrolling. There are no native HTML `<select>` controls.

## Failure isolation and status

Error boundaries wrap the app, active tab, and failure-prone Race steps. A
boundary keeps the shell/navigation mounted, exposes a localized retry and
copy-diagnostics action, and does not replay a command automatically. Status
records are scoped by view/operation, deduplicated, expiring, and cleared on
supersession or teardown. Backend codes and structured progress are translated
only at presentation time.

## Compact presentation

Compact mode changes body content, spacing, and the app's requested internal
geometry for every tab. Each tab has bounded compact and expanded metrics;
switching tab, locale, Details, or remount recomputes them without accumulating
observers or timers. BeamNG's AppHost owns the outer saved frame, scalable
metrics, alignment, and safe areas. The child app does not call a private host
resize API, so live outer-frame behavior remains an owner validation case.

## Accessibility and input

- Semantic buttons, labels, headings, status regions, and focus-visible styles
  support keyboard use and assistive interpretation.
- UINav/controller direction and Back are delegated through supported Runtime
  UI components and directives.
- An unfocused HUD must not capture steering/gamepad input; interaction mode is
  explicit.
- Layout tolerates UI scale, alignment, localization expansion, and safe zones.
- Color is not the sole signal for busy, warning, failure, or completion.

The automated mounted suite covers boundary failure, every select adapter, 50
compact cycles, 100 mount cycles, locale changes, status lifecycle, focus, and
synthetic local-response latency. Safe areas, host scaling, and real controller
behavior remain **Pending owner validation**.
