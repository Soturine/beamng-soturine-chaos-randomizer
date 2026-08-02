<template><span class="scr-tooltip-anchor" :aria-describedby="id"><slot /><span :id="id" class="scr-tooltip" role="tooltip">{{ text }}</span></span></template>
<script setup>const props = defineProps({ text: { type: String, required: true }, id: { type: String, default: "scr-tooltip" } })</script>
