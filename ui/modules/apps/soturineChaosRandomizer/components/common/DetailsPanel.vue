<template>
  <section
    v-if="open"
    class="scr-details"
    :class="{ 'is-drawer': mode === 'drawer' }"
    :aria-label="title"
    tabindex="-1"
    v-bng-on-ui-nav:back="close"
    @keydown.escape.stop="close"
  >
    <header><strong>{{ title }}</strong><button type="button" @click="close">{{ t('common.close') }}</button></header>
    <slot />
  </section>
</template>
<script setup>
import { vBngOnUiNav } from "@/common/directives"
import { useStores } from "../../stores/index.js"
defineProps({ open: Boolean, title: { type: String, default: "Details" }, mode: { type: String, default: "inline" } })
const emit = defineEmits(["close"])
const { i18n: { t } } = useStores()
const close = () => emit("close")
</script>
