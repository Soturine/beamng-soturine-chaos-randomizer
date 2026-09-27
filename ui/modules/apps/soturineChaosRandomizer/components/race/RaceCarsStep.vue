<template>
  <section class="scr-race-step">
    <div class="scr-card scr-form-grid">
      <NumericInput :model-value="totalVehicles" :label="t('race.totalVehicles')" :min="2" :max="32" @update:model-value="value => update('count', value)" />
      <ScrSelect :model-value="options.participationMode" :label="t('race.participation')" :items="participationItems" @update:model-value="value => update('participationMode', value)" />
      <ScrSelect :model-value="options.preset" :label="t('race.preset')" :items="presetItems" @update:model-value="preset" />
      <label class="scr-field"><span>{{ t('race.episodeSeed') }}</span><input :value="options.episodeSeed" maxlength="64" :placeholder="t('race.seedAutomatic')" @change="update('episodeSeed', $event.target.value)" /></label>
    </div>

    <StatusBanner v-if="conflict" tone="error">{{ t('race.policyConflict') }}</StatusBanner>
    <div class="scr-actions">
      <button v-if="!generating" type="button" class="is-hot" :disabled="conflict || core.busy" @click="generate">{{ t(current ? 'race.regenerate' : 'race.generate') }}</button>
      <button v-else type="button" @click="stores.command.send('cancelRaceGeneration')">{{ t('race.cancelGeneration') }}</button>
    </div>

    <div class="scr-race-summary" role="status" aria-live="polite">
      <strong>{{ configurationSummary }}</strong>
      <span v-if="generating">{{ t('race.generatingSummary', { current: summary.generationReady || 0, total: plannedOpponents }) }}</span>
      <template v-else-if="current">
        <span>{{ t('race.summary.generated', { count: summary.generationReady || 0, total: plannedOpponents }) }}</span>
        <span>{{ t('race.summary.drivable', { count: summary.drivable || 0, total: plannedOpponents }) }}</span>
        <span v-if="summary.failed > 0" class="is-warning">{{ t('race.failedSummary', { count: summary.failed }) }}</span>
      </template>
      <span v-if="current?.episodeSeed" class="scr-seed-inline">{{ t('race.usedSeed') }} <code>{{ current.episodeSeed }}</code> <button type="button" @click="copySeed">{{ t('race.copySeed') }}</button></span>
    </div>
    <div v-if="persistence?.status === 'warning'" class="scr-banner is-warning" role="status">
      <strong>{{ t(`result.${persistence.errorCode || 'lineup_storage_storage'}`) }}</strong>
      <span>{{ t('race.storageMemorySafe') }}</span>
      <button v-if="persistence.recoverable" type="button" :disabled="core.busy" @click="stores.command.send('retryLineupPersistence')">{{ t('race.retryStorage') }}</button>
    </div>

    <CompetitorList v-if="current?.competitors?.length" />

    <details class="scr-card scr-progressive">
      <summary>{{ t('race.advancedOptions') }}</summary>
      <RacePolicyPanel />
      <section class="scr-policy-group">
        <h4>{{ t('race.generationArea') }}</h4>
        <small class="scr-field-help">{{ t('race.generationAreaHelp') }}</small>
        <div class="scr-form-grid">
          <ScrSelect :model-value="options.previewOrigin" :label="t('race.previewOrigin')" :items="originItems" @update:model-value="value => update('previewOrigin', value)" />
          <NumericInput :model-value="Number(options.safetyMargin)" :label="t('race.safetyMargin')" :min="0.25" :max="10" :step="0.25" @update:model-value="value => update('safetyMargin', value)" />
          <template v-if="options.previewOrigin === 'custom'">
            <NumericInput :model-value="Number(options.customPointX || 0)" :label="t('race.customPointX')" @update:model-value="value => update('customPointX', value)" />
            <NumericInput :model-value="Number(options.customPointY || 0)" :label="t('race.customPointY')" @update:model-value="value => update('customPointY', value)" />
            <NumericInput :model-value="Number(options.customPointZ || 0)" :label="t('race.customPointZ')" @update:model-value="value => update('customPointZ', value)" />
          </template>
        </div>
      </section>
      <div class="scr-actions">
        <button type="button" :disabled="conflict || core.busy || !current?.episodeSeed" @click="repeatGeneration">{{ t('race.repeatGeneration') }}</button>
        <button type="button" @click="stores.command.send('exportChaosLineup')">{{ t('common.export') }}</button>
        <button type="button" @click="stores.command.send('importChaosLineup')">{{ t('common.import') }}</button>
      </div>
    </details>
  </section>
</template>

<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
import NumericInput from "../common/NumericInput.vue"
import ScrSelect from "../common/ScrSelect.vue"
import StatusBanner from "../common/StatusBanner.vue"
import RacePolicyPanel from "./RacePolicyPanel.vue"
import CompetitorList from "./CompetitorList.vue"
import { copyText } from "../../services/clipboard.js"
import { effectivePolicy, policyConflict, RACE_PRESETS } from "../../services/racePolicy.js"
import { PREVIEW_ORIGIN_CODES } from "../../services/raceProtocol.js"

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
const generating = computed(() => current.value?.generationState === "lineup_processing")
const persistence = computed(() => current.value?.persistence)
const configurationSummary = computed(() => t(
  playerParticipates.value ? "race.configSummaryPlayer" : "race.configSummarySpectator",
  { total: totalVehicles.value, opponents: plannedOpponents.value },
))
const conflict = computed(() => policyConflict(effectivePolicy(options, stores.race.state.lineup?.presetPolicies)))
const participationItems = computed(() => [
  { value: "player", label: t("race.player") },
  { value: "spectator", label: t("race.spectator") },
])
const presetItems = computed(() => RACE_PRESETS.map(value => ({ value, label: t(`race.presetValue.${value}`) })))
const originItems = computed(() => PREVIEW_ORIGIN_CODES
  .map(value => ({ value, label: t(`race.previewOriginValue.${value}`) })))

async function update(field, value) {
  options[field] = value
  await stores.command.send("updateUIPreferences", [{ race: { [field]: value } }])
}
async function preset(value) {
  // Presets only select a policy; Custom's own policy is never overwritten.
  options.preset = value
  await stores.command.send("updateUIPreferences", [{ race: { preset: value } }])
}
function generate() {
  const episodeSeed = String(options.episodeSeed || "").trim()
  return stores.command.send("createChaosLineup", [{ ...options, episodeSeed, seedIntent: episodeSeed ? "explicit" : "new" }])
}
function repeatGeneration() {
  if (!current.value?.episodeSeed) return false
  return stores.command.send("createChaosLineup", [{
    ...options, episodeSeed: current.value.episodeSeed, seedIntent: "repeat", repeatOfLineupId: current.value.id,
  }])
}
async function copySeed() {
  const copied = await copyText(current.value?.episodeSeed || "")
  stores.diagnostics.state.status = copied ? "diagnostics_copied" : "diagnostics_copy_failed"
}
</script>
