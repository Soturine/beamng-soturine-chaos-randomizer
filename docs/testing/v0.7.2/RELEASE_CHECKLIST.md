# v0.7.2 experimental prerelease checklist

- [x] version identity is 0.7.2; target/minimum are 0.39
- [x] Runtime UI SFC compiles
- [x] source module and style graphs pass
- [x] mounted Vue tests and 100-cycle cleanup pass
- [x] Chaos concrete-target/cardinality regressions pass
- [x] Race 1/4/8/12 slot, partial failure, and cleanup regressions pass
- [x] stale callback, watchdog, retry, and scheduler bounds pass
- [x] `en-US`/`pt-BR`/`es-ES` parity and locale mapping pass
- [x] P0/P1/P2 and determinism regressions pass
- [x] ZIP is deterministic; checksum and manifest validate
- [x] extracted ZIP module and style graphs pass
- [x] live report is honest: 0 executed / 138 pending
- [ ] annotated tag and GitHub prerelease publication (publication step)
- [ ] downloaded release assets revalidated (post-publication step)

Live tests do not block an experimental prerelease and remain Pending owner
validation. Promotion to a validated release is not permitted by this report.

