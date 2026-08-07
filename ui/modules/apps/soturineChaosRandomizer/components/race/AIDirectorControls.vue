<template>
  <section>
    <div class="scr-card">
      <h3>{{ t('race.destination') }}</h3>
      <StatusBanner>{{ director.destination?.status || 'empty' }}</StatusBanner>
      <div class="scr-actions">
        <button type="button" @click="send('placeAIDestination')">{{ t('race.placeDestination') }}</button>
        <button type="button" @click="send('confirmAIDestination', ['exact'])">{{ t('race.confirmDestination') }}</button>
        <button type="button" @click="send('confirmAIDestination', ['snap'])">{{ t('race.snapDestination') }}</button>
        <button type="button" @click="send('clearAIDestination')">{{ t('race.clearDestination') }}</button>
      </div>
      <h3>{{ t('race.route') }}</h3>
      <div class="scr-actions">
        <button type="button" @click="send('addAIRoutePoint')">{{ t('race.addRoute') }}</button>
        <button type="button" @click="send('editAIRoute', ['remove'])">{{ t('race.undoRoute') }}</button>
        <button type="button" @click="send('editAIRoute', ['reverse'])">{{ t('race.reverseRoute') }}</button>
        <button type="button" @click="send('editAIRoute', ['clear'])">{{ t('race.clearRoute') }}</button>
      </div>
    </div>
    <div class="scr-card scr-form-grid">
      <ScrSelect v-model="options.mode" :label="t('race.aiMode')" :items="aiModeItems" />
      <NumericInput v-model="options.speedKph" :label="t('race.speed')" :min="0" :max="500" />
      <ScrSelect v-model="options.speedMode" :label="t('race.speedMode')" :items="speedModeItems" />
      <NumericInput v-model="options.aggression" :label="t('race.aggression')" :min="0.2" :max="2" :step="0.05" />
      <ToggleField v-model="options.driveInLane" :label="t('race.driveLane')" />
      <ToggleField v-model="options.avoidCars" :label="t('race.avoidCars')" />
      <NumericInput v-model="options.delay" :label="t('race.delay')" :min="0" :max="60" :step="0.1" />
      <NumericInput v-model="options.stagger" :label="t('race.stagger')" :min="0" :max="10" :step="0.1" />
      <ScrSelect v-model="options.finishAction" :label="t('race.finishAction')" :items="finishItems" />
      <ToggleField v-model="options.recoveryWhenStuck" :label="t('race.recovery')" />
      <ScrSelect v-model="options.stuckAction" :label="t('race.stuckAction')" :items="stuckItems" />
    </div>
    <div class="scr-actions">
      <button type="button" class="is-hot" @click="send('startManagedAI', [{ ...options }])">{{ t('race.startAll') }}</button>
      <button type="button" @click="send('pauseManagedAI')">{{ t('race.pauseAll') }}</button>
      <button type="button" @click="send('resumeManagedAI')">{{ t('race.resumeAll') }}</button>
      <button type="button" @click="send('stopManagedAI')">{{ t('race.stopAll') }}</button>
      <button type="button" @click="send('resetManagedAI')">{{ t('race.resetAll') }}</button>
    </div>
    <div class="scr-managed-ai"><article v-for="vehicle in director.vehicles || []" :key="vehicle.handle"><strong>{{ vehicle.name || vehicle.handle }}</strong><code>{{ vehicle.status }}</code><ToggleField :model-value="vehicle.recording === true" :label="t('race.recording')" @update:model-value="value => send('setAIRecording', [vehicle.handle, value])" /></article></div>
  </section>
</template>
<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
import NumericInput from "../common/NumericInput.vue"
import ScrSelect from "../common/ScrSelect.vue"
import ToggleField from "../common/ToggleField.vue"
import StatusBanner from "../common/StatusBanner.vue"
const stores = useStores(); const director = stores.race.state.aiDirector; const options = stores.race.state.aiOptions; const { t } = stores.i18n; const aiModes = ["Destination", "Route", "Follow", "Chase", "Flee"]
const aiModeItems = computed(() => aiModes.map(value => ({ value, label: t(`race.aiModeValue.${value}`) })))
const speedModeItems = computed(() => [{ value: "limit", label: t("race.speedLimit") }, { value: "set", label: t("race.speedSet") }, { value: "legal", label: t("race.speedLegal") }])
const finishItems = computed(() => [{ value: "stop", label: t("common.stop") }, { value: "loop", label: t("race.loop") }])
const stuckItems = computed(() => [{ value: "none", label: t("common.none") }, { value: "respawn", label: t("race.respawn") }, { value: "stop", label: t("common.stop") }])
const send = (command, args = []) => stores.command.send(command, args)
</script>
