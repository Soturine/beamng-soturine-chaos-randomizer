# v0.7.8 live results

Authoritative status: **Executed live by the repository owner; failures observed**.

| Field | Value |
| --- | --- |
| Release version | 0.7.8 |
| Validation owner | repository owner |
| BeamNG build | 0.39.4.0.20972 |
| Renderer | Direct3D 11 |
| Required artifact | exact ZIP downloaded from the GitHub v0.7.8 prerelease |
| Release URL | `https://github.com/Soturine/beamng-soturine-chaos-randomizer/releases/tag/v0.7.8` |
| ZIP | `soturine_chaos_randomizer_0.7.8.zip` |
| Bytes | 1432154 |
| Entries | 210 |
| SHA-256 | `c885b11ecaf1dbb32fc4ab7699f6529b6b431ef0a7a39676f6a82fcd980e8d4c` |
| Package/tag commit | `7316cc78e8d6831e03d073ae21adbb4140cc58a6` |

| Result | Count |
| --- | ---: |
| Executed | 5 |
| Passed | 0 |
| Failed | 5 |
| Pending | 2 |
| Blocked | 0 |

| Case | Status |
| --- | --- |
| A - Scramble observability | Pending owner validation |
| B - UI sizing | Failed - Participation label/control overflow was reproduced at a tested narrow width; the full width matrix was not completed |
| C - Formation | Failed - final placement used camera-relative origin and Line/Grid/Single File geometry did not consistently match the requested formation |
| D - Preview on Gridmap | Failed - placement data was calculated, but no useful world-space markers were visible |
| E - blocked-candidate recovery | Pending owner validation |
| F - Race generation | Failed - Maximum Chaos generated physical competitors, but Balanced rejected observed candidates, removed bindings became stale, and a subsequent lineup failed cleanup |
| G - UI error containment | Failed - `Me siga` raised `command_not_allowed` and reached the Race Behavior error boundary |

The owner also observed partial functionality that must not be lost in the
failure summary: Maximum Chaos could create physical competitors, Move Up/Down
worked, individual Remove physically removed the selected vehicle, and one
placement request continued moving competitors sequentially without requiring
another successful request. None of those observations satisfies a complete
case above.

## Reproduced v0.7.8 defects

| ID | Owner-observed result |
| --- | --- |
| `LIVE-078-AI-PROTOCOL-01` | `startAIQuickPreset` was emitted by Race Behavior but absent from the frontend command registry, producing `command_not_allowed`. AI behavior was not proven end-to-end. |
| `LIVE-078-CLEANUP-01` | After individual removals, slots retained accepted generation status without physical bindings; the next generation failed with `race_cleanup_binding_missing`. |
| `LIVE-078-FORMATION-ORIGIN-01` | Final formations followed the camera frame instead of the participating player vehicle. |
| `LIVE-078-FORMATION-GEOMETRY-01` | Per-slot fallback could deform Line/Grid into an L or another layout that no longer represented the requested geometry. |
| `LIVE-078-POSITION-UX-01` | Placement was serial and insufficiently signalled; repeated clicks could report `spawn_director_busy`. |
| `LIVE-078-POSITION-PERF-01` | Existing-vehicle reposition inherited the spawn/load interval and was visibly slow. |
| `LIVE-078-PREVIEW-01` | Calculated Preview data did not result in owner-visible D3D11 world markers. |
| `LIVE-078-AI-READY-01` | Generated, placed, drivable and AI-ready axes diverged; no live AI movement was proven. |
| `LIVE-078-BALANCED-01` | Balanced rejected observed stable-but-undrivable results under `strict_drivability_policy`; accepting undrivable vehicles is not an allowed fix. |
| `LIVE-078-CUSTOM-01` | Custom was blocked after removal by the cleanup defect; this is not independent proof of a Custom-policy defect. |
| `LIVE-078-UI-OVERFLOW-01` | The Participation selection text escaped or truncated poorly in a narrow AppHost. |
| `LIVE-078-PERF-TELEMETRY-01` | Frame-budget warnings were recorded, but samples also reported external clock stalls and are not accepted as uncontaminated performance benchmarks. |

No v0.7.8 case Passed. D3D12, Vulkan, controller/UINav, the complete UI-scale
and safe-zone matrix, third-party content compatibility, AI movement and
performance approval remain unproven. Automated and publication checks do not
change these live counts.

## Published-asset verification

On 2026-08-24 UTC, all three prerelease assets were downloaded into a fresh
temporary directory. The ZIP, checksum and manifest matched the local tagged
candidate byte-for-byte. The downloaded ZIP passed package validation with
version 0.7.8, 210 entries and 1,432,154 bytes. See
`POST_RELEASE_VERIFICATION.md` for tag, workflow and digest evidence.
