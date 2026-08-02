<template>
  <dialog v-if="dialog" open class="scr-dialog" :aria-label="t('a11y.dialog')" v-bng-scoped-nav="{ scopeId: 'scr-confirm', activateOnMount: true, preferAutoFocus: true, trapPolicy: 'always' }" v-bng-on-ui-nav:back,menu="cancel">
    <form method="dialog" @submit.prevent="confirm">
      <h3>{{ dialog.title }}</h3><p>{{ dialog.message }}</p>
      <div class="scr-dialog-actions"><button type="button" @click="cancel">{{ t('common.cancel') }}</button><button type="submit" class="is-hot" autofocus>{{ dialog.confirmLabel || t('common.confirm') }}</button></div>
    </form>
  </dialog>
</template>
<script setup>
import { vBngOnUiNav, vBngScopedNav } from "@/common/directives"
import { computed, nextTick } from "vue"
import { useStores } from "../../stores/index.js"
const stores = useStores(); const { t } = stores.i18n
const dialog = computed(() => stores.uiLayout.state.dialog)
function finish(accepted) { const current = stores.uiLayout.state.dialog; stores.uiLayout.state.dialog = null; current?.resolve?.(accepted); nextTick(() => current?.returnFocus?.focus?.()) }
function confirm() { finish(true) }
function cancel() { finish(false) }
</script>
