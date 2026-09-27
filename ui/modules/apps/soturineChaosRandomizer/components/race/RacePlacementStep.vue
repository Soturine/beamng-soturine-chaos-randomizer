<template>
  <section class="scr-race-step">
    <div class="scr-card scr-form-grid">
      <ScrSelect v-model="options.mode" :label="t('race.formation')" :items="formationItems" @change="persist('formation', options.mode)" />
      <ScrSelect v-model="options.formationOrigin" :label="t('race.formationOrigin')" :items="originItems" @change="persist('formationOrigin', options.formationOrigin)" />
      <ScrSelect v-model="options.headingMode" :label="t('race.headingMode')" :items="headingItems" @change="persist('headingMode', options.headingMode)" />
      <ScrSelect v-model="options.spacingMode" :label="t('race.spacingMode')" :items="spacingItems" @change="persist('spacingMode', options.spacingMode)" />
      <template v-if="options.spacingMode === 'manual'">
        <NumericInput v-model="options.longitudinalSpacing" :label="t('race.longitudinal')" :min="2" :max="50" :step="0.5" @update:model-value="value => persist('longitudinalSpacing', value)" />
        <NumericInput v-model="options.lateralSpacing" :label="t('race.lateral')" :min="1" :max="25" :step="0.5" @update:model-value="value => persist('lateralSpacing', value)" />
      </template>
    </div>

    <div class="scr-actions">
      <button type="button" :disabled="!canPlace" @click="preview">{{ t('race.preview') }}</button>
      <button v-if="!placementActive" type="button" class="is-hot" :disabled="!canPlace" @click="place('all')">{{ t('race.placeAll') }}</button>
      <button v-else type="button" @click="stores.command.send('cancelLineupSpawn')">{{ t('race.cancelPlacement') }}</button>
    </div>

    <div v-if="readyToPlace === 0 && !placementActive" class="scr-race-summary is-blocked" role="status">
      <strong>{{ t('race.noneToPlace') }}</strong>
      <button type="button" @click="layout.raceStep = 'setup'">{{ t('race.fixGeneration') }}</button>
    </div>
    <div v-else class="scr-race-summary" role="status" aria-live="polite">
      <strong v-if="placementActive">{{ t('race.placementProgress', { completed: Number(run.completed || 0), requested: Number(run.requested || run.total || 0) }) }}</strong>
      <strong v-else>{{ t('race.summary.positioned', { count: summary.positioned || 0, total: readyToPlace }) }}</strong>
      <span v-if="previewState">{{ t(previewStatusKey(previewState)) }}</span>
      <span v-if="lastResult && !placementActive && lastResult.failed > 0" class="is-warning">{{ t('race.summary.placementFailed', { count: lastResult.failed }) }}</span>
    </div>

    <details class="scr-card scr-progressive">
      <summary>{{ t('common.details') }}</summary>
      <div class="scr-form-grid">
        <NumericInput v-model="options.safetyMargin" :label="t('race.safetyMargin')" :min="0" :max="10" :step="0.25" @update:model-value="value => persist('safetyMargin', value)" />
        <template v-if="options.formationOrigin === 'custom'">
          <NumericInput v-model="options.customPointX" :label="t('race.customPointX')" />
          <NumericInput v-model="options.customPointY" :label="t('race.customPointY')" />
          <NumericInput v-model="options.customPointZ" :label="t('race.customPointZ')" />
        </template>
      </div>
      <div class="scr-actions">
        <button type="button" :disabled="!canPlace" @click="place('one')">{{ t('race.placeOne') }}</button>
        <button type="button" :disabled="!canPlace" @click="place('next')">{{ t('race.placeNext') }}</button>
      </div>
      <details v-if="previewSlots.length" class="scr-technical-details">
        <summary>{{ t('race.previewCoordinates') }}</summary>
        <div class="scr-tech-grid">
          <span v-for="item in previewSlots" :key="item.slotId || item.slot"><code>{{ item.slotId || item.slot }}</code>: {{ coordinates(item.transform?.position) }}</span>
        </div>
      </details>
      <ManagedVehicleControls />
    </details>
  </section>
</template>

<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
import NumericInput from "../common/NumericInput.vue"
import ScrSelect from "../common/ScrSelect.vue"
import ManagedVehicleControls from "./ManagedVehicleControls.vue"
import { FORMATION_ORIGIN_CODES, formationRuntimeName, PLACEMENT_HEADING_MODE_CODES, previewStatusKey, RACE_FORMATION_CODES, SPACING_MODE_CODES } from "../../services/raceProtocol.js"
import { normalizePreviewSlots } from "../../services/stateNormalizer.js"

const stores = useStores()
const core = stores.core.state
const layout = stores.uiLayout.state
const options = stores.race.state.placementOptions
const { t } = stores.i18n
const director = computed(() => stores.race.state.spawnDirector || {})
const summary = computed(() => stores.race.state.lineup?.current?.summary || {})
const run = computed(() => director.value.run || {})
const lastResult = computed(() => director.value.lastResult)
const placementActive = computed(() => run.value.active === true)
const readyToPlace = computed(() => Number(director.value.placement?.count || 0))
const canPlace = computed(() => readyToPlace.value > 0 && !core.busy && !placementActive.value)
const previewState = computed(() => director.value.racePreview?.kind === "finalGrid" ? director.value.racePreview : null)
const previewSlots = computed(() => normalizePreviewSlots(previewState.value?.slots).filter(item => Number(item.slot) > 0))
const formationItems = computed(() => RACE_FORMATION_CODES.map(value => ({ value, label: t(`race.formationValue.${value}`) })))
const originItems = computed(() => FORMATION_ORIGIN_CODES.map(value => ({ value, label: t(`race.formationOriginValue.${value}`) })))
const spacingItems = computed(() => SPACING_MODE_CODES.map(value => ({ value, label: t(value === "automatic" ? "race.automatic" : "race.manual") })))
const headingItems = computed(() => PLACEMENT_HEADING_MODE_CODES.map(value => ({
  value, label: t(`race.heading${value[0].toUpperCase()}${value.slice(1)}`),
})))
const coordinates = position => [position?.x, position?.y, position?.z].map(value => Number(value || 0).toFixed(1)).join(", ")
function persist(field, value) { stores.command.send("updateUIPreferences", [{ race: { [field]: value } }]) }
function request() { return { ...options, mode: formationRuntimeName(options.mode) } }
const preview = () => stores.command.send("previewLineupSpawn", [request()])
function place(variant) {
  const value = request()
  value.spawnAll = variant === "all"
  value.useNextLineupCompetitor = variant === "next"
  value.placementAction = variant
  value.count = variant === "all" ? readyToPlace.value : 1
  stores.command.send("startLineupSpawn", [value])
}
</script>
