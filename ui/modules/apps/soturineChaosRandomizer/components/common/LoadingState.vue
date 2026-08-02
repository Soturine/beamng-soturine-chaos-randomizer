<template><div class="scr-state scr-loading" role="status" aria-live="polite"><span class="scr-spinner" aria-hidden="true"></span>{{ message }}</div></template>
<script setup>defineProps({ message: { type: String, default: "Loading…" } })</script>
