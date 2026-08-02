<template><div class="scr-state scr-error" role="alert"><strong>{{ t('error.title') }}</strong><span>{{ message }}</span></div></template>
<script setup>import { useStores } from "../../stores"; defineProps({ message: { type: String, default: "" } }); const { i18n: { t } } = useStores()</script>
