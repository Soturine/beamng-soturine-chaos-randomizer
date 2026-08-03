# Native Vue visual baseline from v0.6.9

Version 0.6.9 is a historical visual reference only. Its live visual pass does
not approve its Full Random, Race, or stability behavior.

The v0.7.2 Vue app preserves the useful hierarchy rather than copying the old
Angular implementation: orange compact header, small fox mark, dark layered
cards, clear active tabs, real styled buttons, readable status colors, compact
spacing, and internal scrolling instead of overflowing the HUD host.

## Required visual states

| View | Top | Middle | Bottom | Details |
| --- | --- | --- | --- | --- |
| Chaos | header, tabs, action status | Random Car/Scramble/Full Random and controls | progress/result/diagnostics | closed and open |
| Garage | header, tabs, toolbar | grid/list DNA cards | paging/import/export | closed and open |
| Race Cars | header, tabs, stepper | independent competitor cards | generation controls/status | closed and open |
| Race Policy | stepper and policy heading | policy groups/cards | acceptance and retry controls | closed and open |
| Settings | header, tabs, language | content/safety/performance | persistence/compatibility | closed and open |

Compact and expanded variants must keep the fox visually subordinate to the
title. Buttons, tabs, cards, focus rings, warnings, progress, disabled states,
and scrollbars are explicit CSS contracts. Settings and Race Policy use the
application's internal scroll container at short host heights.

Headless visual screenshot tests: Not implemented

Visual equivalence remains Pending owner validation in BeamNG 0.39.2.1.

