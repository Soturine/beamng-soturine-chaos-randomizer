<template>
  <div v-if="!core.busy" class="scr-global-status" role="status" aria-live="polite" :class="`is-${status?.severity || 'info'}`">
    <strong>{{ status ? t(`result.${status.code}`, status.values) : t('app.ready') }}</strong>
    <button v-if="status" type="button" @click="$emit('details')">{{ t('common.details') }}</button>
  </div>
</template>
<script setup>
import { computed } from "vue"
import { useStores } from "../../stores/index.js"
defineEmits(["details"])
const stores = useStores()
const core = stores.core.state
const { t } = stores.i18n
const status = computed(() => stores.status.current(stores.uiLayout.state.activeTab, core.progress?.operationId))
</script>
