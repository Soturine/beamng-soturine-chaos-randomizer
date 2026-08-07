<template><ErrorBoundary scope="application" area-key="app.title"><AppShell /></ErrorBoundary></template>

<script setup>
import { onMounted, onUnmounted, provide, watch } from "vue"
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

const applyState = envelope => { if (mounted) protocol.apply(envelope) }
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
