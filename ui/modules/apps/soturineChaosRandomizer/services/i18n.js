import { computed, ref } from "vue"
import enUS from "../i18n/en-US.json"
import ptBR from "../i18n/pt-BR.json"

const messages = { "en-US": enUS, "pt-BR": ptBR }
const normalizeLocale = value => String(value || "").toLowerCase().startsWith("pt") ? "pt-BR" : "en-US"

export function createI18n() {
  const gameLocale = ref("en-US")
  const preference = ref("auto")
  const locale = computed(() => preference.value === "auto" ? normalizeLocale(gameLocale.value) : normalizeLocale(preference.value))

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

  return {
    locale, t, plural, formatNumber,
    setGameLocale: value => { gameLocale.value = normalizeLocale(value) },
    setPreference: value => { preference.value = ["auto", "en-US", "pt-BR"].includes(value) ? value : "auto" },
  }
}
