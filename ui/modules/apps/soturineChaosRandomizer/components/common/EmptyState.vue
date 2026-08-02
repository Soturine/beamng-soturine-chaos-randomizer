<template><div class="scr-state scr-empty" role="status"><strong>{{ t('empty.title') }}</strong><span>{{ message }}</span></div></template>
<script setup>import { useStores } from "../../stores"; defineProps({ message: { type: String, default: "" } }); const { i18n: { t } } = useStores()</script>
