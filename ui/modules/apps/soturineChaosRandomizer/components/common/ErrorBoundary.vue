<template>
  <slot v-if="!failure" :key="retryKey" />
  <section v-else class="scr-state scr-error-boundary" role="alert" :data-error-code="failure.code">
    <strong>{{ t("errors.componentTitle", { area: areaLabel }) }}</strong>
    <span>{{ t("errors.componentBody") }}</span>
    <div class="scr-actions">
      <button type="button" @click="retry">{{ t("common.retry") }}</button>
      <button v-if="backLabel" type="button" @click="$emit('back')">{{ backLabel }}</button>
      <button type="button" @click="copyDiagnostic">{{ t("errors.copyDiagnostic") }}</button>
    </div>
  </section>
</template>

<script setup>
import { computed, onErrorCaptured, ref } from "vue"
import { copyText } from "../../services/clipboard.js"
import { useStores } from "../../stores/index.js"

const props = defineProps({
  scope: { type: String, default: "application" },
  areaKey: { type: String, default: "app.title" },
  backKey: { type: String, default: "" },
})
defineEmits(["back"])
const stores = useStores()
const { t } = stores.i18n
const failure = ref(null)
const retryKey = ref(0)
const areaLabel = computed(() => t(props.areaKey))
const backLabel = computed(() => props.backKey ? t(props.backKey) : "")

onErrorCaptured((error, instance, info) => {
  failure.value = {
    code: "ui_component_error",
    scope: props.scope,
    message: String(error?.message || error || "unknown"),
    component: instance?.$options?.name || "anonymous",
    info: String(info || ""),
  }
  stores.diagnostics.state.status = "ui_component_error"
  stores.diagnostics.state.lastUIError = { ...failure.value }
  return false
})

function retry() {
  failure.value = null
  retryKey.value += 1
}

async function copyDiagnostic() {
  const copied = await copyText(JSON.stringify(failure.value, null, 2))
  stores.diagnostics.state.status = copied ? "diagnostics_copied" : "diagnostics_copy_failed"
}
</script>
