# v0.6.3 validation workspace

This directory separates implementation evidence from live BeamNG evidence for
the experimental 0.6.3 candidate.

## Baseline

- Baseline commit: `6907473205decf71433a24d72075358011e0da24`
- Preserved tag: annotated `v0.6.2`, resolving to the baseline commit
- Baseline target: BeamNG.drive `0.38.6.0.19963`
- Settings schema: `6`
- Vehicle DNA schema: `1`
- Baseline automated host run: 50 of 50 host tests passed
- Nested behavioral Lua run: 319 of 319 unique cases passed, with 4,031
  assertions and 440 requirement mappings
- Live BeamNG status for 0.6.3: not executed

Passing host tests are not evidence that gameplay, rendering, physics, CEF
layout, or compatibility with installed vehicle mods works in BeamNG.

## Reproduced v0.6.2 regressions

The following results are owner-provided live observations against 0.6.2 and
are treated as reproduced failures, not pending cases:

| Regression | v0.6.2 result | 0.6.3 acceptance condition |
| --- | --- | --- |
| Random Car / Full Random at 22% | Failed: target identity did not converge without pause/menu interaction | Current player target is discovered coherently and a validated concrete candidate is rebound without pause |
| Scramble at 57% | Failed: parts read-back did not converge without pause/unpause | Reload ownership resets and coherent parts read-back advances on real monotonic time |
| Correct new vehicle restored away | Failed: timeout recovery could restore the previous vehicle after the intended target was visible | A final unbound player read accepts a converged intended result before recovery |
| Recovery loop / persistent old vehicle | Failed | Recovery signatures are bounded and every terminal state clears Busy |
| Empty combustion fuel | Failed | Every identified fuel tank has at least 10% capacity after final tuning and before DNA capture |
| Slider, fox, and Chaos sizing | Failed | Real orange fill, exact 0.6.1 fox, content-measured height, and live DPI checks |

## Evidence policy

- Automated results are reported by category and executed-case count.
- Live cases remain `Pending` until performed in BeamNG with the exact final ZIP.
- The release tag and prerelease are blocked until the live test plan passes.
- An artifact candidate may be produced while that gate remains blocked.

