<template>
  <section class="scr-race-step">
    <dl class="scr-card scr-start-summary">
      <dt>{{ t('race.episodeSeed') }}</dt><dd><code>{{ lineup?.episodeSeed || '—' }}</code></dd>
      <dt>{{ t('race.npcs') }}</dt><dd>{{ t('race.summary.aiReady', { count: aiReady, total: plannedOpponents }) }}</dd>
      <dt>{{ t('race.formation') }}</dt><dd>{{ t(`race.formationValue.${formation}`) }} · {{ t('race.summary.positioned', { count: summary.positioned || 0, total: summary.generationReady || 0 }) }}</dd>
      <dt>{{ t('race.behavior') }}</dt><dd>{{ behavior ? t(`race.aiPreset.${behavior}`) : t('race.behaviorNotChosen') }}</dd>
      <dt>{{ t('race.warnings') }}</dt><dd>{{ warningCount ? t('race.warningCount', { count: warningCount }) : t('common.none') }}</dd>
    </dl>

    <div v-if="blocked" class="scr-race-summary is-blocked" role="status">
      <strong>{{ t('race.fixGenerationOrPlacement') }}</strong>
      <button type="button" @click="layout.raceStep = 'setup'">{{ t('race.backToPreparation') }}</button>
    </div>
    <div v-else-if="!behavior" class="scr-race-summary is-blocked" role="status">
      <strong>{{ t('race.behaviorNotChosen') }}</strong>
      <button type="button" @click="layout.raceStep = 'behavior'">{{ t('race.chooseBehavior') }}</button>
    </div>
    <div class="scr-actions">
      <button type="button" class="is-hot" :disabled="blocked || !behavior || core.busy" @click="start">{{ t('race.startEvent') }}</button>
      <button v-if="running" type="button" @click="stores.command.send('pauseManagedAI')">{{ t('race.pauseAll') }}</button>
      <button v-if="running" type="button" @click="stores.command.send('resumeManagedAI')">{{ t('race.resumeAll') }}</button>
      <button v-if="running" type="button" @click="stores.command.send('stopManagedAI')">{{ t('race.stopAll') }}</button>
    </div>
    <div v-if="startResult" class="scr-race-summary" :class="{ 'is-warning': startResult.failed > 0 }" role="status" aria-live="polite">
      <strong>{{ t('race.summary.aiStarted', { count: startResult.started, total: startResult.requested }) }}</strong>
      <span v-if="startResult.failed > 0">{{ t('race.summary.aiNotStarted', { count: startResult.failed }) }}</span>
    </div>
  </section>
</template>

<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
import { useRaceReadiness } from "../../composables/useRaceReadiness.js"
import { normalizeFormationCode } from "../../services/raceProtocol.js"

const stores = useStores()
const core = stores.core.state
const layout = stores.uiLayout.state
const { t } = stores.i18n
const { lineup, summary, aiReady, plannedOpponents, blocked } = useRaceReadiness(stores)
const behavior = computed(() => stores.race.state.aiOptions.behaviorPreset || "")
const formation = computed(() => normalizeFormationCode(stores.race.state.placementOptions.mode))
const warningCount = computed(() => (lineup.value?.warnings?.length || 0) + Number(summary.value.failed || 0))
const running = computed(() => (stores.race.state.aiDirector?.vehicles || []).some(vehicle => vehicle.status && vehicle.status !== "idle" && vehicle.status !== "stopped"))
const startResult = computed(() => {
  const result = core.lastResult
  if (!String(result?.code || "").startsWith("ai_director_")) return null
  const details = result.details || {}
  return { requested: Number(details.requested || 0), started: Number(details.started || 0), failed: Number(details.failed || 0) }
})
const start = () => stores.command.send("startAIQuickPreset", [behavior.value])
</script>
