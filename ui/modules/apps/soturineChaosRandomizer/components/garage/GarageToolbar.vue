<template><div class="scr-toolbar"><input type="search" :value="query.search || ''" :placeholder="t('garage.search')" @input="debouncedQuery({ search: $event.target.value })" /><select :value="query.filter || 'all'" :aria-label="t('garage.filter')" @change="queryNow({ filter: $event.target.value })"><option value="all">all</option><option value="favorite">favorite</option><option value="pinned">pinned</option></select><SegmentedControl :model-value="layout.garageView" :label="t('garage.grid')" :items="views" @update:model-value="layout.garageView = $event" /></div></template>
<script setup>
import { onUnmounted } from "vue"; import { useStores } from "../../stores"; import SegmentedControl from "../common/SegmentedControl.vue"
const stores = useStores(); const query = stores.garage.state.query || {}; const layout = stores.uiLayout.state; const { t } = stores.i18n; let timer = null
const views = [{ value: "grid", label: t("garage.grid") }, { value: "list", label: t("garage.list") }]
function queryNow(patch) { stores.command.send("setVehicleDNAQuery", [{ ...(stores.garage.state.query || {}), ...patch }]) }
function debouncedQuery(patch) { clearTimeout(timer); timer = setTimeout(() => queryNow(patch), 220) }
onUnmounted(() => clearTimeout(timer))
</script>
