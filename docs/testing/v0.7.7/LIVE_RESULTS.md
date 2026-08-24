# v0.7.7 live results

Authoritative status: **Owner-observed failures recorded; the remaining plan is pending**.

The repository owner exercised the v0.7.7 published ZIP in BeamNG.drive
0.39.4.0. The observations below are real live evidence, but they do not
constitute a completed A-K validation pass.

| Field | Value |
| --- | --- |
| Release version | 0.7.7 |
| Validation owner | repository owner |
| BeamNG build observed | 0.39.4.0 |
| Required artifact | exact ZIP downloaded from the GitHub v0.7.7 prerelease |
| Release URL | `https://github.com/Soturine/beamng-soturine-chaos-randomizer/releases/tag/v0.7.7` |
| ZIP | `soturine_chaos_randomizer_0.7.7.zip` |
| Bytes | 1427722 |
| Entries | 209 |
| SHA-256 | `466e01b616330c3c923836cb325a1fdc6c880bfaf410ceb046bad1e55edee475` |
| Package/tag commit | `b85780f79dfc323db3ee6cf675e8b150fce3c211` |

| Result | Count |
| --- | ---: |
| Executed | 2 |
| Passed | 0 |
| Failed | 2 |
| Pending | 9 |
| Blocked | 0 |

| Case | Status |
| --- | --- |
| A - Garage Compare | Pending owner validation |
| B - blank/explicit seed | Pending owner validation |
| C - generation cleanup | Pending owner validation |
| D - managed Regenerate | Pending owner validation |
| E - Balanced | Pending owner validation |
| F - Mods Showcase no-mod preflight | Pending owner validation |
| G - Maximum Chaos capability axes | Pending owner validation |
| H - formation without renderer | Failed - partially executed; Formation raised `((intermediate value) || []).filter is not a function`, Preview returned `position_blocked` on a wide flat Gridmap area, and generation returned `lineup_staging_unsafe` before placement could complete. |
| I - canonical order | Pending owner validation |
| J - Details and recovery | Pending owner validation |
| K - UI/i18n/compatibility | Failed - partially executed; excessive empty black area remained in expanded tabs and long status content overflowed/crushed at narrow geometry. Other K branches remain unexecuted. |

## Owner-observed failure evidence

| Path exercised | Observation | Classification |
| --- | --- | --- |
| Expanded and narrow Runtime UI | Severe dead space below short tab content; long error/status content was squeezed beside actions. | Live failed observation, counted in K. |
| Events > Formation | Component error in scope `race:formation`: `((intermediate value) || []).filter is not a function`. | Live failed observation, counted in H. |
| Events > Visualize generation | `position_blocked`; backend message reported that Race generation preview was unavailable even on a wide flat Gridmap area. | Live failed observation, counted in H. |
| Events > Generate cars | Repeated `lineup_staging_unsafe`; generation stopped before a usable lineup existed. | Live failed observation, counted in H; downstream placement/AI checks were blocked within that partial execution. |

Cases A-G, I and J were not completed and remain Pending owner validation.
No v0.7.7 case is marked Passed. Renderer visibility, controller/UINav,
UI-scale, safe-zone, full three-language rendering, third-party vehicles, AI
behavior and performance remain unapproved. Automated and publication checks
do not change these live counts.

## Published-asset verification

On 2026-08-14 UTC, the three GitHub prerelease assets were downloaded into a
fresh temporary directory. The downloaded ZIP matched checksum, manifest,
GitHub digest and local candidate, then passed package validation with version
0.7.7, 209 entries and 1,427,722 bytes. Workflow
[31759678653](https://github.com/Soturine/beamng-soturine-chaos-randomizer/actions/runs/31759678653)
passed. See `POST_RELEASE_VERIFICATION.md` for the complete checklist.
