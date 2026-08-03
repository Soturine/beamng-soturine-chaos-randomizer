# v0.7.1 Vue module graph report

## Runtime contract inspected

The BeamNG 0.39 native Runtime UI loader resolves the module URL it is given;
it does not provide bundler-style directory-to-`index.js` inference. Installed
native HUD apps use explicit `.vue` paths for local SFC imports, and inspected
local JavaScript imports use `.js`. Runtime aliases such as `@/services` remain
host-owned and are intentionally unchanged.

The v0.7.0 failure was reproduced statically: extensionless store-barrel and
local JavaScript specifiers formed invalid Runtime UI URLs. All project-local
imports now name the actual file and extension. The store barrel is addressed
as `stores/index.js`, and the SCSS entry names `app.scss` explicitly.

## Before and after

| Metric | v0.7.0 graph | v0.7.1 graph |
|---|---:|---:|
| Files scanned | 78 | 78 |
| Reachable files | 52 | 74 |
| Import references scanned | 193 | 193 |
| Runtime alias imports | 11 | 11 |
| Vue package imports | 28 | 28 |
| Project imports | 154 | 154 |
| Directory imports | 44 | 0 |
| Missing modules | 74 | 0 |
| Case mismatches | 0 | 0 |
| Initialization cycles | 0 | 0 |
| Named-export errors | 0 | 0 |
| Extracted-ZIP missing modules | Not measured | 0 |

The corrected 154 project imports comprise 78 `.vue`, 73 `.js`, 2 `.json`,
and 1 `.scss` references. There are no dynamic imports or re-exports in the
application graph.

## Validator coverage

`tools/validate_vue_module_graph.mjs` scans Vue `<script>` and `<script setup>`
blocks, JavaScript imports/re-exports/dynamic imports, and SCSS module
references. It resolves project paths case-sensitively even on Windows, checks
explicit extensions, detects missing modules, directory imports, initialization
cycles, and statically verifiable named-export mismatches.

Positive checks pass against both the source tree and an extracted release ZIP.
Negative fixtures prove that directory imports, wrong casing, missing modules,
and named-export mismatches fail validation.

This report proves graph integrity; a live AppHost mount remains Pending owner
validation.
