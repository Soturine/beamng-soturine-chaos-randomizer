<template>
  <section class="scr-card">
    <h3>{{ t('locks.summary', { count: activeCount }) }}</h3>
    <div class="scr-actions">
      <button type="button" :disabled="core.busy" @click="send('lockConfiguration', [true])">{{ t('locks.lockConfigurationCurrent') }}</button>
      <button type="button" @click="showDetails">{{ t('locks.manage') }}</button>
    </div>

    <DetailsPanel :open="open" :title="t('locks.manage')" mode="drawer" @close="open = false">
      <div class="scr-toolbar">
        <label class="scr-field"><span>{{ t('common.search') }}</span><input v-model="query" type="search" /></label>
        <ScrSelect v-model="filter" :label="t('locks.stateFilter')" :items="filterItems" />
      </div>
      <ToggleField v-model="showTechnical" :label="t('locks.showTechnicalIds')" />
      <section class="scr-lock-manager-controls">
        <h4>{{ t('locks.categories') }}</h4>
        <div class="scr-chip-grid">
          <button v-for="category in categories" :key="category" type="button" :aria-pressed="locks.categories?.[category] === true" :class="{ 'is-active': locks.categories?.[category] }" :disabled="core.busy" @click="send('lockCategory', [category, locks.categories?.[category] !== true])">{{ t(`locks.category.${category}`) }}</button>
        </div>
        <h4>{{ t('locks.presets') }}</h4>
        <div class="scr-actions">
          <button v-for="preset in presets" :key="preset" type="button" :disabled="core.busy" @click="send('applyLockPreset', [preset.toLowerCase()])">{{ t(`locks.${preset}`) }}</button>
          <button type="button" :disabled="core.busy" @click="send('updateLockProfile', [{ vehicle: false, configuration: false, categories: {}, slots: {}, parts: {}, tuning: {}, paints: {} }])">{{ t('locks.unlockAll') }}</button>
        </div>
      </section>
      <EmptyState v-if="!filteredSlots.length" :message="t('locks.noMatches')" />
      <section v-for="group in groupedSlots" :key="group.category" class="scr-lock-group">
        <h4>{{ t(`locks.category.${group.category}`) }} · {{ group.items.length }}</h4>
        <div v-for="slot in group.items" :key="slot.path" class="scr-lock-row">
          <ToggleField :model-value="slot.locked === true" :label="humanName(slot)" @update:model-value="value => setSlot(slot, value)" />
          <code v-if="showTechnical">{{ slot.path }}</code>
        </div>
      </section>
    </DetailsPanel>
  </section>
</template>

<script setup>
import { computed, ref } from "vue"
import { useStores } from "../../stores/index.js"
import DetailsPanel from "../common/DetailsPanel.vue"
import EmptyState from "../common/EmptyState.vue"
import ScrSelect from "../common/ScrSelect.vue"
import ToggleField from "../common/ToggleField.vue"
import { humanPartLabel } from "../../services/humanLabels.js"

const stores = useStores()
const core = stores.core.state
const locks = stores.chaos.state.locks
const { t } = stores.i18n
const open = ref(false)
const lockData = ref(null)
const query = ref("")
const filter = ref("all")
const showTechnical = ref(false)
const categories = ["body", "engine", "transmission", "drivetrain", "suspension", "brakes", "steering", "wheels", "tires", "aero", "interior", "electronics", "accessories", "props", "other", "tuning", "paint"]
const presets = ["everything", "visual", "mechanical", "accessories"]
const activeCount = computed(() => Number(locks.summary?.locked || 0))
const filterItems = computed(() => ["all", "locked", "unlocked"].map(value => ({ value, label: t(`locks.filter.${value}`) })))
const filteredSlots = computed(() => (lockData.value?.slots || []).filter(slot => {
  if (filter.value === "locked" && slot.locked !== true) return false
  if (filter.value === "unlocked" && slot.locked === true) return false
  const needle = query.value.trim().toLocaleLowerCase()
  return !needle || humanName(slot).toLocaleLowerCase().includes(needle)
}))
const groupedSlots = computed(() => categories.map(category => ({
  category,
  items: filteredSlots.value.filter(slot => (slot.category || "other") === category),
})).filter(group => group.items.length))

const send = (command, args = []) => stores.command.send(command, args)
function humanName(slot) {
  return humanPartLabel(slot, t)
}
async function showDetails() { lockData.value = (await send("getVehicleDNALocks"))?.result || null; open.value = true }
async function setSlot(slot, locked) {
  await send(locked ? "lockSlot" : "unlockSlot", [slot.path])
  slot.locked = locked
}
</script>
