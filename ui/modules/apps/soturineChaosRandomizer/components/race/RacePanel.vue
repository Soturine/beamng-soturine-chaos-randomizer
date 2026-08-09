<template>
  <section class="scr-panel" aria-labelledby="scr-race-title">
    <h2 id="scr-race-title" class="scr-sr-only">{{ t('nav.race') }}</h2>
    <RaceStepper v-model="layout.raceStep" />
    <ErrorBoundary
      :key="layout.raceStep"
      :scope="`race:${layout.raceStep}`"
      :area-key="`race.step.${layout.raceStep}`"
      back-key="errors.backToCars"
      @back="layout.raceStep = 'setup'"
    >
      <RaceCarsStep v-if="layout.raceStep === 'setup'" />
      <RacePlacementStep v-else-if="layout.raceStep === 'formation'" />
      <RaceDriveStep v-else />
    </ErrorBoundary>
  </section>
</template>

<script setup>
import { useStores } from "../../stores/index.js"
import ErrorBoundary from "../common/ErrorBoundary.vue"
import RaceStepper from "./RaceStepper.vue"
import RaceCarsStep from "./RaceCarsStep.vue"
import RacePlacementStep from "./RacePlacementStep.vue"
import RaceDriveStep from "./RaceDriveStep.vue"
const stores = useStores()
const layout = stores.uiLayout.state
const { t } = stores.i18n
</script>
