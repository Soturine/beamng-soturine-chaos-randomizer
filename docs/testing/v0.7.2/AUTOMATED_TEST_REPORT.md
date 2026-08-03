# v0.7.2 automated test report

Final release validation runs Python static/architecture/package checks, Lua 5.1
syntax and regression fixtures, JavaScript service checks, real mounted Vue
tests, SFC compilation, source/ZIP module and style graphs, deterministic
packaging, checksum/manifest verification, and the prerelease evidence gate.

Result: **Passed locally before publication**.

| Suite | Result |
| --- | ---: |
| Python test methods | 56 passed |
| Python subtests | 882 passed |
| Lua cases | 403 passed |
| Lua assertions | 9,601 passed |
| Lua requirement mappings | 687 |
| JavaScript service checks | 787 passed |
| Mounted Vue component tests | 7 passed |
| Mounted lifecycle cycles | 100 passed |
| Vue SFC compilation | 55 passed |
| Module graph | 80 files / 197 imports / 0 errors |
| Style graph | 1 runtime CSS / 1 asset / 0 errors |

Artifact hashes are recorded by the generated release manifest and final
release report. This status does not replace the 138-case live matrix.

Required commands:

```text
npm ci --ignore-scripts
npm run validate:sfc
npm run validate:graph
npm run validate:styles
npm run test:ui
python -m unittest discover -s tests -v
python tools/package_mod.py
python tools/validate_package.py
python tools/validate_release_gate.py --channel prerelease
```
