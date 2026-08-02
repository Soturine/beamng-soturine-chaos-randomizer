<template><AppShell /></template>

<script setup>
import { onMounted, onUnmounted, provide, watch } from "vue"
import { lua, useBridge } from "@/bridge"
import { useEvents } from "@/services/events"
import { useSettings as useGameSettings } from "@/services/settings"
import AppShell from "./components/shell/AppShell.vue"
import { createCommandBridge } from "./services/commandBridge"
import { createStateProtocol } from "./services/stateProtocol"
import { createLifecycleRegistry } from "./services/lifecycle"
import { copyText } from "./services/clipboard"
import { createStores, STORES_KEY } from "./stores"

const { api } = useBridge()
let stores
const command = createCommandBridge(api, () => stores?.uiLayout.state.activeTab || "shell")
stores = createStores(command)
provide(STORES_KEY, stores)

const lifecycle = createLifecycleRegistry()
const events = useEvents()
const gameSettings = useGameSettings()
const protocol = createStateProtocol({
  applyFull: state => stores.applyFull(state),
  applyDiff: (domain, payload) => stores.applyDiff(domain, payload),
  requestFull: () => command.send("requestState"),
  reject: code => { stores.diagnostics.state.status = code },
})

events.on("SoturineChaosRandomizerState", envelope => protocol.apply(envelope))
events.on("SoturineChaosRandomizerStateDiff", envelope => protocol.apply(envelope))
events.on("SoturineChaosRandomizerDiagnostics", async payload => {
  const copied = await copyText(payload?.text)
  stores.diagnostics.state.status = copied ? "diagnostics_copied" : "diagnostics_copy_failed"
})

onMounted(async () => {
  await lua.extensions.load("soturineChaosRandomizer")
  await command.send("requestState")
  await gameSettings.waitForData()
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
  lifecycle.dispose()
  protocol.reset()
  command.dispose()
})
</script>

<style lang="scss">
@use "./styles/app";
</style>
