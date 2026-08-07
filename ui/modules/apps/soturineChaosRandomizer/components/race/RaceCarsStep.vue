<template>
  <section>
    <div class="scr-card scr-form-grid">
      <NumericInput :model-value="Number(options.count || 4)" :label="t('race.totalVehicles')" :min="1" :max="32" @update:model-value="value => update('count', value)" />
      <ScrSelect :model-value="options.participationMode || 'spectator'" :label="t('race.participation')" :items="participationItems" @update:model-value="value => update('participationMode', value)" />
      <label class="scr-field"><span>{{ t('race.episodeSeed') }}</span><input :value="options.episodeSeed || ''" maxlength="128" @change="update('episodeSeed', $event.target.value)" /></label>
      <ScrSelect :model-value="options.preset || 'Balanced'" :label="t('race.preset')" :items="presetItems" @update:model-value="preset" />
    </div>
    <div class="scr-race-counters" role="status" aria-live="polite">
      <span>{{ t('race.counter.configured', { count: Number(options.count || 0) }) }}</span>
      <span>{{ t('race.counter.planned', { count: Number(summary.plannedOpponents || 0) }) }}</span>
      <span>{{ t('race.counter.generated', { count: Number(summary.generated || 0) }) }}</span>
      <span>{{ t('race.counter.ready', { count: Number(summary.ready || 0) }) }}</span>
      <span>{{ t('race.counter.failed', { count: Number(summary.failed || 0) }) }}</span>
    </div>
    <RacePolicyPanel :open="false" />
    <div class="scr-actions">
      <button v-if="!current?.active && !core.busy" type="button" class="is-hot" :disabled="conflict" @click="generate">{{ t('race.generate') }}</button>
      <button v-else type="button" @click="stores.command.send('cancelRaceGeneration')">{{ t('race.cancelGeneration') }}</button>
      <button type="button" @click="stores.command.send('exportChaosLineup')">{{ t('common.export') }}</button>
      <button type="button" @click="stores.command.send('importChaosLineup')">{{ t('common.import') }}</button>
    </div>
    <CompetitorList />
  </section>
</template>

<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
import NumericInput from "../common/NumericInput.vue"
import ScrSelect from "../common/ScrSelect.vue"
import RacePolicyPanel from "./RacePolicyPanel.vue"
import CompetitorList from "./CompetitorList.vue"

const stores = useStores()
const core = stores.core.state
const options = stores.race.state.options
const { t } = stores.i18n
const current = computed(() => stores.race.state.lineup?.current)
const summary = computed(() => current.value?.summary || {})
const conflict = computed(() => !options.allowOfficialVehicles && !options.allowModVehicles)
const presets = ["Balanced", "Maximum Chaos", "Mods Showcase", "Custom"]
const participationItems = computed(() => [
  { value: "player", label: t("race.player") },
  { value: "spectator", label: t("race.spectator") },
])
const presetItems = computed(() => presets.map(value => ({ value, label: t(`race.presetValue.${value}`) })))
const balancedPolicy = Object.freeze({ acceptPartial: false, acceptMetadataUncertain: false, acceptPotentiallyUndrivable: false, avoidDuplicateModels: true, avoidDuplicateConfigurations: true, avoidDuplicateFamilies: false, maximumSameFamily: 2, diversifyVehicleClasses: true, diversifyPropulsion: false, diversifyDrivetrain: false, diversifySource: true, diversifyWheelStyles: false, diversifyBodyTypes: false, allowOfficialVehicles: true, allowModVehicles: true, allowAutomationVehicles: false, allowTrailers: false, allowProps: false, maxAttemptsPerCompetitor: 3, maxConsecutiveFailures: 4, retainAcceptedOnCancel: true })
const presetValues = { "Balanced": { ...balancedPolicy }, "Maximum Chaos": { ...balancedPolicy, acceptPartial: true, acceptMetadataUncertain: true, acceptPotentiallyUndrivable: true }, "Mods Showcase": { ...balancedPolicy, acceptMetadataUncertain: true, allowOfficialVehicles: false, allowModVehicles: true } }
function update(field, value) { options[field] = value; if (field !== "preset") options.preset = "Custom"; stores.command.send("updateUIPreferences", [{ race: { [field]: value, ...(field !== "preset" ? { preset: "Custom" } : {}) } }]) }
function preset(value) { Object.assign(options, presetValues[value] || {}, { preset: value }); stores.command.send("updateUIPreferences", [{ race: { ...options } }]) }
function generate() { stores.command.send("createChaosLineup", [{ ...options }]) }
</script>
