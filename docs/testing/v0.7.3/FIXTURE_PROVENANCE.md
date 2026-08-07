# v0.7.3 fixture provenance

`tests/fixtures/v0.7.3/beamng-0.39.4.json` is a small synthetic dataset shaped
from public contracts inspected in the locally installed BeamNG 0.39.4.0 build,
the official 0.39–0.39.3 release notes, and this project's historical failure
reports. Names, keys, paths, IDs, hardware, and values are invented or reduced.
It contains no copied vehicle definition, proprietary mesh, texture, or full
official registry record.

The fixture covers registry warming/ready states; unequal key/display/file
identity; families/subgroups; mutable official metadata; a managed map; missing
slot type; incomplete mod configuration; missing and empty JBeam descriptions;
instability, refused spawn, missing callback, divergent player identity, and
recycled ID; resource classification; and managed AI `driveInLane` transitions.

Lua consumes stable regression markers through the BeamNG-console staging path;
JavaScript parses UI-relevant shapes; Python validates complete semantic
relationships. Fixed seed `v073-sanitized-regression` makes failures
reproducible. The fixture is not evidence of live vehicle or renderer behavior.
