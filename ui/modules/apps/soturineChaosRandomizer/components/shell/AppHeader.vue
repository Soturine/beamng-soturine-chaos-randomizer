<template>
  <header class="scr-header">
    <img src="../../assets/fox-mark.svg" alt="" aria-hidden="true" />
    <div class="scr-brand"><span>{{ t('app.owner') }}</span><strong>{{ t('app.name') }}</strong></div>
    <span class="scr-version">v{{ core.extensionVersion || '0.7.4' }}</span>
    <button type="button" :aria-label="layout.compact ? t('app.expand') : t('app.compact')" @click="$emit('toggle-compact')">{{ layout.compact ? '▾' : '▴' }}</button>
    <button type="button" :aria-label="t('app.settings')" @click="$emit('settings')">⚙</button>
  </header>
</template>
<script setup>
import { useStores } from "../../stores/index.js"
defineEmits(["toggle-compact", "settings"])
const stores = useStores(); const core = stores.core.state; const layout = stores.uiLayout.state; const { t } = stores.i18n
</script>
