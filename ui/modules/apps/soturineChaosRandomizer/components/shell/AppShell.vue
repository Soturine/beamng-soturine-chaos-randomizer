<template>
  <section
    ref="root"
    class="scr-app bngApp"
    :class="[{ 'is-compact': layout.compact, 'is-reduced-motion': layout.reducedMotion }, `scr-width-${widthClass}`]"
    :style="geometryStyle"
    bng-ui-scope="soturine-chaos-randomizer"
    v-bng-scoped-nav="{ scopeId: 'soturine-chaos-randomizer', type: 'container', preferAutoFocus: true }"
    v-bng-on-ui-nav:back="back"
  >
    <AppHeader @toggle-compact="toggleCompact" @settings="selectTab('settings')" />
    <CompatibilityBadge />
    <OperationProgress @cancel="cancel" />

    <section v-if="layout.compact" class="scr-compact" :aria-label="t(`nav.${layout.activeTab}`)">
      <header><strong>{{ t(`nav.${layout.activeTab}`) }}</strong><span v-if="core.busy">{{ percent }}%</span></header>
      <div v-if="layout.activeTab === 'chaos'" class="scr-compact-chaos">
        <ChaosActions />
        <button v-if="core.busy" type="button" @click="cancel">{{ t('status.cancelSafe') }}</button>
      </div>
      <div v-else-if="layout.activeTab === 'garage'" class="scr-compact-summary">
        <strong>{{ currentDNAName }}</strong>
        <span>{{ t('garage.savedCount', { count: stores.i18n.formatNumber(entries.length) }) }}</span>
        <div class="scr-actions">
          <button type="button" :disabled="!currentDNA" @click="garageStep(-1)">{{ t('common.previous') }}</button>
          <button type="button" :disabled="!currentDNA || core.busy" @click="restoreCurrentDNA">{{ t('garage.restoreExact') }}</button>
          <button type="button" :disabled="!currentDNA || core.busy" @click="stores.command.send('replayVehicleDNAGeneration', [currentDNA.id, 'original'])">{{ t('garage.replay') }}</button>
          <button type="button" :disabled="!currentDNA" @click="garageStep(1)">{{ t('common.next') }}</button>
        </div>
      </div>
      <div v-else-if="layout.activeTab === 'race'" class="scr-compact-summary">
        <strong>{{ compactRaceSummary }}</strong>
        <span>{{ t(`race.presetValue.${race.options?.preset || 'Balanced'}`) }}</span>
        <div class="scr-actions">
          <button v-if="!race.lineup?.current?.active && !core.busy" type="button" @click="stores.command.send('createChaosLineup', [{ ...race.options }])">{{ t('race.generate') }}</button>
          <button v-else type="button" @click="stores.command.send('cancelRaceGeneration')">{{ t('race.cancelGeneration') }}</button>
        </div>
      </div>
      <div v-else class="scr-compact-summary">
        <span>{{ t('settings.seedSummary', { mode: t(`settings.seedMode.${settings.seedMode || 'random'}`), content: t(`settings.content.${settings.contentFilter || 'everything'}`) }) }}</span>
        <button type="button" @click="toggleCompact">{{ t('app.settings') }}</button>
      </div>
    </section>

    <template v-else>
      <AppNavigation :active="layout.activeTab" @select="selectTab" />
      <main class="scr-body" bng-nav-scroll>
        <ErrorBoundary v-if="layout.activeTab === 'chaos'" scope="tab:chaos" area-key="nav.chaos"><ChaosPanel /></ErrorBoundary>
        <ErrorBoundary v-else-if="layout.activeTab === 'garage'" scope="tab:garage" area-key="nav.garage" back-key="errors.backToChaos" @back="selectTab('chaos')"><GaragePanel /></ErrorBoundary>
        <ErrorBoundary v-else-if="layout.activeTab === 'race'" scope="tab:race" area-key="nav.race" back-key="errors.backToChaos" @back="selectTab('chaos')"><RacePanel /></ErrorBoundary>
        <ErrorBoundary v-else scope="tab:settings" area-key="nav.settings" back-key="errors.backToChaos" @back="selectTab('chaos')"><SettingsPanel /></ErrorBoundary>
      </main>
      <GlobalStatus @details="toggleDetails" />
    </template>
    <ConfirmDialog />
  </section>
</template>

<script setup>
import { computed, nextTick, ref } from "vue"
import { vBngOnUiNav, vBngScopedNav } from "@/common/directives"
import { useStores } from "../../stores/index.js"
import { useResponsiveLayout, widthClassFor } from "../../composables/useResponsiveLayout.js"
import { confirmDialog } from "../../services/dialogs.js"
import AppHeader from "./AppHeader.vue"
import AppNavigation from "./AppNavigation.vue"
import CompatibilityBadge from "./CompatibilityBadge.vue"
import OperationProgress from "./OperationProgress.vue"
import GlobalStatus from "./GlobalStatus.vue"
import ConfirmDialog from "../common/ConfirmDialog.vue"
import ErrorBoundary from "../common/ErrorBoundary.vue"
import ChaosActions from "../chaos/ChaosActions.vue"
import ChaosPanel from "../chaos/ChaosPanel.vue"
import GaragePanel from "../garage/GaragePanel.vue"
import RacePanel from "../race/RacePanel.vue"
import SettingsPanel from "../settings/SettingsPanel.vue"
import { vehicleDisplayName } from "../../services/humanLabels.js"

const stores = useStores()
const core = stores.core.state
const race = stores.race.state
const settings = stores.settings.state
const layout = stores.uiLayout.state
const { t } = stores.i18n
const root = ref(null)
const garageIndex = ref(0)
useResponsiveLayout(root, stores.uiLayout)

const percent = computed(() => Math.round(Number(core.progress?.overallProgress ?? core.progress?.value ?? 0) * 100))
const widthClass = computed(() => widthClassFor(layout.width))
const entries = computed(() => stores.garage.state.entries || [])
const currentDNA = computed(() => {
  if (!entries.value.length) return null
  garageIndex.value = Math.min(garageIndex.value, entries.value.length - 1)
  return entries.value[garageIndex.value]
})
const currentDNAName = computed(() => currentDNA.value ? vehicleDisplayName(currentDNA.value, t) : t("garage.empty"))
const raceTotal = computed(() => Math.max(2, Number(race.options?.count || 4)))
const raceOpponents = computed(() => Math.max(1, raceTotal.value - (race.options?.participationMode === "player" ? 1 : 0)))
const compactRaceSummary = computed(() => t(
  race.options?.participationMode === "player" ? "race.configSummaryPlayer" : "race.configSummarySpectator",
  { total: raceTotal.value, opponents: raceOpponents.value },
))
const preferredSize = computed(() => stores.uiLayout.preferredSize(layout.activeTab))
const geometryStyle = computed(() => ({
  "--scr-target-width": `${preferredSize.value.width}px`,
  "--scr-target-height": `${preferredSize.value.height}px`,
}))

function selectTab(tab) { stores.uiLayout.setTab(tab) }
function garageStep(delta) { if (entries.value.length) garageIndex.value = (garageIndex.value + delta + entries.value.length) % entries.value.length }
async function restoreCurrentDNA() {
  const entry = currentDNA.value
  if (!entry) return
  await stores.command.send("preflightVehicleDNA", [entry.id, "exact"])
  if (await confirmDialog(layout, t("garage.restoreExact"), t("garage.restoreConfirm", { mode: t("garage.restoreExact"), name: entry.name }))) {
    stores.command.send("restoreVehicleDNA", [entry.id, "exact", false])
  }
}
async function toggleCompact() {
  const next = !layout.compact
  stores.uiLayout.setCompact(next)
  await nextTick()
  stores.uiLayout.noteGeometryApplied(layout.activeTab)
  stores.command.send("setUICompactMode", [next ? "collapsed" : "expanded"])
}
function toggleDetails() { stores.uiLayout.toggleDetails() }
async function cancel() { if (await confirmDialog(layout, t("status.cancelSafe"), t("status.cancelConfirm"))) stores.command.send("cancelCurrentOperation") }
function back() { if (layout.dialog) return; if (layout.detailsOpenByTab[layout.activeTab]) stores.uiLayout.toggleDetails(layout.activeTab); else if (layout.activeTab !== "chaos") selectTab("chaos") }
</script>
