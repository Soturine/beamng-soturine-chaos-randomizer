# Runtime UI terminology

This policy applies to normal user-facing copy in en-US, pt-BR and es-ES.
Stable codes remain untranslated in diagnostics and protocol payloads; normal
views resolve those codes through the locale catalog.

## Preserved technical terms

Keep these spellings when the concept is technical or part of the product:
`Seed`, `DNA`, `HUD`, `Preview`, `Grid`, `Spawn`, `Reload`, `Fallback`, `ID`,
`Debug`, `Compact`, `Preset`, `Mod`, `Config`, `AI`, `NPC`, `BeamMP`, `AppHost`,
`Runtime UI`, `JBeam`, `Lua`, and `Vue`.

Context around a preserved term is translated. Preferred pt-BR examples are
`Seed do episódio`, `Preview da geração`, `Grid final`, `DNA do veículo`,
`Preset` and `Mod`. Do not substitute `Semente` for `Seed` or `Prévia` for
the product term `Preview`.

## Runtime codes

- Outcomes such as `COMPLETED_WITH_WARNING` are protocol codes. The UI renders
  catalog entries such as “Concluída com aviso de verificação”.
- Phase codes such as `waiting_parts_reload` are technical disclosure only.
  Normal progress uses a human phase label plus translated percentage text.
- Model, config, part, operation and vehicle IDs stay inside Details or an
  explicit “show technical IDs” disclosure.
- Backend English is not a localization fallback for normal notifications.

Catalog parity and the preserved pt-BR terms are automated release gates.
Visual language rendering in BeamNG remains a live test.
