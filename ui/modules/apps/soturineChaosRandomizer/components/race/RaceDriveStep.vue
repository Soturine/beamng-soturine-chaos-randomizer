<template>
  <EmptyState v-if="!ready" :message="t('race.driveEmpty')" />
  <AIDirectorControls v-else />
</template>
<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
import EmptyState from "../common/EmptyState.vue"
import AIDirectorControls from "./AIDirectorControls.vue"
const stores = useStores()
const { t } = stores.i18n
const ready = computed(() => ["lineup_ready", "lineup_partial"].includes(stores.race.state.lineup?.current?.generationState)
  && (stores.race.state.spawnDirector?.managed || []).length > 0)
</script>
