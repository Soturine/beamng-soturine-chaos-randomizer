<template>
  <details class="scr-card" :open="open">
    <summary>{{ t('race.advancedOptions') }}</summary>
    <StatusBanner v-if="conflict" tone="error">{{ t('race.policyConflict') }}</StatusBanner>
    <section v-for="group in groups" :key="group.title" class="scr-policy-group">
      <h4>{{ t(group.title) }}</h4>
      <ToggleField v-for="field in group.fields" :key="field" :model-value="options[field] === true" :label="t(`race.policy.${field}`)" @update:model-value="value => update(field, value)" />
    </section>
    <div class="scr-form-grid">
      <NumericInput :model-value="Number(options.maximumSameFamily || 2)" :label="t('race.maxSameFamily')" :min="1" :max="32" @update:model-value="value => update('maximumSameFamily', value)" />
      <NumericInput :model-value="Number(options.maxAttemptsPerCompetitor || 3)" :label="t('race.attempts')" :min="1" :max="10" @update:model-value="value => update('maxAttemptsPerCompetitor', value)" />
      <NumericInput :model-value="Number(options.maxConsecutiveFailures || 4)" :label="t('race.consecutiveFailures')" :min="1" :max="32" @update:model-value="value => update('maxConsecutiveFailures', value)" />
    </div>
  </details>
</template>
<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
import ToggleField from "../common/ToggleField.vue"
import NumericInput from "../common/NumericInput.vue"
import StatusBanner from "../common/StatusBanner.vue"
defineProps({ open: Boolean })
const stores = useStores()
const options = stores.race.state.options
const { t } = stores.i18n
const groups = [
  { title: "race.duplicates", fields: ["avoidDuplicateModels", "avoidDuplicateConfigurations", "avoidDuplicateFamilies"] },
  { title: "race.diversity", fields: ["diversifyVehicleClasses", "diversifyPropulsion", "diversifyDrivetrain", "diversifySource", "diversifyWheelStyles", "diversifyBodyTypes"] },
  { title: "race.sources", fields: ["allowOfficialVehicles", "allowModVehicles", "allowAutomationVehicles", "allowTrailers", "allowProps"] },
  { title: "race.failures", fields: ["acceptPartial", "acceptMetadataUncertain", "acceptPotentiallyUndrivable", "retainAcceptedOnCancel"] },
]
const conflict = computed(() => options.allowOfficialVehicles === false && options.allowModVehicles === false)
function update(field, value) { options[field] = value; options.preset = "Custom"; stores.command.send("updateUIPreferences", [{ race: { [field]: value, preset: "Custom" } }]) }
</script>
