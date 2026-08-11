export const PRODUCT_BRAND = Object.freeze({
  official: "Soturine's Chaos Randomizer",
  short: "Soturine's Chaos",
  subtitle: "Vehicle Randomizer & Playground",
})

export const PRESERVED_TERMS = Object.freeze([
  "Seed", "DNA", "HUD", "Preview", "Grid", "Spawn", "Reload", "Fallback",
  "ID", "Debug", "Compact", "Preset", "Mod", "Config", "Input", "Output",
  "AI", "NPC", "BeamNG", "BeamMP", "AppHost", "Runtime UI", "JBeam", "Lua", "Vue",
])

const FORBIDDEN_LOCALIZATIONS = Object.freeze({
  "pt-BR": [Object.freeze({ pattern: /\bsemente\b/i, preferred: "Seed" }),
    Object.freeze({ pattern: /\bprévia\b/i, preferred: "Preview" })],
  "es-ES": [],
  "en-US": [],
})

export function terminologyForLocale(locale) {
  return Object.freeze({
    locale: FORBIDDEN_LOCALIZATIONS[locale] ? locale : "en-US",
    brand: PRODUCT_BRAND,
    preservedTerms: PRESERVED_TERMS,
  })
}

export function auditCatalog(locale, catalog) {
  const text = Object.values(catalog || {}).join("\n")
  return (FORBIDDEN_LOCALIZATIONS[locale] || []).filter(rule => rule.pattern.test(text))
    .map(rule => Object.freeze({ locale, preferred: rule.preferred }))
}
