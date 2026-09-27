<template>
  <section class="scr-panel" aria-labelledby="scr-race-title">
    <h2 id="scr-race-title" class="scr-sr-only">{{ t('nav.race') }}</h2>
    <SegmentedControl v-model="layout.raceStep" :label="t('nav.race')" :items="steps" />
    <ErrorBoundary
      :key="layout.raceStep"
      :scope="`race:${layout.raceStep}`"
      :area-key="`race.${layout.raceStep}`"
      back-key="errors.backToCars"
      @back="layout.raceStep = 'setup'"
    >
      <RaceCarsStep v-if="layout.raceStep === 'setup'" />
      <RacePlacementStep v-else-if="layout.raceStep === 'formation'" />
      <RaceDriveStep v-else-if="layout.raceStep === 'behavior'" />
      <RaceStartStep v-else />
    </ErrorBoundary>
  </section>
</template>

<script setup>
import { computed, onUnmounted } from "vue"
import { useStores } from "../../stores/index.js"
import ErrorBoundary from "../common/ErrorBoundary.vue"
import SegmentedControl from "../common/SegmentedControl.vue"
import RaceCarsStep from "./RaceCarsStep.vue"
import RacePlacementStep from "./RacePlacementStep.vue"
import RaceDriveStep from "./RaceDriveStep.vue"
import RaceStartStep from "./RaceStartStep.vue"
const stores = useStores()
const layout = stores.uiLayout.state
const { t } = stores.i18n
const steps = computed(() => ["setup", "formation", "behavior", "start"].map(value => ({ value, label: t(`race.${value}`) })))
// Leaving Events never leaves world markers behind.
onUnmounted(() => {
  if (stores.race.state.racePreview?.enabled) stores.command.send("previewLineupSpawn", [{ previewEnabled: false }])
})
</script>
