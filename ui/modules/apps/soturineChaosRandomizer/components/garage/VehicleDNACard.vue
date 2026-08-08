<template>
  <article class="scr-dna-card" :class="{ 'is-selected': selected }" bng-nav-item>
    <button type="button" class="scr-card-main" @click="$emit('select', entry)">
      <ThumbnailViewer :entry="entry" />
      <span><strong>{{ title }}</strong><small>{{ summary }}</small></span>
    </button>
    <div class="scr-actions scr-card-actions">
      <button type="button" :disabled="busy" @click="$emit('restore', entry)">{{ t('garage.restoreExact') }}</button>
      <button type="button" :disabled="busy" @click="$emit('replay', entry)">{{ t('garage.replay') }}</button>
      <button type="button" :aria-label="t('garage.favorite')" :aria-pressed="entry.favorite === true" :disabled="busy" @click="$emit('favorite', entry)">★</button>
    </div>
  </article>
</template>
<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
import { vehicleDisplayName, vehicleSummary } from "../../services/humanLabels.js"
import ThumbnailViewer from "./ThumbnailViewer.vue"
const props = defineProps({ entry: { type: Object, required: true }, selected: Boolean, busy: Boolean })
defineEmits(["select", "restore", "replay", "favorite"])
const { i18n: { t } } = useStores()
const title = computed(() => vehicleDisplayName(props.entry, t))
const summary = computed(() => vehicleSummary(props.entry, t))
</script>
