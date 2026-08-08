const clean = value => String(value ?? "").replace(/^\/+|\/+$/g, "").trim()
const words = value => clean(value)
  .replaceAll("_", " ")
  .replaceAll("-", " ")
  .replace(/([a-z0-9])([A-Z])/g, "$1 $2")
  .replace(/\s+/g, " ")
  .trim()

const titleCase = value => words(value).replace(/\b\w/g, letter => letter.toLocaleUpperCase())

const PART_GLOSSARY = Object.freeze({
  body: "parts.body",
  "navigation unit": "parts.navigationUnit",
  "left antenna": "parts.leftAntenna",
  "right antenna": "parts.rightAntenna",
  backlight: "parts.backlight",
  "mud flap": "parts.mudFlap",
  "front left mud flap": "parts.frontLeftMudFlap",
  "headlight bulb": "parts.headlightBulb",
  "left highbeam headlight bulb": "parts.leftHighbeamHeadlightBulb",
})

const KNOWN_MODELS = Object.freeze({
  us_semi: "Gavril T-Series",
  legran: "Bruckell LeGran",
  dumptruck: "Dump Truck",
})

export function humanPartLabel(slot, t) {
  const raw = clean(slot?.displayName || slot?.description || slot?.slotId || slot?.id || "")
  if (!raw) return t("locks.unnamedPart")
  const normalized = words(raw).toLocaleLowerCase()
  const key = PART_GLOSSARY[normalized]
  if (key) return t(key)
  const looksAuthored = /[a-z][A-Z]/.test(raw) || (/\s/.test(raw) && /[A-Z]/.test(raw.slice(1)))
  return looksAuthored ? raw : titleCase(raw)
}

export function vehicleDisplayName(entry, t) {
  const explicit = [
    entry?.displayName, entry?.vehicleName, entry?.modelName,
    entry?.base?.displayName, entry?.base?.vehicleName, entry?.base?.modelName,
    entry?.final?.displayName, entry?.final?.vehicleName, entry?.final?.modelName,
    entry?.verifiedTraits?.displayName,
  ].map(clean).find(Boolean)
  if (explicit) return explicit

  const modelKey = clean(entry?.modelKey || entry?.final?.modelKey || entry?.base?.modelKey)
  const savedName = clean(entry?.name)
  const generatedDefault = modelKey && savedName.toLocaleLowerCase() === `${modelKey} dna`.toLocaleLowerCase()
  if (savedName && !generatedDefault && savedName !== t("garage.defaultName")) return savedName
  if (KNOWN_MODELS[modelKey]) return KNOWN_MODELS[modelKey]
  if (modelKey) return titleCase(modelKey)
  return savedName || t("garage.defaultName")
}

export function vehicleSummary(entry, t) {
  return clean(entry?.description || entry?.base?.configName || entry?.base?.sourceLabel)
    || t("garage.randomVehicleSummary")
}

export { PART_GLOSSARY }
