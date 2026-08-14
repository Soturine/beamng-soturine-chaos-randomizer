<template>
  <section class="scr-card">
    <div class="scr-form-grid">
      <ScrSelect v-model="left" :label="t('garage.left')" :items="entryItems" />
      <ScrSelect v-model="right" :label="t('garage.right')" :items="entryItems" />
    </div>
    <button type="button" :disabled="!left || !right || left === right" @click="compare">{{ t('garage.compareAction') }}</button>
    <div v-if="comparison" class="scr-diff-list">
      <strong>{{ comparison.equal ? t('garage.equal') : t('garage.differences', { count: differenceCount }) }}</strong>
      <div v-for="difference in comparison.differences || []" :key="`${difference.section}:${difference.path}`">
        <code>{{ difference.section }}.{{ difference.path }}</code>
        <span>{{ display(difference.left) }} → {{ display(difference.right) }}</span>
      </div>
    </div>
  </section>
</template>

<script setup>
import { computed, ref } from "vue"
import { useStores } from "../../stores/index.js"
import { normalizeGarageEntries } from "../../services/stateNormalizer.js"
import ScrSelect from "../common/ScrSelect.vue"

const stores = useStores()
const { t } = stores.i18n
const left = ref("")
const right = ref("")
const entries = computed(() => normalizeGarageEntries(stores.garage.state.entries))
const entryItems = computed(() => [{ value: "", label: "—" }, ...entries.value.map(entry => ({
  value: entry.id,
  label: entry.name || entry.id,
}))])
const comparison = computed(() => stores.garage.state.comparison)
const differenceCount = computed(() => comparison.value?.differenceCount || comparison.value?.differences?.length || 0)
const compare = () => stores.command.send("compareVehicleDNA", [left.value, right.value])
const display = value => typeof value === "object" ? JSON.stringify(value) : String(value ?? "—")
</script>
