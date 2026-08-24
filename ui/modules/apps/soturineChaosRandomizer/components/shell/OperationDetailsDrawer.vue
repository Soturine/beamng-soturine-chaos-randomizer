<template>
  <DetailsPanel
    :open="open"
    :title="t('operationDetails.title')"
    mode="drawer"
    @close="stores.uiLayout.toggleDetails(layout.activeTab)"
  >
    <div class="scr-tech-grid">
      <span><strong>{{ t('operationDetails.action') }}:</strong> {{ actionLabel }}</span>
      <span><strong>{{ t('operationDetails.outcome') }}:</strong> {{ outcomeLabel }}</span>
      <span><strong>{{ t('operationDetails.code') }}:</strong> {{ resultCode }}</span>
      <span><strong>{{ t('operationDetails.message') }}:</strong> {{ humanMessage }}</span>
      <span v-if="preset"><strong>{{ t('operationDetails.preset') }}:</strong> {{ preset }}</span>
      <span v-if="seed"><strong>{{ t('operationDetails.seed') }}:</strong> <code>{{ seed }}</code></span>
      <span><strong>{{ t('operationDetails.phase') }}:</strong> {{ phaseLabel }}</span>
      <span v-if="slot"><strong>{{ t('operationDetails.slot') }}:</strong> {{ slot }}</span>
      <span v-if="model"><strong>{{ t('operationDetails.vehicle') }}:</strong> {{ model }}<template v-if="configuration"> / {{ configuration }}</template></span>
      <span v-if="concreteVehicleId"><strong>{{ t('operationDetails.concreteVehicle') }}:</strong> {{ concreteVehicleId }}</span>
      <span v-if="recoveryRecommendation"><strong>{{ t('operationDetails.recovery') }}:</strong> {{ recoveryRecommendation }}</span>
    </div>
    <section v-if="coverage" class="scr-coverage-details">
      <h4>{{ t('operationDetails.coverage') }}</h4>
      <div v-if="coverage.slots" class="scr-coverage-row">
        <strong>{{ t('operationDetails.parts') }}</strong>
        <span>{{ coverageLine(coverage.slots, 'slots') }}</span>
      </div>
      <div v-if="coverage.tuning" class="scr-coverage-row">
        <strong>{{ t('operationDetails.tuning') }}</strong>
        <span>{{ coverageLine(coverage.tuning, 'tuning') }}</span>
      </div>
      <div v-if="coverage.paint" class="scr-coverage-row">
        <strong>{{ t('operationDetails.paint') }}</strong>
        <span>{{ coverageLine(coverage.paint, 'paint') }}</span>
      </div>
    </section>
    <section v-if="planning" class="scr-coverage-details">
      <h4>{{ t('operationDetails.planning') }}</h4>
      <div class="scr-tech-grid">
        <span>{{ t('operationDetails.planningSummary', {
          attempts: planning.totalAttempts || 0,
          rejected: planning.rejectedCandidates || 0,
          depth: planning.fallbackDepth || 0,
          duration: Number(planning.durationMs || 0).toFixed(1),
        }) }}</span>
        <span v-if="planning.budgetExhausted">{{ t('operationDetails.planningExhausted') }}</span>
      </div>
    </section>
    <details class="scr-technical-details">
      <summary>{{ t('common.technicalDetails') }}</summary>
      <div class="scr-tech-grid">
        <span v-if="operationId"><code>operationId</code>: {{ operationId }}</span>
        <span v-if="generation !== undefined"><code>generation</code>: {{ generation }}</span>
        <span v-if="details.sourceVehicleId"><code>sourceVehicleId</code>: {{ details.sourceVehicleId }}</span>
        <span v-if="details.candidateVehicleId"><code>candidateVehicleId</code>: {{ details.candidateVehicleId }}</span>
        <span v-if="details.vehicleId"><code>vehicleId</code>: {{ details.vehicleId }}</span>
        <span v-if="details.cause"><code>cause</code>: {{ details.cause }}</span>
        <span v-if="details.failure?.code"><code>failure</code>: {{ details.failure.code }}</span>
        <span v-if="result.message"><code>backendMessage</code>: {{ result.message }}</span>
      </div>
    </details>
    <button type="button" @click="stores.command.send('copyDiagnostics')">{{ t('status.copyDiagnostics') }}</button>
  </DetailsPanel>
</template>

<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
import DetailsPanel from "../common/DetailsPanel.vue"

const stores = useStores()
const core = stores.core.state
const layout = stores.uiLayout.state
const { t, has } = stores.i18n
const result = computed(() => core.lastResult || {})
const details = computed(() => result.value.details || {})
const coverage = computed(() => details.value.coverage || null)
const planning = computed(() => details.value.planning || details.value.stagingPreview?.planning || null)
const hasDetails = computed(() => Boolean(result.value.code))
const open = computed(() => hasDetails.value && layout.details[layout.activeTab] === true)
const outcomeLabel = computed(() => {
  const code = details.value.terminalOutcome || result.value.code
  const key = `result.${code}`
  return t(has(key) ? key : "result.unknown")
})
const resultCode = computed(() => details.value.failure?.code || result.value.code || "unknown")
const actionLabel = computed(() => {
  const key = `result.${result.value.code}`
  return t(has(key) ? key : "result.unknown")
})
const humanMessage = computed(() => {
  const key = `result.${resultCode.value}`
  return t(has(key) ? key : "result.unknown")
})
const operationId = computed(() => details.value.operationId || core.lifecycle?.operationId)
const generation = computed(() => details.value.generation ?? core.lifecycle?.operationGeneration)
const preset = computed(() => details.value.preset || stores.race.state.lineup?.current?.preset)
const seed = computed(() => details.value.episodeSeed || details.value.seed
  || stores.race.state.lineup?.current?.episodeSeed)
const phase = computed(() => details.value.phase || details.value.failure?.phase
  || core.lifecyclePhase || core.operationState)
const phaseLabel = computed(() => {
  const key = `progress.phase.${phase.value}`
  return t(has(key) ? key : "progress.phase.idle")
})
const slot = computed(() => details.value.slotId || details.value.slot
  || details.value.failure?.context?.slotId)
const model = computed(() => details.value.model || details.value.modelKey
  || details.value.failure?.modelKey)
const configuration = computed(() => details.value.configuration || details.value.configKey
  || details.value.failure?.configKey)
const concreteVehicleId = computed(() => details.value.concreteVehicleId
  || details.value.acceptedVehicleId || details.value.currentVehicleId)
const recoveryRecommendation = computed(() => {
  const action = details.value.retryAction
  const key = action && `operationDetails.recovery.${action}`
  if (key && has(key)) return t(key)
  return details.value.recoverable === true ? t("operationDetails.recovery.retry") : ""
})
const coverageLine = (value, prefix) => t("operationDetails.coverageLine", {
  changed: Number(value?.[`${prefix}Changed`] || 0),
  attempted: Number(value?.[`${prefix}Attempted`] || 0),
  classified: Number(value?.[`${prefix}Classified`] || 0),
  eligible: Number(value?.[`${prefix}Eligible`] || 0),
  unresolved: Number(value?.[`${prefix}Unresolved`] || 0),
})
</script>
