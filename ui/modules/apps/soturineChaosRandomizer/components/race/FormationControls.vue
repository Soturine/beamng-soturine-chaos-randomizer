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
      <button type="button" @click="preview">{{ t('race.preview') }}</button>
      <button type="button" @click="spawn('one')">{{ t('race.placeOne') }}</button>
      <button type="button" @click="spawn('next')">{{ t('race.placeNext') }}</button>
      <button type="button" class="is-hot" @click="spawn('all')">{{ t('race.placeAll') }}</button>
      <button type="button" @click="stores.command.send('cancelLineupSpawn')">{{ t('race.cancelPlacement') }}</button>
    </div>
  </section>
</template>

<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
import NumericInput from "../common/NumericInput.vue"
import ScrSelect from "../common/ScrSelect.vue"

const stores = useStores()
const options = stores.race.state.placementOptions
const { t } = stores.i18n
const formations = ["Automatic Best Fit", "Split Left and Right", "Single File Behind", "Single File Ahead", "Staggered Grid", "Side-by-side Grid", "Circular / Radial", "Front Left", "Behind Right", "Custom point", "Collision"]
const formationItems = computed(() => formations.map(value => ({ value, label: t(`race.formationValue.${value}`) })))
const spacingItems = computed(() => [
  { value: "automatic", label: t("race.automatic") },
  { value: "manual", label: t("race.manual") },
])
const headingItems = computed(() => [
  { value: "camera", label: t("race.headingCamera") },
  { value: "player", label: t("race.headingPlayer") },
  { value: "road", label: t("race.headingRoad") },
  { value: "destination", label: t("race.headingDestination") },
  { value: "custom", label: t("race.headingCustom") },
])
function persist(field, value) { stores.command.send("updateUIPreferences", [{ race: { [field]: value } }]) }
function merged() { return { ...options } }
const preview = () => stores.command.send("previewLineupSpawn", [merged()])
function spawn(variant) { const value = merged(); value.spawnAll = variant === "all"; value.useNextLineupCompetitor = variant !== "one"; value.count = variant === "all" ? Number(stores.race.state.options.count || 4) : 1; stores.command.send("startLineupSpawn", [value]) }
</script>
