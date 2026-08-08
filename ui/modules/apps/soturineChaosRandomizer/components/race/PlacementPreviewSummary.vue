<template>
  <StatusBanner :tone="available ? 'success' : 'warning'" :title="t('race.preview')">
    <span>{{ available ? t('race.readyCount', { count: preview?.count || placement?.ready || 0 }) : unavailableLabel }}</span>
    <span v-if="preview?.mode">{{ t('race.previewMode', { mode: formationLabel }) }}</span>
  </StatusBanner>
</template>
<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
import StatusBanner from "../common/StatusBanner.vue"
const stores = useStores()
const { t, has } = stores.i18n
const placement = computed(() => stores.race.state.spawnDirector?.placement || {})
const preview = computed(() => stores.race.state.spawnDirector?.preview)
const available = computed(() => placement.value.available === true || Number(preview.value?.count || 0) > 0)
const unavailableLabel = computed(() => {
  const reason = String(placement.value?.reason || "")
  const key = `race.placementReason.${reason}`
  if (reason && has(key)) return t(key)
  if (/create|import|lineup_missing/i.test(reason)) return t("race.noLineup")
  return t("race.previewUnavailable")
})
const formationLabel = computed(() => t(`race.formationValue.${preview.value?.mode || 'Automatic Best Fit'}`))
</script>
