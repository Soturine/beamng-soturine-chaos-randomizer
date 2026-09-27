<template>
  <section class="scr-race-policy">
    <h4>{{ t('race.policyTitle', { preset: t(`race.presetValue.${options.preset || 'Balanced'}`) }) }}</h4>
    <small v-if="options.preset !== 'Custom'">{{ t('race.policyTemplateHint') }}</small>
    <section v-for="group in groups" :key="group.title" class="scr-policy-group">
      <h4>{{ t(group.title) }}</h4>
      <ToggleField v-for="field in group.fields" :key="field" :model-value="policy[field] === true" :label="t(`race.policy.${field}`)" @update:model-value="value => update(field, value)" />
    </section>
    <div class="scr-form-grid">
      <NumericInput :model-value="Number(policy.maximumSameFamily || 2)" :label="t('race.maxSameFamily')" :min="1" :max="32" @update:model-value="value => update('maximumSameFamily', value)" />
      <NumericInput :model-value="Number(policy.maxAttemptsPerCompetitor || 3)" :label="t('race.attempts')" :min="1" :max="10" @update:model-value="value => update('maxAttemptsPerCompetitor', value)" />
      <NumericInput :model-value="Number(policy.maxConsecutiveFailures || 4)" :label="t('race.consecutiveFailures')" :min="1" :max="32" @update:model-value="value => update('maxConsecutiveFailures', value)" />
    </div>
  </section>
</template>
<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
import ToggleField from "../common/ToggleField.vue"
import NumericInput from "../common/NumericInput.vue"
import { customizedPolicy, effectivePolicy } from "../../services/racePolicy.js"
const stores = useStores()
const options = stores.race.state.options
const { t } = stores.i18n
const groups = [
  { title: "race.duplicates", fields: ["avoidDuplicateModels", "avoidDuplicateConfigurations", "avoidDuplicateFamilies"] },
  { title: "race.diversity", fields: ["diversifyVehicleClasses", "diversifyPropulsion", "diversifyDrivetrain", "diversifySource", "diversifyWheelStyles", "diversifyBodyTypes"] },
  { title: "race.sources", fields: ["allowOfficialVehicles", "allowModVehicles", "allowAutomationVehicles", "allowTrailers", "allowProps"] },
  { title: "race.failures", fields: ["acceptPartial", "acceptMetadataUncertain", "acceptPotentiallyUndrivable", "retainAcceptedOnCancel"] },
]
const presetPolicies = computed(() => stores.race.state.lineup?.presetPolicies)
const policy = computed(() => effectivePolicy(options, presetPolicies.value))
function update(field, value) {
  options.customPolicy = customizedPolicy(options, presetPolicies.value, field, value)
  options.preset = "Custom"
  stores.command.send("updateUIPreferences", [{ race: { preset: "Custom", customPolicy: { ...options.customPolicy } } }])
}
</script>
