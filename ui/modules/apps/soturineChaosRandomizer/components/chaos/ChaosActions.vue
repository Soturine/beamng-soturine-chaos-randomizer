<template><div class="scr-primary-actions"><button type="button" :disabled="blocked('randomConfig')" @click="run('randomConfig')">{{ t('chaos.randomCar') }}</button><button type="button" :disabled="blocked('scramble')" @click="run('scramble')">{{ t('chaos.scramble') }}</button><button type="button" class="is-hot" :disabled="blocked('fullRandom')" @click="run('fullRandom')">{{ t('chaos.fullRandom') }}</button></div></template>
<script setup>
import { useStores } from "../../stores"
const stores = useStores(); const core = stores.core.state; const settings = stores.settings.state; const { t } = stores.i18n
const blocked = action => core.busy || core.capabilities?.[action] === false
const run = action => stores.command.send("runAction", [action, { ...settings }])
</script>
