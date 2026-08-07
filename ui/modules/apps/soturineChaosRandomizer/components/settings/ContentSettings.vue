<template>
  <section class="scr-card">
    <h3>{{ t('settings.content') }}</h3>
    <ScrSelect :model-value="settings.contentFilter" :label="t('settings.contentFilter')" :items="contentItems" @update:model-value="value => update('contentFilter', value)" />
    <ScrSelect :model-value="settings.selectionFairness" :label="t('settings.fairness')" :items="fairnessItems" @update:model-value="value => update('selectionFairness', value)" />
    <ToggleField :model-value="settings.includeAutomation === true" :label="t('settings.includeAutomation')" @update:model-value="value => update('includeAutomation', value)" />
    <ToggleField :model-value="settings.includeTrailers === true" :label="t('settings.includeTrailers')" @update:model-value="value => update('includeTrailers', value)" />
    <ToggleField :model-value="settings.includeProps === true" :label="t('settings.includeProps')" @update:model-value="value => update('includeProps', value)" />
  </section>
</template>

<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
import ScrSelect from "../common/ScrSelect.vue"
import ToggleField from "../common/ToggleField.vue"

const stores = useStores()
const settings = stores.settings.state
const { t } = stores.i18n
const contentItems = computed(() => [
  { value: "everything", label: t("settings.contentEverything") },
  { value: "official", label: t("settings.contentOfficial") },
  { value: "mods", label: t("settings.contentMods") },
])
const fairnessItems = computed(() => [
  { value: "vehicle", label: t("settings.fairnessVehicle") },
  { value: "configuration", label: t("settings.fairnessConfiguration") },
])
const update = (field, value) => stores.command.send("updateSettings", [{ [field]: value }])
</script>
