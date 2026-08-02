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
      <label class="scr-field"><span>{{ t('race.aiMode') }}</span><select v-model="options.mode"><option v-for="mode in aiModes" :key="mode" :value="mode">{{ t(`race.aiModeValue.${mode}`) }}</option></select></label>
      <NumericInput v-model="options.speedKph" :label="t('race.speed')" :min="0" :max="500" />
      <label class="scr-field"><span>{{ t('race.speedMode') }}</span><select v-model="options.speedMode"><option value="limit">{{ t('race.speedLimit') }}</option><option value="set">{{ t('race.speedSet') }}</option><option value="legal">{{ t('race.speedLegal') }}</option></select></label>
      <NumericInput v-model="options.aggression" :label="t('race.aggression')" :min="0.2" :max="2" :step="0.05" />
      <ToggleField v-model="options.driveInLane" :label="t('race.driveLane')" />
      <ToggleField v-model="options.avoidCars" :label="t('race.avoidCars')" />
      <NumericInput v-model="options.delay" :label="t('race.delay')" :min="0" :max="60" :step="0.1" />
      <NumericInput v-model="options.stagger" :label="t('race.stagger')" :min="0" :max="10" :step="0.1" />
      <label class="scr-field"><span>{{ t('race.finishAction') }}</span><select v-model="options.finishAction"><option value="stop">{{ t('common.stop') }}</option><option value="loop">{{ t('race.loop') }}</option></select></label>
      <ToggleField v-model="options.recoveryWhenStuck" :label="t('race.recovery')" />
      <label class="scr-field"><span>{{ t('race.stuckAction') }}</span><select v-model="options.stuckAction"><option value="none">{{ t('common.none') }}</option><option value="respawn">{{ t('race.respawn') }}</option><option value="stop">{{ t('common.stop') }}</option></select></label>
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
import { useStores } from "../../stores/index.js"
import NumericInput from "../common/NumericInput.vue"
import ToggleField from "../common/ToggleField.vue"
import StatusBanner from "../common/StatusBanner.vue"
const stores = useStores(); const director = stores.race.state.aiDirector; const options = stores.race.state.aiOptions; const { t } = stores.i18n; const aiModes = ["Destination", "Route", "Follow", "Chase", "Flee"]; const send = (command, args = []) => stores.command.send(command, args)
</script>
