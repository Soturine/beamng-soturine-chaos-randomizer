# Automated test report — 0.6.3

Status: **complete for the candidate source; live validation remains separate**.

Commands executed on Windows/Python 3 with Lua 5.1 and Node available:

```text
python -m pytest -q
python tools/lua_metrics.py
node tests/js/ui_math.test.js
node --check ui/modules/apps/soturineChaosRandomizer/app.js
```

| Category | Executed | Passed | Failed | Pending/blocked |
| --- | ---: | ---: | ---: | ---: |
| Behavioral + mocked BeamNG Lua cases | 347 | 347 | 0 | 0 |
| Lua assertions evaluated | 7,897 | 7,897 | 0 | 0 |
| Property/state-machine functions | 4 | 4 | 0 | 0 |
| Static source-contract + architecture Python methods | 39 | 39 | 0 | 0 |
| Lua host-runner Python method | 1 | 1 | 0 | 0 |
| JavaScript helper cases | 17 | 17 | 0 | 0 |
| JavaScript host-wrapper Python method | 1 | 1 | 0 | 0 |
| Package/release Python methods | 13 | 13 | 0 | 0 |
| JSON files parsed | 2 | 2 | 0 | 0 |
| Workflow YAML files parsed | 3 | 3 | 0 | 0 |
| Requirement mappings | 440 mapped | 440 mapped | 0 unmapped | Not independent executions |
| Live BeamNG | 0 | 0 | 0 | 110 Pending |

The host result was **54 passed Python methods plus 808 unittest subtests**.
Property functions are already included among the 347 Lua cases; JSON, YAML,
syntax, and requirement mappings are contracts or observations and are not
added to an invented aggregate “test” count.

No automated result in this document is live BeamNG evidence. See
[LIVE_TEST_REPORT.md](LIVE_TEST_REPORT.md).
