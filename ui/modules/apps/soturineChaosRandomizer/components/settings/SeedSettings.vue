<template>
  <section class="scr-card">
    <h3>{{ t('settings.seed') }}</h3>
    <ScrSelect :model-value="selectedLocale" :label="t('settings.locale')" :items="localeItems" @update:model-value="locale" />
    <ScrSelect :model-value="settings.seedMode" :label="t('settings.fixedSeed')" :items="seedItems" @update:model-value="value => update('seedMode', value)" />
    <label class="scr-field">
      <span>{{ t('settings.manualSeed') }}</span>
      <input :value="settings.manualSeed" maxlength="128" :disabled="settings.seedMode !== 'fixed'" @change="update('manualSeed', $event.target.value)" />
    </label>
    <NumericInput :model-value="Number(settings.chaos || 75)" :label="t('settings.chaos')" :min="0" :max="100" @update:model-value="value => update('chaos', value)" />
  </section>
</template>

<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
import NumericInput from "../common/NumericInput.vue"
import ScrSelect from "../common/ScrSelect.vue"

const stores = useStores()
const settings = stores.settings.state
const preferences = settings.uiPreferences || {}
const { t } = stores.i18n
const selectedLocale = computed(() => preferences.localeMode === "manual" ? (preferences.manualLocale || "en-US") : "auto")
const localeItems = computed(() => [
  { value: "auto", label: t("settings.localeAuto") },
  { value: "en-US", label: "English (United States)" },
  { value: "pt-BR", label: "Português (Brasil)" },
  { value: "es-ES", label: "Español (España)" },
])
const seedItems = computed(() => [
  { value: "random", label: t("settings.randomSeed") },
  { value: "fixed", label: t("settings.fixedSeed") },
])
const update = (field, value) => stores.command.send("updateSettings", [{ [field]: value }])
function locale(value) {
  const patch = value === "auto" ? { localeMode: "auto" } : { localeMode: "manual", manualLocale: value }
  Object.assign(preferences, patch)
  stores.i18n.setPreference({ localeMode: patch.localeMode, manualLocale: patch.manualLocale || preferences.manualLocale })
  stores.command.send("updateUIPreferences", [patch])
}
</script>
