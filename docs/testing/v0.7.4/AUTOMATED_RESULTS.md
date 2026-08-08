# v0.7.4 automated results

Source, documentation, and release-candidate gates: **Passed** at commit
`0ed56b9bf989fbe3a5447de33ec8211ab82a62ca` on 2026-08-08. No failing gate was
waived. The release manifest binds the ZIP to the exact checkout used to build
it; the final evidence-only commit is rebuilt and revalidated before tagging.

Environment: Windows 10 19045, PowerShell, Node 24-compatible toolchain, Python
3, and the installed BeamNG 0.39.4.0 console as the Lua 5.1-compatible fixture
runner.

| Command | Exit code | Duration | Cases/assertions | Result | Commit tested | Notes |
| --- | ---: | ---: | --- | --- | --- | --- |
| `npm ci --ignore-scripts` | 0 | 4.196 s | 171 packages installed; 172 audited | Passed | `0ed56b9` | npm reported one high-severity development dependency advisory; `npm audit --omit=dev` reported 0 runtime vulnerabilities |
| `npm run validate:version` | 0 | 0.766 s | 7 derived metadata locations | Passed | `0ed56b9` | `VERSION_SYNC_OK 0.7.4` |
| `npm run validate:sfc` | 0 | 2.742 s | 57 Vue SFC files | Passed | `0ed56b9` | All compiled |
| `npm run validate:graph` | 0 | 0.942 s | 85 files, 234 imports, 182 project imports | Passed | `0ed56b9` | 0 missing/case/cycle/export errors |
| `npm run validate:styles` | 0 | 0.737 s | 81 source files, 57 Vue files, 1 runtime CSS | Passed | `0ed56b9` | 0 remote/SCSS/map/missing/critical errors |
| `npm run test:ui` | 0 | 27.611 s | 929 pure checks + 15 mounted tests | Passed | `0ed56b9` | Tab p95 13.559 ms; button p95 10.713 ms; synthetic only |
| `python -m unittest discover -s tests -v` | 0 | 22.636 s | 63 methods | Passed | `0ed56b9` | Includes Lua, package, static, graph/style, fixtures, and UI bridge coverage |
| Current Lua fixture via `tools.lua_metrics.run_lua_suite` | 0 | 4.472 s | 415 cases; 10,659 assertions; 739 mappings | Passed | `0ed56b9` | BeamNG 0.39.4.0 Lua 5.1-compatible runner |
| `python tools/package_mod.py` | 0 | 5.677 s | 201 ZIP entries | Passed | `0ed56b9` | 480,381 bytes; ZIP, checksum, manifest generated |
| Two independent `package_mod.py --output-dir …` builds | 0 | 11.1 s | 2 builds × 201 entries | Passed | `0ed56b9` | Bytes, SHA-256, ordered entry names, sizes, compressed sizes, and timestamps equal |
| `python tools/validate_package.py` | 0 | 1.439 s | 201 entries + extracted graph/style/rebuild | Passed | `0ed56b9` | Structure, metadata, checksum, forbidden content, version/legal/locales validated |
| `python tools/validate_release_gate.py --channel prerelease` | 0 | 0.343 s | 0 executed / 48 pending live cases | Passed | `0ed56b9` | Live status remained Pending owner validation |

Candidate package identity at this evidence point:

| Field | Value |
| --- | --- |
| File | `soturine_chaos_randomizer_0.7.4.zip` |
| Entries | 201 |
| Bytes | 480,381 |
| SHA-256 | `0d153aa421ab68c5ad87bec8882459f51e3271c8da6a14dd20a46997f80cdb9a` |
| Manifest version | 3 |
| Manifest commit | `0ed56b9bf989fbe3a5447de33ec8211ab82a62ca` |
| Reproducibility | Passed across two independent builds |

## Corrected intermediate failure

After changing canonical `VERSION` to 0.7.4, the first targeted package-test run
failed because a historical Lua UI-topology assertion still required the literal
app version `0.7.3`. The assertion was changed to require a semantic version
instead of a stale release value. A first attempt to read repository `VERSION`
inside the isolated Lua fixture also failed because that fixture intentionally
copies only runtime/test roots. The final semantic-version assertion then passed,
and the Lua suite, package test, full 63-method suite, package validator, and
prerelease gate were all rerun successfully.

Automated validation does not prove gameplay, visuals, AppHost placement,
controller input, renderer behavior, UI scale/safe zones, third-party content,
FPS, or memory. Live BeamNG 0.39.4 validation remains **Pending owner
validation**.
