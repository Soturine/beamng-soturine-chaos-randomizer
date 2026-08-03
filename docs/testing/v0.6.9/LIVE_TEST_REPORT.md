# Live test report — v0.6.9

Status: **Failed — visual reference only; live gameplay and stability failed**.

| Field | Value |
|---|---|
| Release version | 0.6.9 |
| Validation owner | Repository owner |
| Exact artifact | `soturine_chaos_randomizer_0.6.9.zip` |
| Environment | BeamNG.drive 0.39.2.1, standard D3D12/D3D11 launcher option |

The owner-approved visual reference is compact and proportional, with a small
fox, dark orange/black styling, compact header, styled tabs/buttons, cards,
internal scrolling, usable Settings and Race Policy, organized Garage, and
legible Details. This visual approval is not gameplay approval.

| Case | Result | Evidence |
|---|---|---|
| Visual baseline | Passed | Owner screenshots establish the v0.7.2 visual reference |
| Full Random | Failed | Visible duplicate vehicles, long mutation sequence, cleanup, then a freeze requiring Alt+F4 |
| Race Generate Cars | Failed | Visible truck staging, repeated mutation/clones, removals, and return to the original player vehicle |
| Stability | Failed | The Full Random session froze and required Alt+F4 |
| Random Car | Pending | Not executed separately; risk inherited from the shared Chaos pipeline |
| Scramble | Pending | Not executed separately; risk inherited from the shared Chaos pipeline |

The original 64-case matrix is now classified as follows. Only the four cases
with a clear owner action/result are counted as executed; the two explicitly
unexecuted actions remain pending and the remaining cases were blocked by the
critical gameplay/stability failures.

| Result | Count |
|---|---:|
| Executed | 4 |
| Passed | 1 |
| Failed | 3 |
| Pending | 2 |
| Blocked | 58 |

No claim is made that Random Car or Scramble is safe. v0.6.9 remains a visual
reference and the previous Angular release, not a functionally approved build.
