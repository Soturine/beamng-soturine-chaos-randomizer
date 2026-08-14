<template>
  <section v-if="visible" class="scr-compatibility-compact" role="status">
    <strong>{{ t('status.compatibility') }}</strong>
    <span>{{ summary }}</span>
    <div class="scr-actions">
      <button type="button" :aria-expanded="String(expanded)" @click="expanded = !expanded">{{ t('common.details') }}</button>
      <button type="button" @click="dismiss">{{ t('common.dismiss') }}</button>
    </div>
    <details v-if="expanded" open class="scr-technical-details">
      <summary>{{ t('compatibility.detectedContext') }}</summary>
      <div class="scr-tech-grid">
        <span v-for="item in conflicts" :key="item.id || item.conflictId">
          {{ conflictLabel(item) }}
          <code v-if="item.evidence">{{ item.evidence }}</code>
        </span>
      </div>
    </details>
  </section>
</template>
<script setup>
import { computed, ref } from "vue"
import { useStores } from "../../stores/index.js"
const stores = useStores()
const compatibility = stores.compatibility.state
const conflicts = computed(() => stores.core.state.conflicts || [])
const unsupported = computed(() => ["unsupported", "below_minimum"].includes(compatibility.compatibilityState || compatibility.state))
const { t, has } = stores.i18n
const expanded = ref(false)
const dismissedForSession = ref(false)
const persistedDismissal = computed(() => stores.settings.state.uiPreferences?.compatibilityWarningDismissed === true)
const visible = computed(() => !dismissedForSession.value && !persistedDismissal.value
  && (conflicts.value.length > 0 || unsupported.value))
const conflictLabel = item => {
  const key = `compatibility.conflict.${item.id || item.conflictId}`
  return t(has(key) ? key : "compatibility.conflict.generic")
}
const summary = computed(() => unsupported.value
  ? t("compatibility.unsupported")
  : conflictLabel(conflicts.value[0] || {}))
function dismiss() {
  dismissedForSession.value = true
  stores.command.send("updateUIPreferences", [{ compatibilityWarningDismissed: true }])
}
</script>
