<template>
  <section v-if="open" class="scr-details" :aria-label="title">
    <header><strong>{{ title }}</strong><button type="button" @click="$emit('close')">{{ t('common.close') }}</button></header>
    <slot />
  </section>
</template>
<script setup>
import { useStores } from "../../stores"
defineProps({ open: Boolean, title: { type: String, default: "Details" } })
defineEmits(["close"])
const { i18n: { t } } = useStores()
</script>
