<template>
  <section v-if="core.busy" class="scr-progress" aria-live="polite">
    <div>
      <strong>{{ phaseLabel }}</strong>
      <span>{{ t('status.progress', { percent }) }}</span>
    </div>
    <span v-if="attempt > 1">{{ t('status.attempt', { current: attempt, total: attemptTotal }) }}</span>
    <div class="scr-progress-track" role="progressbar" :aria-label="t('a11y.progress')" aria-valuemin="0" aria-valuemax="100" :aria-valuenow="percent"><i :style="{ width: `${percent}%` }"></i></div>
    <button type="button" @click="$emit('cancel')">{{ t('status.cancelSafe') }}</button>
  </section>
</template>
<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
defineEmits(["cancel"])
const stores = useStores()
const core = stores.core.state
const { t, has } = stores.i18n
const progress = computed(() => core.progress || {})
const percent = computed(() => Math.round(Number(progress.value.overallProgress ?? progress.value.value ?? 0) * 100))
const phaseLabel = computed(() => {
  const key = `progress.phase.${progress.value.phase || core.lifecyclePhase || 'working'}`
  return t(has(key) ? key : "progress.phase.working")
})
const attempt = computed(() => Number(progress.value.attempt || 1))
const attemptTotal = computed(() => Number(progress.value.attemptTotal || attempt.value))
</script>
