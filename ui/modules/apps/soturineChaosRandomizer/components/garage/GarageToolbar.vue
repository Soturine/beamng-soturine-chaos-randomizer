<template>
  <div class="scr-toolbar">
    <input type="search" :value="query.search || ''" :placeholder="t('garage.search')" @input="debouncedQuery({ search: $event.target.value })" />
    <ScrSelect
      :model-value="query.filter || 'all'"
      :aria-label="t('garage.filter')"
      :items="filterItems"
      @update:model-value="value => queryNow({ filter: value })"
    />
    <SegmentedControl :model-value="layout.garageView" :label="t('garage.grid')" :items="views" @update:model-value="layout.garageView = $event" />
  </div>
</template>

<script setup>
import { computed, onUnmounted } from "vue"
import { useStores } from "../../stores/index.js"
import ScrSelect from "../common/ScrSelect.vue"
import SegmentedControl from "../common/SegmentedControl.vue"

const stores = useStores()
const query = stores.garage.state.query || {}
const layout = stores.uiLayout.state
const { t } = stores.i18n
let timer = null
const views = computed(() => [{ value: "grid", label: t("garage.grid") }, { value: "list", label: t("garage.list") }])
const filterItems = computed(() => [
  { value: "all", label: t("garage.filterAll") },
  { value: "favorite", label: t("garage.favorite") },
  { value: "pinned", label: t("garage.pin") },
])
function queryNow(patch) { stores.command.send("setVehicleDNAQuery", [{ ...(stores.garage.state.query || {}), ...patch }]) }
function debouncedQuery(patch) { clearTimeout(timer); timer = setTimeout(() => queryNow(patch), 220) }
onUnmounted(() => clearTimeout(timer))
</script>
