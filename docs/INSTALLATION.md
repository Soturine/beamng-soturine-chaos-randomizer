# Installation

For v0.7.7 install only `soturine_chaos_randomizer_0.7.7.zip` from the GitHub
prerelease assets, not a GitHub source archive. Verify it with the adjacent
`.zip.sha256`, remove or disable older Randomizer copies, and keep the ZIP
intact in the active BeamNG user folder's `mods` directory.

1. Download the named mod ZIP, `.sha256`, and manifest from the project release.
   Do not use GitHub's automatic source archive.
2. Compute SHA-256 for the ZIP and compare it with the checksum and manifest.
3. Copy the ZIP without extracting it into the active BeamNG user folder's
   `mods` directory.
4. Disable or remove older Randomizer ZIPs so only one version is active.
5. Start BeamNG, enable the mod, enter a level, open **UI Apps**, and add
   Soturine's Chaos Randomizer.
6. Confirm the header version matches `VERSION` inside the downloaded ZIP.

The archive root must contain `lua/`, `ui/`, `settings/`, `locales/`,
`COMPATIBILITY.json`, `LICENSE`, `NOTICE`, and `VERSION`. A wrapper directory,
`node_modules`, tests, docs, source maps, or nested ZIP indicates the wrong
artifact.

For validation, record ZIP filename, bytes, SHA-256, manifest commit, BeamNG
full build, renderer, hardware, user profile, map, traffic, enabled mods, and
locale before the first case. Never replace the tested asset midway through a
report.

If the extension or UI does not appear, follow
[Troubleshooting](TROUBLESHOOTING.md) and preserve relevant `beamng.log` lines
before clearing cache or changing the environment.
