<template>
  <div v-if="!core.busy && status" class="scr-global-status" role="status" aria-live="polite" :class="`is-${status.severity || 'info'}`">
    <div class="scr-global-status-content">
      <strong>{{ statusLabel }}</strong>
      <span v-if="changeSummary">{{ changeSummary }}</span>
      <span v-if="coverageSummary">{{ coverageSummary }}</span>
      <span v-if="Number(status.values?.skipped) > 0">{{ t('result.skippedSummary', { count: status.values.skipped }) }}</span>
    </div>
    <div class="scr-global-status-actions">
      <button v-if="status.action" type="button" :disabled="core.busy" @click="retry">{{ t('common.retry') }}</button>
      <button v-if="status.recoverable || status.dismissible" type="button" @click="dismiss">{{ t('common.dismiss') }}</button>
      <button v-if="hasDetails" type="button" @click="$emit('details')">{{ t('common.details') }}</button>
    </div>
  </div>
</template>
<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
defineEmits(["details"])
const stores = useStores()
const core = stores.core.state
const { t, has } = stores.i18n
const status = computed(() => stores.status.current(stores.uiLayout.state.activeTab, core.progress?.operationId))
const hasDetails = computed(() => {
  if (!core.lastResult?.code) return false
  const resultOperation = core.lastResult.details?.operationId || null
  return !status.value?.operationId || !resultOperation || status.value.operationId === resultOperation
})
const statusLabel = computed(() => {
  const key = `result.${status.value?.code || "unknown"}`
  return t(has(key) ? key : "result.unknown", status.value?.values)
})
const coverageSummary = computed(() => {
  const values = status.value?.values || {}
  const eligible = Number(values.partsEligible || 0) + Number(values.tuningEligible || 0)
    + Number(values.paintsEligible || 0)
  const classified = Number(values.partsClassified || 0) + Number(values.tuningClassified || 0)
    + Number(values.paintsClassified || 0)
  return eligible > 0 ? t("result.coverageSummary", { classified, eligible }) : ""
})
const changeSummary = computed(() => {
  const values = status.value?.values || {}
  const total = Number(values.parts || 0) + Number(values.tuning || 0) + Number(values.paints || 0)
  return total > 0 ? t("result.changeSummary", values) : ""
})
function retry() {
  const command = status.value?.action?.command
  if (command === "retryLineupPersistence") {
    stores.command.send(command)
    return
  }
  if (command !== "previewRaceGeneration" && command !== "createChaosLineup") return
  stores.command.send(command, [{ ...stores.race.state.options }])
}
function dismiss() { if (status.value?.id) stores.status.remove(status.value.id) }
</script>
