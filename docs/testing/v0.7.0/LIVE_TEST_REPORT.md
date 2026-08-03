# v0.7.0 live BeamNG test report

Live BeamNG 0.39 validation: **Failed — Vue module graph could not load**.

The first planned case was executed against the downloaded v0.7.0 release ZIP.
The Runtime UI loader returned:

`404 /ui/modules/apps/soturineChaosRandomizer/stores`

The HUD did not mount, so the remaining 81 cases were blocked and no gameplay,
physics, rendering, controller, accessibility, representative-mod, memory, or
performance conclusion was possible.

| Result | Count |
|---|---:|
| Executed | 1 |
| Passed | 0 |
| Failed | 1 |
| Pending | 0 |
| Blocked | 81 |

This is retained as historical evidence. The import-resolution correction and
its source/ZIP graph evidence belong to v0.7.1.
