# v0.7.9 live test plan

Status: **Pending owner validation; not executed**.

Install only the exact ZIP downloaded from the public v0.7.9 experimental
prerelease. Record its filename, bytes and SHA-256 plus BeamNG build, renderer,
map, language, UI scale/safe zone, installed mods and player vehicle. Retain
screenshots/diagnostics with each result. Automated tests cannot satisfy a case.

## Case A - Balanced clean Race

On Gridmap, request four total vehicles with Player participates and Balanced,
then generate. Repeat with at least five lineups/seeds if time permits. Expect
three NPCs or individually explained bounded failures, no candidate leak,
player focus takeover or stale slot, and a concrete cause for every rejection.

## Case B - Maximum Chaos

Generate the same lineup with Maximum Chaos. An undrivable result is allowed
only when reported honestly and must not be used as evidence that AI is broken.

## Case C - Remove/regenerate

Generate a lineup, remove every opponent individually, then generate again.
Expect no `race_cleanup_binding_missing` and no removed slot counted as ready.

## Case D - Single File Ahead

Point the camera away from the participating player, choose Player origin,
Player heading and Single File Ahead, then calculate and position. The formation
must be in front of the car rather than relative to the camera.

## Case E - Single File Behind

Repeat Case D with Single File Behind. The formation must be behind the car.

## Case F - Line

In a flat empty area, calculate and position Line. Expect one straight line,
not an L or a freely deformed arrangement.

## Case G - Side-by-side Grid

Calculate and position Side-by-side Grid. Expect coherent rows/columns without
gratuitous per-slot deformation.

## Case H - explicit Camera origin

Select Camera origin deliberately and recalculate. The formation should now
follow the camera frame while preserving the chosen heading policy.

## Case I - Position All UX

Use one click and approximately time click-to-all-at-target. Record vehicle
count and observed duration, compare qualitatively with v0.7.8, and verify that
structured progress finishes without another successful request. Do not invent
a hardware-independent performance threshold.

## Case J - Preview

Enable Preview and confirm world-space footprints/headings are actually visible.
Capture a screenshot. Calculated data, mock drawing or a reported marker count
without human-visible markers cannot pass this case.

## Case K - Follow

With physically placed, drivable and AI-capable opponents, choose Follow. The
command must be accepted without an error boundary and opponents must physically
begin following the original lineup player.

## Case L - Chase/Flee

Exercise Chase and Flee independently and record accepted/started/failed targets
plus physical behavior.

## Case M - Traffic/Roam

Exercise Traffic and Roam independently and record command/readback evidence and
physical behavior.

## Case N - narrow UI

Resize the App through 320/360/400 px in pt-BR, en-US and es-ES. Open the
Participation selector and verify label/control containment, focus, scrolling
and the full selected label via accessible/title disclosure.

## Case O - repeated click

While Position All is active, click it again quickly. Expect no red error and no
second placement operation; the original transaction must finish or cancel
cleanly.

## Owner live retest - recommended order

1. Balanced generation
2. Remove -> regenerate
3. Single File Ahead with camera rotated
4. Line
5. Grid
6. Position All with one click
7. Visible Preview
8. Follow
9. Chase/Flee
10. Narrow UI
