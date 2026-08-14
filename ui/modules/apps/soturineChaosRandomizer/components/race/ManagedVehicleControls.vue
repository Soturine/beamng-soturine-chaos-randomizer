<template>
  <section class="scr-card">
    <h3>{{ t('race.managedVehicles') }}</h3>
    <EmptyState v-if="!managed.length" :message="t('race.noLineup')" />
    <div v-else>
      <ScrSelect v-model="selected" :label="t('race.managedVehicles')" :items="managedItems" />
      <div class="scr-actions">
        <button type="button" @click="send('focusManagedVehicle')">{{ t('race.focus') }}</button>
        <button type="button" @click="send('respawnManagedVehicle')">{{ t('race.respawn') }}</button>
        <button type="button" @click="send('removeManagedVehicle')">{{ t('common.remove') }}</button>
      </div>
    </div>
  </section>
</template>

<script setup>
import { computed, ref, watch } from "vue"
import { useStores } from "../../stores/index.js"
import { normalizeManagedVehicles } from "../../services/stateNormalizer.js"
import EmptyState from "../common/EmptyState.vue"
import ScrSelect from "../common/ScrSelect.vue"

const stores = useStores()
const { t } = stores.i18n
const managed = computed(() => normalizeManagedVehicles(stores.race.state.spawnDirector?.managed))
const managedItems = computed(() => managed.value.map((item, index) => ({
  value: item.handle,
  label: item.name || t("race.managedVehicleNumber", { number: item.slotId || index + 1 }),
})))
const selected = ref("")
watch(managed, list => {
  if (!list.some(item => item.handle === selected.value)) selected.value = list[0]?.handle || ""
}, { immediate: true })
const send = command => selected.value && stores.command.send(command, [selected.value])
</script>
