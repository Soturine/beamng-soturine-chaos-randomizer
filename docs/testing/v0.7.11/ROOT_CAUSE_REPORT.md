# v0.7.11 root cause report

Source evidence: the owner's v0.7.10 live session (BeamNG.drive 0.39.4.0.20972,
Direct3D 11, Gridmap V2), screenshots, and the session's `beamng.log`. The world
renderer was confirmed live; nothing here re-opens the v0.7.10 `ColorF` fix.

## 1. Preview stayed where it was calculated

**Cause.** A data-model limit, not a renderer bug. `racePreview` stored
absolute world positions and cached one draw list "once per preview change";
`onPreRender` redrew exactly those coordinates, so moving or turning the car
could never move the markers.

**Fix.** Slots are stored as offsets in the anchor frame they were planned in
(longitudinal, lateral, vertical, heading). Each frame reads the live player or
camera frame (one object/camera read) and transforms the cached draw list in
place. Custom origins stay fixed, camera anchors keep ground height, the player
marker follows the car, and a missing anchor draws nothing with
`preview_anchor_unavailable`. The full planner (raycasts, occupancy, collision)
runs only on option changes, after 8 m / 20° of drift (at most once a second),
and when generation or placement completes — never per frame. Position All
always plans fresh from the current world.

## 2. The app became a black rectangle

**Evidence.** Header, tabs and content disappeared together; the app stopped
responding; world markers stayed visible (Lua kept running). The game log
recorded no Lua error and no `[MOD] Component error`, which the game's own
mod wrapper logs when a Vue error escapes an app, and our root `ErrorBoundary`
would have shown text rather than nothing.

**Most probable cause (not reproduced live).** The shell containers
(`.scr-app`, `.scr-normal-layout`) were `overflow: hidden`. Browsers still
scroll such boxes programmatically when focus or `scrollIntoView` targets an
element outside the visible area. The v0.7.10 staging preview button was bound
to `:disabled="!options.previewEnabled || core.busy"`, so toggling the preview
disabled the focused control and the game's scoped UI navigation moved focus.
If that shifts the shell, the header, tabs and body slide out and only the
near-black shell background remains inside the orange border; a hidden-overflow
box cannot be scrolled back by the user, so the app looks dead.

**Also found.** `onPreRender` called `publishState()` — the full public state
(Garage, DNA, settings, diagnostics, Race projection) plus a UI emit — from
inside the render callback on every preview transition. It is not proven to
be the blackout cause, but it was excessive work in the render hook and
re-rendered the whole UI from a render callback.

**Fix.** The shell is `overflow: clip` (Chromium 148 in this CEF), which is not
a scroll container at all, with `hidden` as fallback and a scroll guard.
`onPreRender` only flags transitions; `onUpdate` publishes a minimal Race diff
containing only the serializable preview snapshot. A failure while applying
incoming state now shows a recoverable root panel (Reload panel / Copy
diagnostic) instead of an empty app. The owner retest decides whether the black
screen is gone; it is not claimed as fixed live.

## 3. Two previews, the useful one hidden

**Cause.** The generation staging preview (`kind = staging`) lived in Setup →
Advanced options, while the Formation preview (`kind = finalGrid`) shared the
Position All gate (`canPlace`) and was disabled with 0 NPCs. `CompetitorList`
always rendered an empty-state card (`min-height: 90px`) that pushed Advanced
options down. Both previews shared one `runtime.racePreview`.

**Fix.** One user-facing Show/Hide preview in Formation, available before
generation (configured opponent count, estimated bounds) and refreshed on option
changes; `canPreview` and `canPlace` are separate. Staging is internal again
(`previewRaceGeneration` and the `previewEnabled` preference were removed);
its origin settings remain under Advanced as a technical option. The empty
competitor card is gone, origin labels are short with helper text, and leaving
Events clears the preview.

## Weight

No new module. Files touched are the existing preview, frame, placement and
Events ones. One command and one preference were removed; the render hook does
less work than in v0.7.10.
