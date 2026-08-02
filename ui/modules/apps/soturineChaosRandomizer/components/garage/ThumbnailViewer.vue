<template><div class="scr-thumbnail" :style="fallbackStyle"><img v-if="url" :src="url" :alt="t('a11y.thumbnail', { name: entry?.name || '' })" @error="failed = true" /><span v-if="!url" aria-hidden="true">◆</span><small v-if="entry?.thumbnail?.exact === false">{{ t('garage.nonExact') }}</small></div></template>
<script setup>
import { computed, ref } from "vue"; import { useStores } from "../../stores/index.js"
const props = defineProps({ entry: { type: Object, default: null } }); const failed = ref(false); const { i18n: { t } } = useStores()
const url = computed(() => { const id = props.entry?.thumbnail?.kind === "managed" ? String(props.entry.thumbnail.managedId || "") : ""; return !failed.value && /^[A-Za-z0-9_-]{1,96}$/.test(id) ? `/settings/soturineChaosRandomizer/vehicleDNA/thumbnails/${id}.png` : "" })
const fallbackStyle = computed(() => { const c = props.entry?.thumbnail?.color; if (!Array.isArray(c) || c.length < 3) return {}; const rgb = c.slice(0, 3).map(value => Math.max(0, Math.min(255, Math.round(Number(value) * 255)))); return { backgroundColor: `rgb(${rgb.join(',')})` } })
</script>
