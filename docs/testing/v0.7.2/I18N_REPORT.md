# v0.7.2 i18n report

Automated status: **279/279 keys present in each catalog**. Live status:
**Pending owner validation**.

| BeamNG locale | Automatic app locale |
| --- | --- |
| `pt`, `pt-BR`, `pt-*` | `pt-BR` |
| `es`, `es-ES`, `es-MX`, `es-*` | `es-ES` |
| `en`, `en-US`, `en-*` | `en-US` |
| unsupported or absent | `en-US` |

Manual override accepts only the three shipped locales. Returning to automatic
mode immediately reapplies the mapped game locale. UI preferences schema 2
persists `localeMode` and `manualLocale`; settings schema remains 9. Locale does
not alter IDs, ordering, seeds, policies, or generated data.

