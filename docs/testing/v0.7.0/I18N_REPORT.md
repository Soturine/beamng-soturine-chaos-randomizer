# v0.7.0 i18n report

Automated status: **Passed**. Live language-switch/clipping status: **Blocked by module graph failure**.

The en-US and pt-BR catalogs have identical key sets with more than 200 keys.
Automated assertions cover locale normalization, English fallback, missing key
visibility, safe interpolation, singular/plural competitor labels,
locale-aware numbers, long Brazilian Portuguese strings, and absence of HTML.

Technical model/config/part IDs, seeds, generator versions, state versions,
operation IDs, Race Policy fields, and deterministic ordering are not
translated.

Live BeamNG 0.39 validation: Failed before mount; i18n cases blocked
