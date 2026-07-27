# Automated test report — 0.6.4

Status: **complete for candidate source; live validation remains separate**.

Commands:

```text
python -m pytest -q
node tests/js/ui_math.test.js
node --check ui/modules/apps/soturineChaosRandomizer/app.js
python tools/package_mod.py
python tools/validate_package.py
python tools/validate_release_gate.py --channel prerelease
```

| Category | Executed | Passed | Failed | Pending/blocked |
| --- | ---: | ---: | ---: | ---: |
| Behavioral + mocked BeamNG Lua cases | 356 | 356 | 0 | 0 |
| Lua assertions evaluated | 7,764 | 7,764 | 0 | 0 |
| Static/Lua/JS/package/workflow Python methods | 59 | 59 | 0 | 0 |
| Python unittest subtests | 841 | 841 | 0 | 0 |
| JavaScript helper assertions | 27 | 27 | 0 | 0 |
| Requirement mappings | 440 mapped | 440 mapped | 0 unmapped | not executions |
| Live BeamNG cases | 0 | 0 | 0 | 110 Pending |

The Lua suite runs actual production modules through a Lua 5.1-compatible
BeamNG console when no standalone interpreter is available. Its adapter/world
state is mocked. Counts are distinct: Python methods, unittest subtests, unique
Lua functions, Lua assertions, JS assertions, mappings, parsed files, and live
cases are not summed into a misleading single total.

New v0.6.4 coverage includes fresh-player/stale-manager evidence, no-callback
Random Car/Full Random/Scramble, late/duplicate callbacks, concrete rebind,
uncertain and unreadable fuel, multi-tank policy, optional/mod/core missing
parts, persistent unreadable trees with result preservation, terminal outcome
classification, Settings↔Chaos cycles, external resize debounce, collapsed
mode, and slider values 1/99.
