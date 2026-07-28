# Owner test checklist — v0.6.6

- [ ] Verify the downloaded/local ZIP filename, bytes and SHA-256 against the report.
- [ ] Confirm only this Randomizer ZIP is enabled and header says `0.6.6`.
- [ ] Run the clean-profile setup in [LIVE_TEST_PLAN.md](LIVE_TEST_PLAN.md).
- [ ] Execute 20 Random Car, 20 Scramble and 20 Full Random cases with the stated Chaos rotation.
- [ ] Cover official, mod, configuration-pack, combustion, EV, hybrid, trailer and explicit shell content.
- [ ] Confirm no pause/unpause dependency, freeze, false cosmetic rollback, unexpected stock restore, zero oil or disabled combustion result.
- [ ] Execute C-RV-01…08 and verify repair retains unrelated chaos changes.
- [ ] Generate and inspect 4 independent Race vehicles with unique IDs.
- [ ] Reorder and place all four; verify Placement moves rather than duplicates them.
- [ ] Exercise Start/Pause/Resume/Stop/Reset all.
- [ ] Generate, inspect and place 8 independent vehicles.
- [ ] Exercise failure, retry, fallback, skip, cancellation during slot 2, and partial lineup.
- [ ] Inspect the fox at 24/32/48 and 250×120 and retest responsive tab sizing/controller focus.
- [ ] Verify BeamLR/Driver Assistance warnings only when safely detected and that neither mod is disabled.
- [ ] Attach diagnostics and `beamng.log` for every failure.
- [ ] Update `LIVE_TEST_REPORT.md` with real results; do not describe any required case as Passed while it is Pending, Failed or Blocked.
