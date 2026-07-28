# Soturine's Chaos Randomizer 0.6.7

Status: **Experimental prerelease**.

Version 0.6.7 is published for owner validation of the operation-isolation,
Race lifecycle, safety, cardinality, and responsive-UI changes below. Automated
checks pass, but no live BeamNG world was executed in this workspace.

Automated validation: Passed

Live BeamNG validation: Pending owner validation

Live cases: 0 executed / 0 passed / 0 failed / 48 pending / 0 blocked

## Highlights

- Complete state separation between Chaos, Race, and Garage operations.
- Generation-bound callback tokens reject delayed cross-domain callbacks.
- Owned, unaccepted orphan candidates are reaped without touching external cars.
- Logical targets bind to concrete BeamNG IDs only after coherent evidence.
- Random Car and Full Random enforce one accepted replacement; Scramble keeps
  the same controlled vehicle; rollback is idempotent.
- Every Race competitor has independent selection, mutation, placement, and
  retry seeds, plus an explicit slot lifecycle.
- Vehicle safety uses `VALID`, `INVALID_CONFIRMED`, or `UNKNOWN_OR_PENDING`;
  unavailable oil/fuel/metadata evidence is not fabricated into invalidity.
- Invalid configurations enter session/domain quarantine and cannot create an
  unbounded retry loop.
- Race supports Player participates and Spectator / camera only with visible
  total-vehicle and AI-opponent semantics.
- Placement has preview-before-confirm, dynamic formations, vehicle-dimension
  spacing, narrow-area fallback, safe ground checks, and retained-ID movement.
- The complete Race policy remains available, persisted, preset-aware, and
  included in lineup export/import.
- Race competitor cards use a bounded internal list with Retry, Fallback, Skip,
  Remove, and relevant ordering controls.
- Chaos, Garage, Race, and Settings each have their own compact layout and size.
  Closing Details restores the tab's prior height without cumulative growth.

## Validation

- Python: 64 test methods; 966 reported subtests in the final local suite.
- Lua: 375 unique executed cases and 531 requirement mappings.
- JavaScript: syntax validation plus 49 UI math/state checks, including 50-cycle
  tab, compact/expanded, and Details restoration loops.
- Packaging: deterministic ZIP, SHA-256, named manifest, layout, version,
  checksum, reproducibility, and experimental-prerelease gate.

These results are automated evidence, not proof of rendering, physics,
performance, or third-party compatibility in a running BeamNG world.

## Known status

This is a non-draft prerelease awaiting live owner validation. The 48 cases in
the versioned plan remain Pending. Bugs must not be described as live-resolved
until the repository owner executes the exact downloaded ZIP and records the
results.

## Assets

- `soturine_chaos_randomizer_0.6.7.zip`
- `soturine_chaos_randomizer_0.6.7.zip.sha256`
- `soturine_chaos_randomizer_0.6.7.manifest.json`

Install the attached ZIP, not GitHub's automatic source archive. Verify the
SHA-256 before testing and keep only one Randomizer version enabled.
