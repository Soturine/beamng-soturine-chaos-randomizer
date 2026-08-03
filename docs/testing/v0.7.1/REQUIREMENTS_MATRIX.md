# v0.7.1 requirements matrix

| Requirement | Evidence | Status |
|---|---|---|
| Fix the observed Runtime UI module 404 | Explicit local paths and `stores/index.js` | Automated passed; live pending |
| Reject directory-style local imports | Module graph validator and negative fixture | Passed |
| Reject missing and wrong-case paths cross-platform | Module graph validator and negative fixtures | Passed |
| Check Vue, JavaScript, JSON, and SCSS references | Module graph report | Passed |
| Validate the source graph | `npm run validate:graph` | Passed |
| Validate the extracted ZIP graph | Package validator | Passed |
| Preserve native Vue-only UI | Static and package topology checks | Passed |
| Preserve protocol and compatibility schemas | Protocol 2; compatibility schema 2 | Passed |
| Preserve Vehicle DNA format | Generator 6; schema 1 | Passed |
| Record v0.7.0 live failure honestly | Historical live report | Passed |
| Define v0.7.1 live AppHost gate | 97-case live plan | Pending owner validation |
| Publish three validated release assets | Release checklist | Pending publication |
