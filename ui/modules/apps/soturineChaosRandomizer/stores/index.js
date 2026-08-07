import { inject } from "vue"
import { createDefaultState } from "../services/defaultState.js"
import { createI18n } from "../services/i18n.js"
import { createCoreStore } from "./core.js"
import { createChaosStore } from "./chaos.js"
import { createGarageStore } from "./garage.js"
import { createRaceStore } from "./race.js"
import { createSettingsStore } from "./settings.js"
import { createCompatibilityStore } from "./compatibility.js"
import { createDiagnosticsStore } from "./diagnostics.js"
import { createPerformanceStore } from "./performance.js"
import { createUILayoutStore } from "./uiLayout.js"
import { createUIPerformanceProfiler } from "../services/uiPerformance.js"
import { normalizeDomainPayload, normalizeFullState } from "../services/stateNormalizer.js"
import { createStatusLifecycle } from "../services/statusLifecycle.js"

export const STORES_KEY = Symbol("soturine-chaos-stores")

const CORE_FIELDS = [
  "extensionVersion", "busy", "operationState", "lifecyclePhase", "progress",
  "lastResult", "lastFailure", "seed", "capabilities", "conflicts", "lifecycle",
  "transaction", "history", "canUndo", "index", "migration",
]

const pick = (source, fields) => Object.fromEntries(fields.filter(key => key in source).map(key => [key, source[key]]))

export function createStores(command) {
  const initial = createDefaultState()
  const uiPerformance = createUIPerformanceProfiler()
  let lastResultStatusSignature = ""
  const stores = {
    core: createCoreStore(pick(initial, CORE_FIELDS)),
    chaos: createChaosStore({ locks: initial.locks, settings: initial.settings }),
    garage: createGarageStore(initial.garage),
    race: createRaceStore({
      lineup: initial.lineup,
      spawnDirector: initial.spawnDirector,
      aiDirector: initial.aiDirector,
      options: {},
      placementOptions: {
        mode: "Automatic Best Fit", count: 4, spacingMode: "automatic", spacing: 7,
        longitudinalSpacing: 8, lateralSpacing: 5, safetyMargin: 1.5, availableWidth: null,
        rows: 2, columns: 2, radius: 14, headingMode: "camera", headingOffset: 0,
        groundOffset: 0.2, minimumObjectDistance: 3, interval: 0.75, spawnAll: true,
        useNextLineupCompetitor: true, selectedDNAId: "", customPointX: 0,
        customPointY: 0, customPointZ: 0,
      },
      aiOptions: {
        mode: "Destination", speedKph: 65, speedMode: "limit", aggression: 0.5,
        driveInLane: true, avoidCars: true, delay: 0, stagger: 0.5, arrivalRadius: 8,
        timeout: 600, finishAction: "stop", loop: false, recoveryWhenStuck: false,
        stuckAction: "none", stuckTimeout: 12, maxReplans: 2,
        allowDamagedVehicles: true, targetVehicleId: null, handles: [],
      },
    }),
    settings: createSettingsStore(initial.settings),
    compatibility: createCompatibilityStore(initial.compatibility),
    diagnostics: createDiagnosticsStore({ migration: initial.migration, status: "" }),
    performance: createPerformanceStore(initial.performance),
    uiLayout: createUILayoutStore(uiPerformance),
    uiPerformance,
    status: createStatusLifecycle(),
    i18n: createI18n(),
    command,
  }

  const syncStatus = () => {
    const core = stores.core.state
    if (core.busy) {
      stores.status.replaceOperation({
        code: core.progress?.phase || core.lifecyclePhase || "working",
        severity: "info", operationId: core.progress?.operationId,
        persistent: true,
      })
      return
    }
    stores.status.replaceOperation(null)
    const result = core.lastResult
    if (!result?.code) return
    const signature = `${result.success}:${result.code}:${result.details?.operationId || ""}`
    if (signature === lastResultStatusSignature) return
    lastResultStatusSignature = signature
    stores.status.push({
      code: result.code,
      scope: "tab",
      tab: stores.uiLayout.state.activeTab,
      severity: result.success === false ? "error" : "success",
      ttl: result.success === false ? 12000 : 5000,
    })
  }

  stores.applyFull = state => {
    const started = globalThis.performance?.now?.() ?? Date.now()
    const issues = []
    state = normalizeFullState(state, issue => issues.push(issue))
    stores.core.replace(pick(state, CORE_FIELDS))
    stores.chaos.replace({ locks: state.locks || {}, settings: state.settings || {} })
    stores.garage.replace(state.garage || {})
    const placementOptions = stores.race.state.placementOptions || {}
    const aiOptions = stores.race.state.aiOptions || {}
    const racePreferences = state.settings?.uiPreferences?.race || {}
    Object.assign(placementOptions, {
      mode: racePreferences.formation || placementOptions.mode,
      spacingMode: racePreferences.spacingMode || placementOptions.spacingMode,
      longitudinalSpacing: racePreferences.longitudinalSpacing ?? placementOptions.longitudinalSpacing,
      lateralSpacing: racePreferences.lateralSpacing ?? placementOptions.lateralSpacing,
      safetyMargin: racePreferences.safetyMargin ?? placementOptions.safetyMargin,
    })
    stores.race.replace({
      lineup: state.lineup || {}, spawnDirector: state.spawnDirector || {}, aiDirector: state.aiDirector || {},
      options: racePreferences, placementOptions, aiOptions,
    })
    stores.settings.replace(state.settings || {})
    stores.compatibility.replace(state.compatibility || {})
    stores.diagnostics.replace({ migration: state.migration || {}, status: stores.diagnostics.state.status || "" })
    if (issues.length) stores.diagnostics.state.protocolErrors = issues
    stores.performance.replace(state.performance || {})
    stores.uiLayout.setCompact(state.uiMode === "collapsed", false)
    const preferences = state.settings?.uiPreferences || {}
    stores.i18n.setPreference({
      localeMode: preferences.localeMode || (preferences.locale && preferences.locale !== "auto" ? "manual" : "auto"),
      manualLocale: preferences.manualLocale || (preferences.locale !== "auto" ? preferences.locale : "en-US"),
    })
    stores.uiPerformance.recordApply("full", started, state)
    syncStatus()
  }

  stores.applyDiff = (domain, payload) => {
    const started = globalThis.performance?.now?.() ?? Date.now()
    const issues = []
    payload = normalizeDomainPayload(domain, payload, issue => issues.push(issue))
    if (domain === "core") stores.core.patch(payload)
    else if (domain === "chaos") stores.chaos.patch(payload)
    else if (domain === "garage") stores.garage.patch(payload)
    else if (domain === "race") stores.race.patch(payload)
    else if (domain === "settings") stores.settings.patch(payload)
    else if (domain === "compatibility") stores.compatibility.patch(payload)
    else if (domain === "diagnostics") stores.diagnostics.patch(payload)
    else if (domain === "performance") stores.performance.patch(payload)
    if (issues.length) {
      stores.diagnostics.state.protocolErrors = [
        ...(stores.diagnostics.state.protocolErrors || []),
        ...issues,
      ].slice(-20)
    }
    stores.uiPerformance.recordApply("diff", started, payload)
    if (domain === "core") syncStatus()
  }

  return stores
}

export function useStores() {
  const stores = inject(STORES_KEY)
  if (!stores) throw new Error("Soturine Chaos stores were not provided")
  return stores
}
