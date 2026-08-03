import { reactive } from "vue"

export const gameSettingsHarness = {
  values: reactive({ uiLanguage: "en-US" }),
  waitCount: 0,
  reset() {
    this.values.uiLanguage = "en-US"
    this.waitCount = 0
  },
}

export const useSettings = () => ({
  values: gameSettingsHarness.values,
  async waitForData() { gameSettingsHarness.waitCount += 1 },
})
