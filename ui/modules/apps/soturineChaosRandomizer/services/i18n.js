import { computed, ref } from "vue"
import enUS from "../i18n/en-US.json"
import ptBR from "../i18n/pt-BR.json"
import esES from "../i18n/es-ES.json"

const messages = { "en-US": enUS, "pt-BR": ptBR, "es-ES": esES }
export const normalizeLocale = value => {
  const language = String(value || "").trim().toLowerCase().replaceAll("_", "-")
  if (language.startsWith("pt")) return "pt-BR"
  if (language.startsWith("es")) return "es-ES"
  return "en-US"
}

export function createI18n() {
  const gameLocale = ref("en-US")
  const localeMode = ref("auto")
  const manualLocale = ref("en-US")
  const locale = computed(() => localeMode.value === "auto" ? normalizeLocale(gameLocale.value) : normalizeLocale(manualLocale.value))

  function interpolate(template, values) {
    return String(template).replace(/\{([A-Za-z0-9_]+)\}/g, (_, key) =>
      Object.prototype.hasOwnProperty.call(values || {}, key) ? String(values[key]) : `{${key}}`
    )
  }

  function t(key, values = {}) {
    const translated = messages[locale.value]?.[key] ?? messages["en-US"][key] ?? key
    return interpolate(translated, values)
  }

  function plural(key, count, values = {}) {
    const suffix = Number(count) === 1 ? ".one" : ".other"
    return t(`${key}${suffix}`, { ...values, count: formatNumber(count) })
  }

  function formatNumber(value, options = {}) {
    return new Intl.NumberFormat(locale.value, options).format(Number(value) || 0)
  }

  function setPreference(value) {
    if (typeof value === "string") {
      localeMode.value = value === "auto" ? "auto" : "manual"
      if (value !== "auto") manualLocale.value = normalizeLocale(value)
      return
    }
    localeMode.value = value?.localeMode === "manual" ? "manual" : "auto"
    manualLocale.value = normalizeLocale(value?.manualLocale || manualLocale.value)
  }

  return {
    locale, localeMode, manualLocale, t, plural, formatNumber,
    setGameLocale: value => { gameLocale.value = normalizeLocale(value) },
    setPreference,
  }
}
