<template>
  <section v-if="rootFailure" class="scr-app scr-state scr-root-failure" role="alert" :data-error-code="rootFailure.code">
    <strong>{{ stores.i18n.t("errors.panelFailed") }}</strong>
    <div class="scr-actions">
      <button type="button" class="is-hot" @click="reloadPanel">{{ stores.i18n.t("errors.reloadPanel") }}</button>
      <button type="button" @click="copyFailure">{{ stores.i18n.t("errors.copyDiagnostic") }}</button>
    </div>
  </section>
  <ErrorBoundary v-else scope="application" area-key="app.name"><AppShell /></ErrorBoundary>
</template>

<script setup>
import { onMounted, onUnmounted, provide, ref, watch } from "vue"
import { lua, useBridge } from "@/bridge"
import { useEvents } from "@/services/events"
import { useSettings as useGameSettings } from "@/services/settings"
import "./styles/app.css"
import AppShell from "./components/shell/AppShell.vue"
import ErrorBoundary from "./components/common/ErrorBoundary.vue"
import { createCommandBridge } from "./services/commandBridge.js"
import { createStateProtocol } from "./services/stateProtocol.js"
import { createLifecycleRegistry } from "./services/lifecycle.js"
import { copyText } from "./services/clipboard.js"
import { createStores, STORES_KEY } from "./stores/index.js"

const { api } = useBridge()
let stores
const command = createCommandBridge(api, () => stores?.uiLayout.state.activeTab || "shell")
stores = createStores(command)
provide(STORES_KEY, stores)

const lifecycle = createLifecycleRegistry()
const events = useEvents()
const gameSettings = useGameSettings()
let mounted = false
const protocol = createStateProtocol({
  applyFull: state => stores.applyFull(state),
  applyDiff: (domain, payload) => stores.applyDiff(domain, payload),
  requestFull: () => command.send("requestState"),
  reject: code => { stores.diagnostics.state.status = code },
})

function subscribe(name, handler) {
  const returnedCleanup = events.on(name, handler)
  lifecycle.add(typeof returnedCleanup === "function" ? returnedCleanup : () => events.off?.(name, handler))
}

// State arrives from Lua events, outside Vue's error boundaries. A failure while
// applying it must never leave an empty panel: show a recoverable root fallback.
const rootFailure = ref(null)
const recordUIError = (code, error) => {
  const failure = { code, message: String(error?.message || error || "unknown"), stack: String(error?.stack || "").slice(0, 2000) }
  stores.diagnostics.state.lastUIError = failure
  return failure
}
const applyState = envelope => {
  if (!mounted) return
  try { protocol.apply(envelope) } catch (error) { rootFailure.value = recordUIError("ui_state_apply_failed", error) }
}
function reloadPanel() {
  rootFailure.value = null
  protocol.reset()
  command.send("requestState")
}
async function copyFailure() { await copyText(JSON.stringify(rootFailure.value, null, 2)) }
// Only errors raised by this app's own code are recorded (for Details).
const ownError = event => {
  const error = event?.error || event?.reason
  const source = `${event?.filename || ""} ${error?.stack || ""}`
  if (source.includes("soturineChaosRandomizer")) recordUIError("ui_window_error", error || event?.message)
}
const copyDiagnostics = async payload => {
  if (!mounted) return
  const copied = await copyText(payload?.text)
  if (mounted) stores.diagnostics.state.status = copied ? "diagnostics_copied" : "diagnostics_copy_failed"
}

onMounted(async () => {
  mounted = true
  subscribe("SoturineChaosRandomizerState", applyState)
  subscribe("SoturineChaosRandomizerStateDiff", applyState)
  subscribe("SoturineChaosRandomizerDiagnostics", copyDiagnostics)
  window.addEventListener("error", ownError)
  window.addEventListener("unhandledrejection", ownError)
  lifecycle.add(() => {
    window.removeEventListener("error", ownError)
    window.removeEventListener("unhandledrejection", ownError)
  })
  await lua.extensions.load("soturineChaosRandomizer")
  if (!mounted) return
  await command.send("requestState")
  if (!mounted) return
  await gameSettings.waitForData()
  if (!mounted) return
  stores.i18n.setGameLocale(gameSettings.values.uiLanguage)

  const legacyKey = "soturineChaosRandomizer.racePolicy.v067"
  try {
    const raw = window.localStorage.getItem(legacyKey)
    if (raw) {
      const value = JSON.parse(raw)
      if (value && typeof value === "object" && !Array.isArray(value)) {
        const result = await command.send("migrateLegacyUIPreferences", [value])
        if (result?.success) window.localStorage.removeItem(legacyKey)
      }
    }
  } catch (error) {
    stores.diagnostics.state.status = "legacy_ui_preferences_migration_failed"
  }
})

watch(() => gameSettings.values.uiLanguage, value => stores.i18n.setGameLocale(value))

onUnmounted(() => {
  mounted = false
  lifecycle.dispose()
  protocol.reset()
  stores.status.dispose()
  command.dispose()
})
</script>
