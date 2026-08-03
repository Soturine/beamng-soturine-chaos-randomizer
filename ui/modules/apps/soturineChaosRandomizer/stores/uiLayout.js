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
  const state = reactive({
    activeTab: "chaos", raceStep: "cars", garageSection: "saved", compact: false,
    details: { chaos: false, garage: false, race: false, settings: false },
    garageView: "grid", width: 340, height: 520, reducedMotion: false,
    expandedSizeByTab, compactSizeByTab,
    resizeModeByTab: { chaos: "host", garage: "host", race: "host", settings: "host" },
    userSizeByTab: { chaos: null, garage: null, race: null, settings: null },
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
      const mutation = () => { state.compact = value === true }
      if (profile) mutateLocal("buttonResponse", mutation)
      else mutation()
    },
    recordHostSize(width, height) {
      state.width = Math.max(1, Math.round(Number(width) || state.width))
      state.height = Math.max(1, Math.round(Number(height) || state.height))
      state.userSizeByTab[state.activeTab] = { width: state.width, height: state.height }
    },
    preferredSize(tab = state.activeTab) {
      return state.userSizeByTab[tab] || (state.compact ? state.compactSizeByTab[tab] : state.expandedSizeByTab[tab])
    },
    toggleDetails(tab = state.activeTab) { if (tab in state.details) mutateLocal("buttonResponse", () => { state.details[tab] = !state.details[tab] }) },
  }
}
