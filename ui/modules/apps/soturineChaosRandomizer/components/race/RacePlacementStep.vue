<template>
  <section class="scr-race-step">
    <div class="scr-card scr-form-grid">
      <ScrSelect v-model="options.mode" :label="t('race.formation')" :items="formationItems" @change="changed('formation', options.mode)" />
      <div class="scr-field-group">
        <ScrSelect v-model="options.formationOrigin" :label="t('race.formationOrigin')" :items="originItems" @change="changed('formationOrigin', options.formationOrigin)" />
        <small class="scr-field-help">{{ t(`race.formationOriginHelp.${options.formationOrigin || 'automatic'}`) }}</small>
      </div>
      <ScrSelect v-model="options.headingMode" :label="t('race.headingMode')" :items="headingItems" @change="changed('headingMode', options.headingMode)" />
      <ScrSelect v-model="options.spacingMode" :label="t('race.spacingMode')" :items="spacingItems" @change="changed('spacingMode', options.spacingMode)" />
      <template v-if="options.spacingMode === 'manual'">
        <NumericInput v-model="options.longitudinalSpacing" :label="t('race.longitudinal')" :min="2" :max="50" :step="0.5" @update:model-value="value => changed('longitudinalSpacing', value, true)" />
        <NumericInput v-model="options.lateralSpacing" :label="t('race.lateral')" :min="1" :max="25" :step="0.5" @update:model-value="value => changed('lateralSpacing', value, true)" />
      </template>
    </div>

    <div class="scr-actions">
      <button type="button" :aria-pressed="previewActive" :disabled="!canPreview" @click="togglePreview">{{ t(previewActive ? 'race.hidePreview' : 'race.showPreview') }}</button>
      <button v-if="!placementActive" type="button" class="is-hot" :disabled="!canPlace" @click="place('all')">{{ t('race.placeAll') }}</button>
      <button v-else type="button" @click="stores.command.send('cancelLineupSpawn')">{{ t('race.cancelPlacement') }}</button>
    </div>

    <div class="scr-race-summary" :class="{ 'is-blocked': readyToPlace === 0 && !placementActive }" role="status" aria-live="polite">
      <strong v-if="placementActive">{{ t('race.placementProgress', { completed: Number(run.completed || 0), requested: Number(run.requested || run.total || 0) }) }}</strong>
      <strong v-else-if="readyToPlace === 0">{{ t('race.noneToPlace') }}</strong>
      <strong v-else>{{ t('race.summary.positioned', { count: summary.positioned || 0, total: readyToPlace }) }}</strong>
      <span v-if="previewLabel">{{ previewLabel }}</span>
      <span v-if="lastResult && !placementActive && lastResult.failed > 0" class="is-warning">{{ t('race.summary.placementFailed', { count: lastResult.failed }) }}</span>
      <button v-if="readyToPlace === 0 && !placementActive" type="button" @click="layout.raceStep = 'setup'">{{ t('race.fixGeneration') }}</button>
    </div>

    <details class="scr-card scr-progressive">
      <summary>{{ t('common.details') }}</summary>
      <div class="scr-form-grid">
        <NumericInput v-model="options.safetyMargin" :label="t('race.safetyMargin')" :min="0" :max="10" :step="0.25" @update:model-value="value => changed('safetyMargin', value, true)" />
        <template v-if="options.formationOrigin === 'custom'">
          <NumericInput v-model="options.customPointX" :label="t('race.customPointX')" @update:model-value="() => changed(null, null, true)" />
          <NumericInput v-model="options.customPointY" :label="t('race.customPointY')" @update:model-value="() => changed(null, null, true)" />
          <NumericInput v-model="options.customPointZ" :label="t('race.customPointZ')" @update:model-value="() => changed(null, null, true)" />
        </template>
      </div>
      <div class="scr-actions">
        <button type="button" :disabled="!canPlace" @click="place('one')">{{ t('race.placeOne') }}</button>
        <button type="button" :disabled="!canPlace" @click="place('next')">{{ t('race.placeNext') }}</button>
      </div>
      <details v-if="previewSlots.length" class="scr-technical-details">
        <summary>{{ t('race.previewCoordinates') }}</summary>
        <div class="scr-tech-grid">
          <span v-if="preview?.state"><code>{{ preview.state }}</code></span>
          <span v-for="item in previewSlots" :key="item.slotId || item.slot"><code>{{ item.slotId || item.slot }}</code>: {{ coordinates(item.transform?.position) }}</span>
        </div>
      </details>
      <ManagedVehicleControls />
    </details>
  </section>
</template>

<script setup>
import { computed, onUnmounted } from "vue"
import { useStores } from "../../stores/index.js"
import NumericInput from "../common/NumericInput.vue"
import ScrSelect from "../common/ScrSelect.vue"
import ManagedVehicleControls from "./ManagedVehicleControls.vue"
import { FORMATION_ORIGIN_CODES, formationRuntimeName, PLACEMENT_HEADING_MODE_CODES, previewFailed, previewStatusKey, RACE_FORMATION_CODES, SPACING_MODE_CODES } from "../../services/raceProtocol.js"
import { normalizePreviewSlots } from "../../services/stateNormalizer.js"

const stores = useStores()
const core = stores.core.state
const layout = stores.uiLayout.state
const options = stores.race.state.placementOptions
const raceOptions = stores.race.state.options
const { t } = stores.i18n
const director = computed(() => stores.race.state.spawnDirector || {})
const summary = computed(() => stores.race.state.lineup?.current?.summary || {})
const run = computed(() => director.value.run || {})
const lastResult = computed(() => director.value.lastResult)
const placementActive = computed(() => run.value.active === true)
const readyToPlace = computed(() => Number(director.value.placement?.count || 0))
const preview = computed(() => stores.race.state.racePreview || null)
const previewActive = computed(() => preview.value?.enabled === true)
// Preview is read-only planning; placement mutates vehicles. They never share a gate.
const canPreview = computed(() => !placementActive.value)
const canPlace = computed(() => readyToPlace.value > 0 && !core.busy && !placementActive.value)
const previewLabel = computed(() => {
  if (!previewActive.value) return ""
  if (previewFailed(preview.value)) return t(previewStatusKey(preview.value))
  return t(preview.value?.quality === "estimated" ? "race.previewActiveEstimated" : "race.previewActive")
})
const previewSlots = computed(() => normalizePreviewSlots(preview.value?.slots).filter(item => Number(item.slot) > 0))
const formationItems = computed(() => RACE_FORMATION_CODES.map(value => ({ value, label: t(`race.formationValue.${value}`) })))
const originItems = computed(() => FORMATION_ORIGIN_CODES.map(value => ({ value, label: t(`race.formationOriginValue.${value}`) })))
const spacingItems = computed(() => SPACING_MODE_CODES.map(value => ({ value, label: t(value === "automatic" ? "race.automatic" : "race.manual") })))
const headingItems = computed(() => PLACEMENT_HEADING_MODE_CODES.map(value => ({
  value, label: t(`race.heading${value[0].toUpperCase()}${value.slice(1)}`),
})))
const coordinates = position => [position?.x, position?.y, position?.z].map(value => Number(value || 0).toFixed(1)).join(", ")

function request(extra = {}) {
  const total = Math.max(2, Number(raceOptions.count || 4))
  const participationMode = raceOptions.participationMode || "spectator"
  return {
    ...options, ...extra, mode: formationRuntimeName(options.mode),
    participationMode, totalVehicles: total,
    plannedOpponents: Number(summary.value.plannedOpponents || 0) || total - (participationMode === "player" ? 1 : 0),
  }
}
const showPreview = () => stores.command.send("previewLineupSpawn", [request({ previewEnabled: true })])
const hidePreview = () => stores.command.send("previewLineupSpawn", [{ previewEnabled: false }])
function togglePreview() { return previewActive.value ? hidePreview() : showPreview() }

// Selects refresh an active preview at once; numeric fields after a short pause.
let refreshTimer = null
function changed(field, value, debounced = false) {
  if (field) stores.command.send("updateUIPreferences", [{ race: { [field]: value } }])
  if (!previewActive.value) return
  clearTimeout(refreshTimer)
  refreshTimer = debounced ? setTimeout(showPreview, 350) : null
  if (!debounced) showPreview()
}
onUnmounted(() => clearTimeout(refreshTimer))

function place(variant) {
  const value = request()
  value.spawnAll = variant === "all"
  value.useNextLineupCompetitor = variant === "next"
  value.placementAction = variant
  value.count = variant === "all" ? readyToPlace.value : 1
  stores.command.send("startLineupSpawn", [value])
}
</script>
