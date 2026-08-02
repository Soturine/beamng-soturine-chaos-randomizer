# v0.7.0 requirements matrix

| ID | Requirement | Evidence | Status |
|---|---|---|---|
| R01 | Work directly on main; no PR/force push | Git history and release checklist | Automated |
| R02 | Preserve v0.6.8 P0 | Production Lua regression suite | Automated |
| R03 | Preserve v0.6.9 P1 | Production Lua regression suite | Automated |
| R04 | One native Vue HUD entry | Manifest/topology/package tests | Automated |
| R05 | No Angular runtime or parallel mount | Forbidden runtime path test | Automated |
| R06 | Honest minimum 0.39 and fallback decision | Compatibility schema 2 and migration doc | Automated |
| R07 | Modular shell/common/feature components | 55-SFC topology and compiler gate | Automated |
| R08 | Nine state/layout stores | Store topology test | Automated |
| R09 | Backend/UI state separation | Store architecture and protocol tests | Automated |
| R10 | Protocol version/state version/domains | Lua and JavaScript protocol tests | Automated |
| R11 | Stale ignore and gap recovery | JavaScript state tests | Automated |
| R12 | Typed allowlisted command bridge | Lua/JavaScript bridge tests | Automated |
| R13 | Payload/argument/depth/element limits | Lua protocol tests | Automated |
| R14 | Structured terminal responses/deduplication | Lua router tests | Automated |
| R15 | Dirty diffs and P1 metrics retained | Publisher and protocol regression tests | Automated |
| R16 | Chaos parity | Matrix, components, fixtures, Lua actions | Automated |
| R17 | Garage/Vehicle DNA parity | Matrix, components, fixtures, Lua DNA suite | Automated |
| R18 | Race Cars parity | Components, fixtures, lineup suite | Automated |
| R19 | Placement parity | Components, fixtures, spawn suite | Automated |
| R20 | Drive/AI parity | Components, fixtures, AI suite | Automated |
| R21 | Complete Race Policy | 21-field static/Lua preference checks | Automated |
| R22 | Settings parity/schema 9 | Components and migration tests | Automated |
| R23 | Tab-specific compact summaries | AppShell and fixture assertions | Automated |
| R24 | Per-tab Details state | UI layout store/component assertions | Automated |
| R25 | Responsive host behavior | CSS/composable/layout assertions | Automated |
| R26 | en-US and pt-BR | Catalog parity and runtime assertions | Automated |
| R27 | Fallback/interpolation/plural/numbers | JavaScript i18n assertions | Automated |
| R28 | Translation-independent technical data | Static/Lua deterministic assertions | Automated |
| R29 | Keyboard/controller/UINav semantics | Component/static checks | Automated |
| R30 | Focus/dialog/reduced motion/high contrast | Component/CSS checks | Automated |
| R31 | 100 layout cycles | JavaScript runtime test | Automated |
| R32 | 100 mount/cleanup registry cycles | JavaScript runtime test | Automated |
| R33 | No unsafe HTML/eval/CDN/remote assets | Source/package security gate | Automated |
| R34 | Import data is parsed and bounded | Component/bridge/static tests | Automated |
| R35 | Deterministic source-only SFC validation | Pinned compiler and lockfile | Automated |
| R36 | Deterministic installable ZIP | Package/reproducibility tests | Automated |
| R37 | Checksum and manifest | Package/release validation | Automated |
| R38 | No node_modules/cache/maps/local paths in ZIP | Package gate | Automated |
| R39 | Required documentation | Static documentation test | Automated |
| R40 | Visual screenshots | Live plan V/D/C/G/R/L cases | Pending |
| R41 | Real controller and CEF focus | Live plan I cases | Pending |
| R42 | Live performance comparison | Live plan P cases | Pending |
| R43 | Post-v0.7.0 audit plan only | POST_V070_AUDIT_PLAN | Automated |

Automated means the stated source/harness evidence passed; it does not mean the
corresponding live BeamNG behavior was executed.

Live BeamNG 0.39 validation: Pending owner validation
