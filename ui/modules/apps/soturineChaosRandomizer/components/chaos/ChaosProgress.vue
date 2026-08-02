<template><div v-if="core.busy" class="scr-chaos-progress"><strong>{{ core.progress?.label }}</strong><span>{{ Math.round((core.progress?.value || 0) * 100) }}%</span></div></template>
<script setup>import { useStores } from "../../stores/index.js"; const core = useStores().core.state</script>
