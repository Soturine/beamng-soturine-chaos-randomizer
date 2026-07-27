# UI validation — 0.6.4

## Sizing policy

The previous code inferred manual resizing whenever host height differed from
the last programmatic height, then used `max(content, manualHeight)`. Layout and
host feedback could therefore promote Settings height into a permanent floor.

v0.6.4 uses explicit state:

- `auto`: exact measured header + navigation + current rendered body + frame,
  clamped to viewport limits;
- `user`: an external resize older than the 120 ms programmatic debounce stores
  the user's height;
- `collapsed`: compact content always wins without erasing a saved user height.

Programmatic broadcasts carry `source: content` and are ignored as user input.
The MutationObserver and tab action schedule one measurement 16 ms later so
Angular has rendered the new `ng-if` body. A one-pixel tolerance avoids churn.

## Automated cases

| Case | Result |
| --- | --- |
| Settings content resolves to 580 px; Chaos resolves back to 320 px | Passed |
| 20 alternating Settings/Chaos cycles have no drift | Passed |
| External resize after debounce enters user mode | Passed |
| Programmatic/content and near-synchronous external echoes stay auto | Passed |
| One-pixel host difference does not enter user mode | Passed |
| User height is retained in expanded mode | Passed |
| Collapsed mode ignores user height and resolves to compact content | Passed |
| Slider fill values 0, 1, 50, 99, and 100 are exact | Passed |
| Range track remains transparent beneath real orange fill | Passed |

Real BeamNG CEF layout, DPI, controller, mouse/touch, font metrics, viewport
limits, and repeated tab/collapse behavior remain Pending in U01–U25.

## Fox and selector icon

`assets/fox-mark.svg` is an original local flat illustration with cream badge,
orange/dark ears, friendly highlighted eyes, muzzle, smile, and cheeks. The
250×120 `assets/app-icon.svg` repeats the same shapes and is deterministically
rendered to `app.png`. Static tests parse both SVGs, reject scripts/images/
filters/external/base64 content, verify shared palette, enforce the selector
viewBox, and validate the PNG dimensions. Visual inspection confirms the PNG
contains the fox and Chaos wordmark. In-game header/selector appearance is
Pending U26–U30.

## Slider

The native WebKit range track is transparent. A separate `.scr-slider-fill`
overlay uses the exact clamped percentage and orange palette; the native thumb
remains keyboard/mouse/touch interactive above it. No CSS variable or padding
offset is used, avoiding the old endpoint mismatch.
