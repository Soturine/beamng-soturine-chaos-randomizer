import { reactive } from "vue"

export const createUILayoutStore = (profiler = null) => {
  const normalMinSizeByTab = {
    chaos: { width: 320, height: 220 }, garage: { width: 320, height: 260 },
    race: { width: 320, height: 300 }, settings: { width: 320, height: 260 },
  }
  const normalPreferredWidth = 520
  const expandedSizeByTab = {
    chaos: { width: 440 }, garage: { width: 560 },
    race: { width: 620 }, settings: { width: 520 },
  }
  const compactSizeByTab = {
    chaos: { width: 340, height: 250 }, garage: { width: 340, height: 270 },
    race: { width: 360, height: 290 }, settings: { width: 340, height: 240 },
  }
  const detailsOpenByTab = { chaos: false, garage: false, race: false, settings: false }
  const lastExpandedSizeByTab = Object.fromEntries(Object.entries(normalMinSizeByTab)
    .map(([tab, minimum]) => [tab, { width: expandedSizeByTab[tab].width, height: minimum.height }]))
  const initialNormalSize = { ...lastExpandedSizeByTab.chaos }
  let normalHostBaseline = null
  let normalBaselinePending = true
  const state = reactive({
    activeTab: "chaos", raceStep: "setup", garageSection: "saved", compact: false, mode: "normal",
    details: detailsOpenByTab, detailsOpenByTab,
    garageView: "grid", width: initialNormalSize.width, height: initialNormalSize.height, reducedMotion: false,
    hostSize: { ...initialNormalSize }, normalMinSize: normalMinSizeByTab.chaos,
    normalMinSizeByTab, normalPreferredWidth,
    normalPreferredHeightByTab: Object.fromEntries(Object.entries(normalMinSizeByTab)
      .map(([tab, size]) => [tab, size.height])),
    userPreferredNormalSize: { ...initialNormalSize },
    normalSizePinned: false,
    expandedSizeByTab, compactSizeByTab, lastExpandedSizeByTab,
    userSizeByTab: lastExpandedSizeByTab,
    resizeModeByTab: { chaos: "appHost", garage: "appHost", race: "appHost", settings: "appHost" },
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
        state.compact = next
        state.mode = next ? "compact" : "normal"
        if (!next) normalBaselinePending = true
        state.geometryRevision += 1
      }
      if (profile) mutateLocal("buttonResponse", mutation)
      else mutation()
    },
    recordHostSize(width, height, { source = "appHost" } = {}) {
      const measured = {
        width: Math.max(1, Math.round(Number(width) || state.width)),
        height: Math.max(1, Math.round(Number(height) || state.height)),
      }
      state.width = measured.width
      state.height = measured.height
      state.hostSize = measured
      if (!state.compact && source === "appHost") {
        const minimum = state.normalMinSizeByTab[state.activeTab]
        if (normalBaselinePending || !normalHostBaseline) {
          normalHostBaseline = { ...measured }
          normalBaselinePending = false
          return
        }
        const changed = measured.width !== normalHostBaseline.width
          || measured.height !== normalHostBaseline.height
        if (changed && measured.width >= minimum.width && measured.height >= minimum.height) {
          normalHostBaseline = { ...measured }
          state.normalSizePinned = true
          state.userPreferredNormalSize = { ...measured }
          state.lastExpandedSizeByTab[state.activeTab] = { ...measured }
        }
      }
    },
    preferredSize(tab = state.activeTab) {
      return state.compact ? state.compactSizeByTab[tab]
        : state.normalSizePinned ? state.userPreferredNormalSize
          : { width: state.expandedSizeByTab[tab].width, height: null }
    },
    normalMinimum(tab = state.activeTab) { return { ...state.normalMinSizeByTab[tab] } },
    noteGeometryApplied() { state.geometryRevision += 1 },
    toggleDetails(tab = state.activeTab) { if (tab in state.details) mutateLocal("buttonResponse", () => { state.details[tab] = !state.details[tab] }) },
  }
}
