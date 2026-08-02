<template><nav class="scr-nav" role="tablist" :aria-label="t('app.name')" v-bng-scoped-nav="{ type: 'container', wrapNavigation: 'horizontal' }" v-bng-on-ui-nav:tab_l="step(-1)" v-bng-on-ui-nav:tab_r="step(1)"><button v-for="tab in tabs" :key="tab" type="button" role="tab" bng-nav-item :class="{ 'is-active': active === tab }" :aria-selected="active === tab" @click="$emit('select', tab)">{{ t(`nav.${tab}`) }}</button></nav></template>
<script setup>
import { vBngOnUiNav, vBngScopedNav } from "@/common/directives"
import { useStores } from "../../stores"
const props = defineProps({ active: { type: String, required: true } }); const emit = defineEmits(["select"])
const tabs = ["chaos", "garage", "race", "settings"]; const { i18n: { t } } = useStores()
function step(delta) { const current = tabs.indexOf(props.active); emit("select", tabs[(current + delta + tabs.length) % tabs.length]) }
</script>
