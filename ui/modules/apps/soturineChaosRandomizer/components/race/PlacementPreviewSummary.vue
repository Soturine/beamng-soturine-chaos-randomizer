<template>
  <StatusBanner :tone="available ? 'success' : 'warning'" :title="t('race.preview')">
    <span>{{ available ? t('race.readyCount', { count: preview?.count || placement?.ready || 0 }) : unavailableLabel }}</span>
    <span v-if="preview?.mode">{{ t('race.previewMode', { mode: formationLabel }) }}</span>
    <template v-if="fallbackAvailable">
      <strong>{{ t('race.previewFallbackReady', { count: fallbackSlots.length }) }}</strong>
      <ol class="scr-placement-fallback">
        <li v-for="item in fallbackSlots" :key="item.slotId || item.slot">
          {{ item.name || t('race.managedVehicleNumber', { index: item.slot }) }}
        </li>
      </ol>
      <details class="scr-technical-details">
        <summary>{{ t('race.previewCoordinates') }}</summary>
        <div class="scr-tech-grid">
          <span v-for="item in fallbackSlots" :key="`position-${item.slotId || item.slot}`">
            <code>{{ item.slotId || item.slot }}</code>: {{ coordinates(item.transform?.position) }}
          </span>
        </div>
      </details>
    </template>
  </StatusBanner>
</template>
<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
import StatusBanner from "../common/StatusBanner.vue"
import { normalizeFormationCode, previewStatusKey } from "../../services/raceProtocol.js"
import { normalizePreviewSlots } from "../../services/stateNormalizer.js"
const stores = useStores()
const { t, has } = stores.i18n
const placement = computed(() => stores.race.state.spawnDirector?.placement || {})
const preview = computed(() => stores.race.state.spawnDirector?.racePreview || stores.race.state.lineup?.current?.worldPreview)
const available = computed(() => preview.value?.state === "PREVIEW_RENDERED")
const fallbackSlots = computed(() => normalizePreviewSlots(preview.value?.slots)
  .filter(item => Number(item.slot) > 0))
const fallbackAvailable = computed(() => !available.value && fallbackSlots.value.length > 0)
const unavailableLabel = computed(() => {
  if (preview.value?.state) return t(previewStatusKey(preview.value))
  const reason = String(placement.value?.reason || "")
  const key = `race.placementReason.${reason}`
  if (reason && has(key)) return t(key)
  if (/create|import|lineup_missing/i.test(reason)) return t("race.noLineup")
  return t("race.previewUnavailable")
})
const formationLabel = computed(() => t(`race.formationValue.${normalizeFormationCode(preview.value?.formation)}`))
const coordinates = position => [position?.x, position?.y, position?.z]
  .map(value => Number(value || 0).toFixed(1)).join(", ")
</script>
