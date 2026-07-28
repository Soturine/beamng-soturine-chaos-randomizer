# Live test plan — v0.6.6

Status: **Pending owner validation; not executed**.

Release asset: `soturine_chaos_randomizer_0.6.6.zip`

All 99 cases begin Pending. Automated tests cannot update this file to Passed.
Record the exact ZIP bytes/SHA-256, BeamNG build, profile, map, mod list, seed,
vehicle IDs, diagnostics, screenshots/video, and `beamng.log` excerpt for every
failure.

## Environment

1. Start a clean BeamNG 0.38.6 profile with no older Randomizer ZIP.
2. First run with BeamLR and `scripts/driver_assistance_angelo234` absent.
3. Install the exact release ZIP without extracting it and verify the header version.
4. Use one stable flat map for baseline runs; record any additional map.
5. Do not pause/unpause to advance an operation and do not suppress Lua errors.

## Case allocation

| IDs | Cases | Count |
| --- | --- | ---: |
| C-RC-01…20 | Random Car | 20 |
| C-SC-01…20 | Scramble | 20 |
| C-FR-01…20 | Full Random | 20 |
| C-RV-01…08 | targeted recovery/repetition checks | 8 |
| R-01…20 | Race/Placement/Drive | 20 |
| U-01…07 | fox and responsive UI | 7 |
| X-01…04 | conflict warnings and diagnostics | 4 |
| **Total** |  | **99** |

## Chaos schedule (60 operations)

Run each action 20 times. For operation numbers 1–5 use Chaos 25, 50, 75, 87,
100; repeat that five-value sequence for 6–10, 11–15, and 16–20. Across each
20-run action block include official vehicles, mod vehicles and mod
configuration packs. Across the complete 60 include combustion, electric,
hybrid, trailer and an explicitly identified intentional shell. Enable the
required content opt-ins only for the trailer/shell cases and record the policy.

For every operation record:

- terminal state and whether Busy cleared;
- initial/logical/final concrete vehicle ID;
- selected classification and baseline type;
- critical and optional missing items;
- oil source/confidence/mass and fuel evidence when applicable;
- stable parts-tree sample count and repair attempts;
- whether the visible randomized result remained after partial/repair;
- any rollback exact functional reason.

Pass requires zero hard freeze, zero pause dependency, zero unexpected return
to stock/previous, zero accepted zero-oil or disabled combustion engine, zero
false fatal cosmetic rollback, and usable buttons after every terminal state.

## Targeted recovery cases (8)

| ID | Procedure | Expected |
| --- | --- | --- |
| C-RV-01 | Protect Critical On + Allow Missing On; remove optional trim | accepted optional absence |
| C-RV-02 | Same settings; force a detectable engine/power-path loss | exact repair before rollback |
| C-RV-03 | Observe repaired result | unrelated parts/tuning/paint remain randomized |
| C-RV-04 | Make repair source unavailable in a controlled fixture/content case | full rollback with exact reason |
| C-RV-05 | Repeat Scramble on the accepted repaired result | last accepted result is the baseline |
| C-RV-06 | Repeat Full Random on the same accepted result | no unexpected original/stock restore |
| C-RV-07 | Combustion oil evidence initializes late | operation waits for stable evidence without sleep/pause |
| C-RV-08 | Oil evidence remains unavailable | honest partial/no safety claim, never fabricated “oil present” |

## Race cases (20)

| ID | Procedure | Expected |
| --- | --- | --- |
| R-01 | Generate 4 | four terminal slots |
| R-02 | Inspect world/IDs after R-01 | four simultaneous unique competitor IDs; player retained |
| R-03 | Open Placement | enabled with retained-count evidence |
| R-04 | Reorder all four | unique positions 1–4 persist |
| R-05 | Place all four | same IDs move; no duplicate spawn |
| R-06 | Start all | commands target managed lineup |
| R-07 | Pause all | all managed AI pauses |
| R-08 | Resume all | all managed AI resumes |
| R-09 | Stop all | all managed AI stops |
| R-10 | Reset all | all managed targets reset safely |
| R-11 | Generate 8 | eight terminal slots |
| R-12 | Inspect world/IDs after R-11 | eight simultaneous unique IDs; no overlap |
| R-13 | Place/reposition all eight | correct IDs and spacing |
| R-14 | Force one failed candidate among four | honest partial retained count |
| R-15 | Retry failed slot | new target generation/context only for that competitor |
| R-16 | Use verified fallback | official fallback is retained or exact failure shown |
| R-17 | Skip failed slot | lineup continues without nonexistent ID |
| R-18 | Cancel during competitor 2 of 4 | active target cleaned; prior retained vehicle preserved |
| R-19 | Accept partial lineup and open Placement | retained accepted subset is usable |
| R-20 | Placement then Start all | Drive targets exactly the positioned managed handles |

## UI and conflict cases

- U-01/U-02/U-03: inspect fox at 24/32/48 px.
- U-04: inspect transparent 250×120 preview.
- U-05: Settings expands, then Chaos shrinks.
- U-06: Garage and Race return to compact height.
- U-07: controller focus, orange slider fill and collapsed state remain usable.
- X-01: clean profile shows no false BeamLR warning.
- X-02: safely detected BeamLR shows a warning and remains enabled.
- X-03: safely detected Driver Assistance path shows a warning and remains enabled.
- X-04: Details/Copy diagnostics contain operation/logical/concrete IDs,
  classification, baseline, missing items, fluids, stability, repair, rollback,
  conflict and terminal evidence.
