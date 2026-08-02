<template><StatusBanner v-if="conflicts.length || unsupported" tone="warning" :title="t('status.compatibility')"><span v-if="unsupported">{{ compatibility.compatibilityState || compatibility.state }}</span><span v-for="item in conflicts" :key="item.id || item.conflictId">{{ item.label || item.conflictId }}: {{ item.message || item.recommendedAction }}</span></StatusBanner></template>
<script setup>
import { computed } from "vue"; import { useStores } from "../../stores"; import StatusBanner from "../common/StatusBanner.vue"
const stores = useStores(); const compatibility = stores.compatibility.state; const conflicts = computed(() => stores.core.state.conflicts || []); const unsupported = computed(() => ["unsupported", "below_minimum"].includes(compatibility.compatibilityState || compatibility.state)); const { t } = stores.i18n
</script>
