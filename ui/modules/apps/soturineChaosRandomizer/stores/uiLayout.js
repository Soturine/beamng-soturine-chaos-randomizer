import { reactive } from "vue"

export const createUILayoutStore = (profiler = null) => {
  const expandedSizeByTab = {
    chaos: { width: 440, height: 560 }, garage: { width: 560, height: 640 },
    race: { width: 620, height: 680 }, settings: { width: 520, height: 680 },
  }
  const compactSizeByTab = {
    chaos: { width: 340, height: 250 }, garage: { width: 340, height: 270 },
    race: { width: 360, height: 290 }, settings: { width: 340, height: 240 },
  }
  const detailsOpenByTab = { chaos: false, garage: false, race: false, settings: false }
  const lastExpandedSizeByTab = Object.fromEntries(
    Object.entries(expandedSizeByTab).map(([tab, size]) => [tab, { ...size }]),
  )
  const state = reactive({
    activeTab: "chaos", raceStep: "cars", garageSection: "saved", compact: false,
    details: detailsOpenByTab, detailsOpenByTab,
    garageView: "grid", width: 340, height: 520, reducedMotion: false,
    expandedSizeByTab, compactSizeByTab, lastExpandedSizeByTab,
    userSizeByTab: lastExpandedSizeByTab,
    resizeModeByTab: { chaos: "intrinsic", garage: "intrinsic", race: "intrinsic", settings: "intrinsic" },
    geometryRevision: 0,
    dialog: null, lastFocused: null,
  })
  const tabs = ["chaos", "garage", "race", "settings"]
  const mutateLocal = (kind, mutation) => {
    if (profiler?.measure) void profiler.measure(kind, mutation)
    else mutation()
  }
  return {
    name: "uiLayout", state, profiler,
    setTab(tab) { if (tabs.includes(tab)) mutateLocal("tabSwitch", () => { state.activeTab = tab }) },
    setCompact(value, profile = true) {
      const mutation = () => {
        const next = value === true
        if (next === state.compact) return
        if (next && !state.compact) {
          state.lastExpandedSizeByTab[state.activeTab] = { width: state.width, height: state.height }
        }
        state.compact = next
        const preferred = next ? state.compactSizeByTab[state.activeTab]
          : state.lastExpandedSizeByTab[state.activeTab] || state.expandedSizeByTab[state.activeTab]
        state.width = preferred.width
        state.height = preferred.height
        state.geometryRevision += 1
      }
      if (profile) mutateLocal("buttonResponse", mutation)
      else mutation()
    },
    recordHostSize(width, height) {
      state.width = Math.max(1, Math.round(Number(width) || state.width))
      state.height = Math.max(1, Math.round(Number(height) || state.height))
      if (!state.compact) state.lastExpandedSizeByTab[state.activeTab] = { width: state.width, height: state.height }
    },
    preferredSize(tab = state.activeTab) {
      return state.compact ? state.compactSizeByTab[tab]
        : state.lastExpandedSizeByTab[tab] || state.expandedSizeByTab[tab]
    },
    noteGeometryApplied() { state.geometryRevision += 1 },
    toggleDetails(tab = state.activeTab) { if (tab in state.details) mutateLocal("buttonResponse", () => { state.details[tab] = !state.details[tab] }) },
  }
}
