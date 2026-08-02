import { reactive } from "vue"

export const createUILayoutStore = () => {
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
  return {
    name: "uiLayout", state,
    setTab(tab) { if (tabs.includes(tab)) state.activeTab = tab },
    setCompact(value) { state.compact = value === true },
    recordHostSize(width, height) {
      state.width = Math.max(1, Math.round(Number(width) || state.width))
      state.height = Math.max(1, Math.round(Number(height) || state.height))
      state.userSizeByTab[state.activeTab] = { width: state.width, height: state.height }
    },
    preferredSize(tab = state.activeTab) {
      return state.userSizeByTab[tab] || (state.compact ? state.compactSizeByTab[tab] : state.expandedSizeByTab[tab])
    },
    toggleDetails(tab = state.activeTab) { if (tab in state.details) state.details[tab] = !state.details[tab] },
  }
}
