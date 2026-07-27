# Interactive Test Plan 0.6.1

This is the live BeamNG evidence plan for the Runtime Lifecycle, Race Workflow & Compact UI Hotfix. Automated harness results do not count as gameplay validation. Only a run using the exact v0.6.1 candidate may move a case out of Pending.

Current count: **0 Passed / 0 Failed / 50 Pending / 0 Blocked**.

## Evidence record

For every case record: date/time, tester, OS, BeamNG build, candidate commit, ZIP SHA-256, active mods and versions, map, initial vehicle/config, initial pause state, settings/seed, duration, phase sequence, target ID/model/config, recovery activity, terminal result and Busy release. UI cases also require a new screenshot for this candidate.

Allowed statuses are Passed, Failed, Pending and Blocked. A reproduced problem is Failed; a test that was not run is Pending. Older screenshots and automated tests cannot promote a row.

## Controlled environment A — 30 operations

Use BeamNG 0.38.6 or record the exact build. Enable only v0.6.1; disable older Randomizer versions and `driver_assistance_angelo234`; clear locks; use random-every-run with an empty manual seed.

| IDs | Action | Attempts | Acceptance | Status |
|---|---|---:|---|---|
| A01–A10 | Random Car without pausing | 10 | Each run reaches a terminal result without a pause toggle; seed/model/config/duration recorded; Busy clears. | Pending (10) |
| A11–A20 | Scramble without pausing | 10 | Each run reaches a terminal result; final target is the original vehicle identity; seed/duration/recovery recorded; Busy clears. | Pending (10) |
| A21–A30 | Full Random without pausing | 10 | Each run completes or fails honestly without touching the prior vehicle; seed/model/config/duration/recovery recorded; Busy clears. | Pending (10) |

Each attempt receives its own evidence row in the report, even when several attempts share the same setup.

## Representative mods — 7 cases

Re-enable representative content gradually and record exact mod identity/version.

| ID | Scenario | Acceptance | Status |
|---|---|---|---|
| B01 | Simple mod vehicle | All applicable actions terminate without cross-target writes. | Pending |
| B02 | Mod with controllers | Controllers do not create a pause dependency or unsafe tuning action. | Pending |
| B03 | Mod that changes vehicle ID | The target chain stabilizes on the correct player vehicle. | Pending |
| B04 | Mod with a deep parts tree | Tree convergence is bounded and independent from identity tracking. | Pending |
| B05 | Mod with a broken configuration | Failure/retry/recovery is bounded and Busy clears with a reason. | Pending |
| B06 | Trailer or auxiliary-spawning content | Auxiliary IDs never become the mutation target. | Pending |
| B07 | Automation vehicle | Best-effort result is honest and does not claim unsupported capability. | Pending |

## Recovery-cycle regression — 1 case

| ID | Scenario | Acceptance | Status |
|---|---|---|---|
| C01 | Clean car → randomization → new click | A recovery cannot alternate indefinitely between the same clean and mutated states; the new click has fresh RNG/plans and reaches a terminal result. | Pending |

## Race workflow — 3 cases

All competitors must move from Pending into Selecting/Loading/Randomizing/Verifying and then a terminal Ready/Partial/Failed/Skipped/Cancelled status without requiring pause.

| ID | Scenario | Acceptance | Status |
|---|---|---|---|
| R01 | Balanced, 2 cars | Real Balanced policy is applied; both competitors become terminal. | Pending |
| R02 | Maximum Chaos, 4 cars | Real Maximum Chaos policy is applied; all competitors become terminal. | Pending |
| R03 | Mods Showcase, 4 cars | Mod-focused policy is applied; failures do not contaminate later competitors. | Pending |

## Slider and compact UI — 8 cases

Use the exact candidate UI; record the dragged panel size and display scale. The slider thumb center must align with the useful track endpoints, without clipping or overflow.

| ID | Scenario | Acceptance | Status |
|---|---|---|---|
| U01 | Chaos 0% | Thumb aligns with track start; label aligns. | Pending |
| U02 | Chaos 50% | Thumb is visually centered. | Pending |
| U03 | Chaos 100% | Thumb reaches the track end and is not clipped. | Pending |
| U04 | Collapsed | Height is materially reduced; action/progress/cancel states remain readable. | Pending |
| U05 | Expanded at 340×320 | Chaos needs no normal scroll; four top tabs remain readable. | Pending |
| U06 | 125% scale | No overlap, clipped thumb or essential text below the intended size. | Pending |
| U07 | 150% scale | No overlap, clipped thumb or unusable control. | Pending |
| U08 | 200% scale | Responsive layout remains usable at minimum supported width. | Pending |

## Fox identity — 1 case

| ID | Scenario | Acceptance | Status |
|---|---|---|---|
| F01 | Header fox in expanded and collapsed UI | Visible, subtle, no artifact, does not reduce title legibility or enlarge the panel. | Pending |

## Totals

| Status | Count |
|---|---:|
| Passed | 0 |
| Failed | 0 |
| Pending | 50 |
| Blocked | 0 |
| Total | 50 |
