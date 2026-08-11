<template>
  <div v-if="!core.busy && status" class="scr-global-status" role="status" aria-live="polite" :class="`is-${status.severity || 'info'}`">
    <strong>{{ t(`result.${status.code}`, status.values) }}</strong>
    <button v-if="status.action" type="button" :disabled="core.busy" @click="retry">{{ t('common.retry') }}</button>
    <button v-if="status.recoverable" type="button" @click="dismiss">{{ t('common.dismiss') }}</button>
    <button type="button" @click="$emit('details')">{{ t('common.details') }}</button>
  </div>
</template>
<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
defineEmits(["details"])
const stores = useStores()
const core = stores.core.state
const { t } = stores.i18n
const status = computed(() => stores.status.current(stores.uiLayout.state.activeTab, core.progress?.operationId))
function retry() {
  const command = status.value?.action?.command
  if (command !== "previewRaceGeneration" && command !== "createChaosLineup") return
  stores.command.send(command, [{ ...stores.race.state.options }])
}
function dismiss() { if (status.value?.id) stores.status.remove(status.value.id) }
</script>
