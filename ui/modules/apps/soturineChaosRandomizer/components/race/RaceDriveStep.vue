<template>
  <section v-if="blocked" class="scr-card scr-race-blocked" role="status">
    <h3>{{ t('race.behaviorBlocked') }}</h3>
    <strong>{{ t('race.summary.aiReady', { count: aiReady, total: plannedOpponents }) }}</strong>
    <p>{{ t('race.fixGenerationOrPlacement') }}</p>
    <button type="button" @click="layout.raceStep = 'setup'">{{ t('race.backToPreparation') }}</button>
  </section>
  <section v-else class="scr-race-step">
    <div class="scr-race-summary" role="status">
      <strong>{{ t('race.summary.aiReady', { count: aiReady, total: plannedOpponents }) }}</strong>
      <span>{{ t('race.behaviorReady') }}</span>
    </div>
    <div class="scr-behavior-grid" role="radiogroup" :aria-label="t('race.behavior')">
      <button v-for="preset in quickPresets" :key="preset" type="button" role="radio"
        :aria-checked="selected === preset" :class="{ 'is-active': selected === preset }"
        @click="selected = preset">{{ t(`race.aiPreset.${preset}`) }}</button>
    </div>
    <div class="scr-actions">
      <button type="button" class="is-hot" :disabled="!selected" @click="layout.raceStep = 'start'">{{ t('race.continueToStart') }}</button>
    </div>
    <details class="scr-card scr-progressive">
      <summary>{{ t('race.advancedOptions') }}</summary>
      <AIDirectorControls />
    </details>
  </section>
</template>

<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
import AIDirectorControls from "./AIDirectorControls.vue"
import { useRaceReadiness } from "../../composables/useRaceReadiness.js"

const stores = useStores()
const layout = stores.uiLayout.state
const { t } = stores.i18n
const { aiReady, plannedOpponents, blocked } = useRaceReadiness(stores)
const quickPresets = computed(() => stores.race.state.aiDirector?.capabilities?.quickPresets || [])
const selected = computed({
  get: () => stores.race.state.aiOptions.behaviorPreset || "",
  set: value => { stores.race.state.aiOptions.behaviorPreset = value },
})
</script>
