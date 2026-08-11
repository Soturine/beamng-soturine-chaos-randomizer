<template>
  <section v-if="!ready" class="scr-card scr-race-blocked" role="status">
    <h3>{{ t(`race.${step}`) }}</h3>
    <strong>{{ t('race.blocked') }}</strong>
    <p>{{ t('race.behaviorMissingNPC') }}</p>
    <button type="button" @click="returnToPreparation">{{ t('race.generateAndPosition') }}</button>
  </section>
  <section v-else>
    <div class="scr-race-summary">
      <strong>{{ t(step === 'start' ? 'race.startReady' : 'race.behaviorReady') }}</strong>
      <span>{{ t('race.managedReady', { count: managedCount }) }}</span>
    </div>
    <AIDirectorControls />
  </section>
</template>
<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
import AIDirectorControls from "./AIDirectorControls.vue"
defineProps({ step: { type: String, default: "behavior" } })
const stores = useStores()
const { t } = stores.i18n
const managedCount = computed(() => (stores.race.state.spawnDirector?.managed || []).length)
const ready = computed(() => ["lineup_ready", "lineup_partial"].includes(stores.race.state.lineup?.current?.generationState)
  && managedCount.value > 0)
function returnToPreparation() {
  stores.uiLayout.state.raceStep = stores.race.state.lineup?.current ? "formation" : "setup"
}
</script>
