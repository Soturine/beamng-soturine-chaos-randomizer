<template><BngButton :icon="icon" :disabled="disabled" :aria-label="label" v-bng-tooltip:top="label" @click="$emit('click')" /></template>
<script setup>
import { BngButton } from "@/common/components/base"
import { vBngTooltip } from "@/common/directives"
defineProps({ icon: { type: [String, Object], required: true }, label: { type: String, required: true }, disabled: Boolean })
defineEmits(["click"])
</script>
