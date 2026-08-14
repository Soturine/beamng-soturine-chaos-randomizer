<template>
  <section class="scr-card">
    <div class="scr-form-grid">
      <ScrSelect v-model="options.mode" :label="t('race.formation')" :items="formationItems" @change="persist('formation', options.mode)" />
      <ScrSelect v-model="options.spacingMode" :label="t('race.spacingMode')" :items="spacingItems" @change="persist('spacingMode', options.spacingMode)" />
      <NumericInput v-model="options.longitudinalSpacing" :label="t('race.longitudinal')" :min="2" :max="50" :step="0.5" @update:model-value="value => persist('longitudinalSpacing', value)" />
      <NumericInput v-model="options.lateralSpacing" :label="t('race.lateral')" :min="1" :max="25" :step="0.5" @update:model-value="value => persist('lateralSpacing', value)" />
      <NumericInput v-model="options.safetyMargin" :label="t('race.safetyMargin')" :min="0" :max="10" :step="0.25" @update:model-value="value => persist('safetyMargin', value)" />
      <ScrSelect v-model="options.headingMode" :label="t('race.headingMode')" :items="headingItems" @change="persist('headingMode', options.headingMode)" />
      <NumericInput v-if="options.mode === 'Custom point'" v-model="options.customPointX" :label="t('race.customPointX')" />
      <NumericInput v-if="options.mode === 'Custom point'" v-model="options.customPointY" :label="t('race.customPointY')" />
      <NumericInput v-if="options.mode === 'Custom point'" v-model="options.customPointZ" :label="t('race.customPointZ')" />
    </div>
    <div class="scr-actions">
      <button type="button" :disabled="core.busy" @click="preview">{{ previewLabel }}</button>
      <button type="button" :disabled="core.busy" @click="spawn('one')">{{ t('race.placeOne') }}</button>
      <button type="button" :disabled="core.busy" @click="spawn('next')">{{ t('race.placeNext') }}</button>
      <button type="button" class="is-hot" :disabled="core.busy" @click="spawn('all')">{{ t('race.placeAll') }}</button>
      <button type="button" @click="stores.command.send('cancelLineupSpawn')">{{ t('race.cancelPlacement') }}</button>
    </div>
  </section>
</template>

<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
import NumericInput from "../common/NumericInput.vue"
import ScrSelect from "../common/ScrSelect.vue"
import { formationRuntimeName, PLACEMENT_HEADING_MODE_CODES, RACE_FORMATION_CODES, SPACING_MODE_CODES } from "../../services/raceProtocol.js"

const stores = useStores()
const core = stores.core.state
const options = stores.race.state.placementOptions
const { t } = stores.i18n
const formationItems = computed(() => RACE_FORMATION_CODES.map(value => ({ value, label: t(`race.formationValue.${value}`) })))
const spacingItems = computed(() => SPACING_MODE_CODES.map(value => ({
  value, label: t(value === "automatic" ? "race.automatic" : "race.manual"),
})))
const headingItems = computed(() => PLACEMENT_HEADING_MODE_CODES.map(value => ({
  value, label: t(`race.heading${value[0].toUpperCase()}${value.slice(1)}`),
})))
const rendererUnavailable = computed(() => stores.race.state.spawnDirector?.racePreview
  ?.renderer?.availabilityState === "RENDER_UNAVAILABLE")
const previewLabel = computed(() => t(rendererUnavailable.value ? "race.calculatePlacements" : "race.preview"))
function persist(field, value) { stores.command.send("updateUIPreferences", [{ race: { [field]: value } }]) }
function merged() { return { ...options, mode: formationRuntimeName(options.mode) } }
const preview = () => stores.command.send("previewLineupSpawn", [merged()])
function spawn(variant) { const value = merged(); value.spawnAll = variant === "all"; value.useNextLineupCompetitor = variant === "next"; value.placementAction = variant; value.count = variant === "all" ? Number(stores.race.state.options.count || 4) : 1; stores.command.send("startLineupSpawn", [value]) }
</script>
