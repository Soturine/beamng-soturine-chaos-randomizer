# Current validation

Current published source: **0.7.2 Experimental rescue prerelease** on `main`.

Automated v0.7.2 status: **Passed locally before publication** for source,
mounted Vue, Lua regression, module/style graph, deterministic package,
checksum, manifest, and prerelease evidence gates. Exact final counts and hashes
are in the release manifest. This evidence is not a live BeamNG result.

Live history:

- v0.6.9: visual pass; Full Random, Race generation, and stability failed.
  Random Car and Scramble were not separately executed.
- v0.7.0: 1 executed / 0 passed / 1 failed / 0 pending / 81 blocked; failed on
  `404 /ui/modules/apps/soturineChaosRandomizer/stores` before Vue mount.
- v0.7.1: 9 executed / 3 passed / 6 failed / 0 pending / 88 blocked. Mount,
  module graph, and pt-BR passed; Runtime CSS/usability, latency, Full Random,
  Race, cleanup, and stability failed.
- v0.7.2: 0 executed / 0 passed / 0 failed / 138 pending / 0 blocked;
  **Pending owner validation**.

Headless visual screenshot tests: Not implemented
