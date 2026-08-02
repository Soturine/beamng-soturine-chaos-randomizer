<template><section class="scr-card"><h3>{{ t('chaos.rerollUnlocked') }}</h3><div class="scr-actions"><button type="button" :disabled="core.busy" @click="send('small')">{{ t('mutation.small') }}</button><button type="button" :disabled="core.busy" @click="send('medium')">{{ t('mutation.medium') }}</button><button type="button" :disabled="core.busy" @click="send('wild')">{{ t('mutation.wild') }}</button><button type="button" :disabled="core.busy" @click="stores.command.send('rerollUnlocked', [{}])">{{ t('chaos.rerollUnlocked') }}</button></div></section></template>
<script setup>
import { computed } from "vue"; import { useStores } from "../../stores"
const stores = useStores(); const core = stores.core.state; const { t } = stores.i18n; const selected = computed(() => stores.garage.state.selectedId)
const send = strength => selected.value && stores.command.send("mutateVehicleDNA", [selected.value, strength, {}])
</script>
