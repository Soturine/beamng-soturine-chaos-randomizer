# v0.7.1 live BeamNG test report

Live BeamNG 0.39.2.1 validation: **Failed — Runtime UI mounted, but UI and gameplay rescue gates failed**.

Release version: **0.7.1**. Validation owner: **repository owner**.

| Case | Result | Evidence |
|---|---|---|
| Vue mount | Passed | App was discovered and `app.vue` mounted |
| Module graph | Passed | The v0.7.0 `/stores` 404 no longer occurred |
| Automatic pt-BR locale | Passed | Brazilian Portuguese loaded from the BeamNG locale |
| CSS/runtime styling | Failed | Giant fox, default white buttons, raw background, unstyled tabs and missing cards |
| Settings usability | Failed | Content was clipped at the first heading and internal scrolling was unusable |
| Tab/button latency | Failed | Tab and action response accumulated visible delay |
| Full Random | Failed | Concrete target remained unbound; clones/cleanup and stability defects reproduced |
| Race Generate Cars | Failed | Shared/visible staging behavior, incoherent slot results and ownership defects reproduced |
| Game stability | Failed | The session reproduced a freeze requiring termination |

Diagnostics repeatedly showed `Concrete ID unbound · candidates none`, stale
callback counts of 6, 7 and 8, and contradictory Race presentation including
`PARTIAL_READY`, `0 ready`, `1 failed`, and `3 AI opponents`. A Race operation
also presented the wrong-domain text `Chaos Lineup generation finished`.

The nine cases above are the only cases counted as executed. The remaining 88
cases from the published 97-case plan were blocked once the critical CSS,
lifecycle, gameplay, ownership, and stability gates failed.

| Result | Count |
|---|---:|
| Executed | 9 |
| Passed | 3 |
| Failed | 6 |
| Pending | 0 |
| Blocked | 88 |

The module graph correction remains valid evidence. It does not make v0.7.1 a
successful live build; v0.7.2 is the focused rescue candidate.
