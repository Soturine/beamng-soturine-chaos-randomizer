<template><div v-if="core.busy" class="scr-chaos-progress"><strong>{{ phaseLabel }}</strong><span>{{ Math.round((core.progress?.value || 0) * 100) }}%</span></div></template>
<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
const stores = useStores(); const core = stores.core.state; const { t, has } = stores.i18n
const phaseLabel = computed(() => {
  const key = `progress.phase.${core.progress?.phase || core.lifecyclePhase || "working"}`
  return t(has(key) ? key : "progress.phase.working")
})
</script>
