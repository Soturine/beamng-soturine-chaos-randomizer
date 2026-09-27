<template>
  <article class="scr-competitor" bng-nav-item>
    <header>
      <span class="scr-position">{{ competitor.position || competitor.index }}</span>
      <input v-model="name" :aria-label="t('common.rename')" maxlength="128" @change="rename" />
      <span class="scr-state-label">{{ t(`race.slotState.${stateCode}`) }}</span>
    </header>
    <small v-if="recoveryLabel" class="scr-slot-recovery">{{ recoveryLabel }}</small>
    <div v-if="competitor.warning && stateCode === 'failed'" class="scr-banner is-warning">{{ t(`result.${competitor.failureCode || 'warning'}`) }}</div>
    <details v-if="technicalAvailable" class="scr-technical-details">
      <summary>{{ t('common.technicalDetails') }}</summary>
      <div class="scr-slot-readiness" :aria-label="t('race.readiness')">
        <span>{{ t('race.readiness.generated') }}: {{ readinessValue(competitor.generationReady) }}</span>
        <span>{{ t('race.readiness.placed') }}: {{ readinessValue(competitor.placementReady) }}</span>
        <span>{{ t('race.readiness.drivable') }}: {{ readinessValue(competitor.drivable) }}</span>
        <span>{{ t('race.readiness.ai') }}: {{ readinessValue(competitor.aiReady) }}</span>
      </div>
      <div class="scr-tech-grid">
        <span>{{ t('technical.modelId') }}: <code>{{ competitor.modelKey || '—' }}</code></span>
        <span>{{ t('technical.configurationId') }}: <code>{{ competitor.configuration || '—' }}</code></span>
        <span>{{ t('technical.seed') }}: <code>{{ competitor.derivedSeed || competitor.seed || '—' }}</code></span>
        <span v-if="competitor.acceptedVehicleId">{{ t('technical.vehicleId') }}: <code>{{ competitor.acceptedVehicleId }}</code></span>
        <span v-if="competitor.managedHandle">{{ t('technical.managedHandle') }}: <code>{{ competitor.managedHandle }}</code></span>
        <span v-if="competitor.policyDecision?.ruleId">{{ t('technical.policyRule') }}: <code>{{ competitor.policyDecision.ruleId }}</code></span>
        <span v-if="competitor.aiDispatch?.dispatchResult">{{ t('technical.aiDispatch') }}: <code>{{ competitor.aiDispatch.dispatchResult }}</code></span>
      </div>
    </details>
    <div class="scr-actions">
      <button type="button" @click="$emit('move', competitor, -1)">{{ t('race.moveUp') }}</button>
      <button type="button" @click="$emit('move', competitor, 1)">{{ t('race.moveDown') }}</button>
      <button v-if="stateCode === 'failed'" type="button" @click="$emit('failure', competitor, 'retry')">{{ t('common.retry') }}</button>
      <button v-if="stateCode === 'failed'" type="button" @click="$emit('failure', competitor, 'fallback')">{{ t('race.useOfficialFallback') }}</button>
      <button v-if="stateCode === 'failed'" type="button" @click="$emit('failure', competitor, 'skip')">{{ t('race.skip') }}</button>
      <button v-if="stateCode === 'failed'" type="button" @click="$emit('failure', competitor, 'stop')">{{ t('common.stop') }}</button>
      <button v-if="competitor.managedHandle" type="button" @click="$emit('remove', competitor)">{{ t('common.remove') }}</button>
    </div>
  </article>
</template>

<script setup>
import { computed, ref, watch } from "vue"
import { useStores } from "../../stores/index.js"
const props = defineProps({ competitor: { type: Object, required: true } })
const emit = defineEmits(["move", "failure", "remove", "rename"])
const { i18n: { t } } = useStores()
const name = ref(props.competitor.name || "")
const stateCode = computed(() => props.competitor.phase || props.competitor.status || "planned")
const technicalAvailable = computed(() => props.competitor.modelKey || props.competitor.configuration || props.competitor.seed)
const recoveryLabel = computed(() => {
  const recovery = props.competitor.recovery
  if (!recovery || stateCode.value === "failed") return ""
  if (recovery.action === "fallback") return t("race.recovery.fallback")
  const terminal = ["ready", "ready_with_warnings", "partial", "skipped", "cancelled", "removed"]
  return terminal.includes(stateCode.value) ? ""
    : t("race.recovery.retry", { attempt: Number(props.competitor.attemptCount || 0) + 1 })
})
const readinessValue = value => t(value === true ? "race.readinessValue.ready"
  : value === false ? "race.readinessValue.notReady" : "race.readinessValue.unknown")
watch(() => props.competitor.name, value => { name.value = value || "" })
const rename = () => name.value && emit("rename", props.competitor, name.value)
</script>
