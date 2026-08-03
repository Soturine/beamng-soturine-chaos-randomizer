# v0.7.2 — Live Rescue: Runtime UI, Full Random and Race Stability

Status: **Experimental prerelease — live validation pending owner test**.

## Highlights

- packaged pure CSS with source/ZIP/download style graph validation;
- compact v0.6.9-inspired visual hierarchy in native Vue;
- real mounted Vue lifecycle, diff, resize, and latency tests;
- single-concrete-target Random Car and Full Random transactions;
- same-concrete-target Scramble without spawn or replacement;
- independent Race slot targets, seeds, ownership, clocks, and cleanup;
- bounded retries, scheduler, watchdog, and stale-callback handling;
- complete Spanish catalog and automatic BeamNG locale mapping.

## Known history

- v0.6.9: visual reference; live gameplay failed.
- v0.7.0: Vue module graph failed before mount.
- v0.7.1: module graph fixed and Vue mounted; live UI/gameplay failed.

## Validation

Automated validation: Passed

Live BeamNG validation: Pending owner validation

Live cases: 0 executed / 0 passed / 0 failed / 138 pending / 0 blocked

Automated validation does not establish live rendering, gameplay, FPS, input,
cleanup, or stability. The repository owner must execute the live plan against
the downloaded assets before any stronger claim.
