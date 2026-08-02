<template><div class="scr-banner" :class="`is-${tone}`" role="status" aria-live="polite"><strong v-if="title">{{ title }}</strong><span><slot /></span></div></template>
<script setup>defineProps({ title: { type: String, default: "" }, tone: { type: String, default: "info" } })</script>
