<template><button type="button" class="scr-compact-toggle" :aria-pressed="compact" @click="$emit('toggle')">{{ compact ? t('app.expand') : t('app.compact') }}</button></template>
<script setup>import { useStores } from "../../stores"; defineProps({ compact: Boolean }); defineEmits(["toggle"]); const { i18n: { t } } = useStores()</script>
