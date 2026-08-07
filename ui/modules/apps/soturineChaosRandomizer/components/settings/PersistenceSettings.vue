<template>
  <section class="scr-card">
    <h3>{{ t('settings.persistence') }}</h3>
    <NumericInput :model-value="Number(settings.historyLimit || 10)" :label="t('settings.historyLimit')" :min="1" :max="50" @update:model-value="value => update('historyLimit', value)" />
    <NumericInput :model-value="Number(settings.dnaLibraryLimit || 100)" :label="t('settings.dnaLimit')" :min="1" :max="100" @update:model-value="value => update('dnaLibraryLimit', value)" />
    <ToggleField :model-value="settings.rememberLocks === true" :label="t('settings.rememberLocks')" @update:model-value="value => update('rememberLocks', value)" />
    <ScrSelect :model-value="settings.defaultRestoreMode" :label="t('settings.restoreMode')" :items="restoreItems" @update:model-value="value => update('defaultRestoreMode', value)" />
  </section>
</template>

<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
import NumericInput from "../common/NumericInput.vue"
import ScrSelect from "../common/ScrSelect.vue"
import ToggleField from "../common/ToggleField.vue"

const stores = useStores()
const settings = stores.settings.state
const { t } = stores.i18n
const restoreItems = computed(() => [
  { value: "exact", label: t("garage.restoreExact") },
  { value: "compatible", label: t("garage.restoreCompatible") },
])
const update = (field, value) => stores.command.send("updateSettings", [{ [field]: value }])
</script>
