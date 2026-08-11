<template>
  <section>
    <div class="scr-card scr-form-grid">
      <NumericInput :model-value="totalVehicles" :label="t('race.totalVehicles')" :min="2" :max="32" @update:model-value="value => update('count', value)" />
      <ScrSelect :model-value="options.participationMode" :label="t('race.participation')" :items="participationItems" @update:model-value="value => update('participationMode', value)" />
      <label class="scr-field"><span>{{ t('race.episodeSeed') }}</span><input :value="options.episodeSeed" maxlength="128" @change="update('episodeSeed', $event.target.value)" /></label>
      <ScrSelect :model-value="options.preset" :label="t('race.preset')" :items="presetItems" @update:model-value="preset" />
    </div>

    <div class="scr-race-summary" role="status" aria-live="polite">
      <strong>{{ configurationSummary }}</strong>
      <template v-if="processing">
        <span>{{ t('race.generatingSummary', { current: generatedCount, total: plannedOpponents }) }}</span>
        <span v-if="readyCount > 0">{{ t('race.readySummary', { count: readyCount }) }}</span>
      </template>
      <template v-else-if="current">
        <span v-if="readyCount > 0">{{ t('race.readySummary', { count: readyCount }) }}</span>
        <span v-if="failedCount > 0">{{ t('race.failedSummary', { count: failedCount }) }}</span>
      </template>
    </div>

    <details class="scr-card scr-progressive">
      <summary>{{ t('race.generationPreview') }}</summary>
      <ToggleField :model-value="options.previewEnabled" :label="t('race.previewEnabled')" @update:model-value="setPreviewEnabled" />
      <div class="scr-form-grid">
        <ScrSelect :model-value="options.previewOrigin" :label="t('race.previewOrigin')" :items="originItems" @update:model-value="value => update('previewOrigin', value)" />
        <ScrSelect :model-value="options.headingMode" :label="t('race.headingMode')" :items="headingItems" @update:model-value="value => update('headingMode', value)" />
        <ScrSelect :model-value="options.formation" :label="t('race.formation')" :items="formationItems" @update:model-value="value => update('formation', value)" />
        <ScrSelect :model-value="options.spacingMode" :label="t('race.spacingMode')" :items="spacingItems" @update:model-value="value => update('spacingMode', value)" />
        <NumericInput v-if="options.spacingMode === 'manual'" :model-value="Number(options.longitudinalSpacing)" :label="t('race.longitudinal')" :min="2" :max="50" :step="0.5" @update:model-value="value => update('longitudinalSpacing', value)" />
        <NumericInput v-if="options.spacingMode === 'manual'" :model-value="Number(options.lateralSpacing)" :label="t('race.lateral')" :min="1" :max="25" :step="0.5" @update:model-value="value => update('lateralSpacing', value)" />
        <NumericInput :model-value="Number(options.safetyMargin)" :label="t('race.safetyMargin')" :min="0.25" :max="10" :step="0.25" @update:model-value="value => update('safetyMargin', value)" />
        <NumericInput v-if="options.previewOrigin === 'custom'" :model-value="Number(options.customPointX || 0)" :label="t('race.customPointX')" @update:model-value="value => update('customPointX', value)" />
        <NumericInput v-if="options.previewOrigin === 'custom'" :model-value="Number(options.customPointY || 0)" :label="t('race.customPointY')" @update:model-value="value => update('customPointY', value)" />
        <NumericInput v-if="options.previewOrigin === 'custom'" :model-value="Number(options.customPointZ || 0)" :label="t('race.customPointZ')" @update:model-value="value => update('customPointZ', value)" />
      </div>
      <div class="scr-actions">
        <button type="button" :disabled="!options.previewEnabled || core.busy" @click="previewGeneration">{{ t('race.previewGeneration') }}</button>
      </div>
      <small v-if="worldPreview">{{ previewStateLabel }} · {{ t('race.previewSlots', { count: worldPreview.slots?.length || 0 }) }}</small>
    </details>

    <RacePolicyPanel :open="false" />
    <div class="scr-actions">
      <button v-if="!core.busy" type="button" class="is-hot" :disabled="conflict" @click="generate">{{ t(current?.active ? 'race.regenerate' : 'race.generate') }}</button>
      <button v-if="current?.active || core.busy" type="button" @click="stores.command.send('cancelRaceGeneration')">{{ t('race.cancelGeneration') }}</button>
      <button type="button" @click="stores.command.send('exportChaosLineup')">{{ t('common.export') }}</button>
      <button type="button" @click="stores.command.send('importChaosLineup')">{{ t('common.import') }}</button>
    </div>
    <CompetitorList />
  </section>
</template>

<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
import NumericInput from "../common/NumericInput.vue"
import ScrSelect from "../common/ScrSelect.vue"
import ToggleField from "../common/ToggleField.vue"
import RacePolicyPanel from "./RacePolicyPanel.vue"
import CompetitorList from "./CompetitorList.vue"
import { HEADING_MODE_CODES, PREVIEW_ORIGIN_CODES, previewStatusKey, RACE_FORMATION_CODES, SPACING_MODE_CODES } from "../../services/raceProtocol.js"

const stores = useStores()
const core = stores.core.state
const options = stores.race.state.options
const { t } = stores.i18n
const current = computed(() => stores.race.state.lineup?.current)
const summary = computed(() => current.value?.summary || {})
const totalVehicles = computed(() => Math.max(2, Number(options.count || 4)))
const playerParticipates = computed(() => options.participationMode === "player")
const plannedOpponents = computed(() => Math.max(1, Number(summary.value.plannedOpponents
  ?? (totalVehicles.value - (playerParticipates.value ? 1 : 0)))))
const generatedCount = computed(() => Number(summary.value.generated || 0))
const readyCount = computed(() => Number(summary.value.ready || 0))
const failedCount = computed(() => Number(summary.value.failed || 0))
const processing = computed(() => current.value?.generationState === "lineup_processing")
const configurationSummary = computed(() => t(
  playerParticipates.value ? "race.configSummaryPlayer" : "race.configSummarySpectator",
  { total: totalVehicles.value, opponents: plannedOpponents.value },
))
const worldPreview = computed(() => stores.race.state.spawnDirector?.racePreview || current.value?.worldPreview)
const previewStateLabel = computed(() => {
  const preview = worldPreview.value
  if (!preview) return ""
  return t(previewStatusKey(preview))
})
const conflict = computed(() => options.allowOfficialVehicles === false && options.allowModVehicles === false)
const presets = ["Balanced", "Maximum Chaos", "Mods Showcase", "Custom"]
const participationItems = computed(() => [
  { value: "player", label: t("race.player") },
  { value: "spectator", label: t("race.spectator") },
])
const presetItems = computed(() => presets.map(value => ({ value, label: t(`race.presetValue.${value}`) })))
const originItems = computed(() => PREVIEW_ORIGIN_CODES
  .map(value => ({ value, label: t(`race.previewOriginValue.${value}`) })))
const headingItems = computed(() => HEADING_MODE_CODES
  .map(value => ({ value, label: t(`race.headingValue.${value}`) })))
const formationItems = computed(() => RACE_FORMATION_CODES.map(value => ({ value, label: t(`race.formationValue.${value}`) })))
const spacingItems = computed(() => SPACING_MODE_CODES.map(value => ({
  value, label: t(value === "automatic" ? "race.automatic" : "race.manual"),
})))
const balancedPolicy = Object.freeze({ acceptPartial: false, acceptMetadataUncertain: false, acceptPotentiallyUndrivable: false, avoidDuplicateModels: true, avoidDuplicateConfigurations: true, avoidDuplicateFamilies: false, maximumSameFamily: 2, diversifyVehicleClasses: true, diversifyPropulsion: false, diversifyDrivetrain: false, diversifySource: true, diversifyWheelStyles: false, diversifyBodyTypes: false, allowOfficialVehicles: true, allowModVehicles: true, allowAutomationVehicles: false, allowTrailers: false, allowProps: false, maxAttemptsPerCompetitor: 3, maxConsecutiveFailures: 4, retainAcceptedOnCancel: true })
const presetValues = { "Balanced": { ...balancedPolicy }, "Maximum Chaos": { ...balancedPolicy, acceptPartial: true, acceptMetadataUncertain: true, acceptPotentiallyUndrivable: true }, "Mods Showcase": { ...balancedPolicy, acceptMetadataUncertain: true, allowOfficialVehicles: false, allowModVehicles: true } }
const previewFields = new Set(["count", "participationMode", "previewOrigin", "headingMode", "formation", "spacingMode", "longitudinalSpacing", "lateralSpacing", "safetyMargin", "customPointX", "customPointY", "customPointZ"])

async function update(field, value) {
  options[field] = value
  await stores.command.send("updateUIPreferences", [{ race: { [field]: value } }])
  if (options.previewEnabled && previewFields.has(field) && !core.busy) previewGeneration()
}
async function preset(value) {
  Object.assign(options, presetValues[value] || {}, { preset: value })
  await stores.command.send("updateUIPreferences", [{ race: { ...options } }])
  if (options.previewEnabled && !core.busy) previewGeneration()
}
async function setPreviewEnabled(value) {
  options.previewEnabled = value === true
  await stores.command.send("updateUIPreferences", [{ race: { previewEnabled: options.previewEnabled } }])
  previewGeneration()
}
function previewGeneration() { return stores.command.send("previewRaceGeneration", [{ ...options }]) }
function generate() { return stores.command.send("createChaosLineup", [{ ...options }]) }
</script>
