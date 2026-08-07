import { flushPromises, mount } from "@vue/test-utils"
import { nextTick } from "vue"
import { describe, expect, it, vi } from "vitest"

import App from "../../ui/modules/apps/soturineChaosRandomizer/app.vue"
import AppShell from "../../ui/modules/apps/soturineChaosRandomizer/components/shell/AppShell.vue"
import ScrSelect from "../../ui/modules/apps/soturineChaosRandomizer/components/common/ScrSelect.vue"
import { createDefaultState } from "../../ui/modules/apps/soturineChaosRandomizer/services/defaultState.js"
import { createStores, STORES_KEY } from "../../ui/modules/apps/soturineChaosRandomizer/stores/index.js"
import { bridgeHarness } from "./mocks/bridge.js"
import { eventHarness } from "./mocks/events.js"
import { gameSettingsHarness } from "./mocks/settings.js"
import { resizeHarness } from "./mounted.setup.js"

const settle = async () => {
  await flushPromises()
  await nextTick()
  await Promise.resolve()
}

const choose = async (scope, value) => {
  await scope.find(".bng-smart-select-trigger").trigger("click")
  await scope.find(`[role="option"][data-value="${value}"]`).trigger("click")
  await settle()
}

const mountShell = () => {
  const command = { calls: [], async send(name, args = []) { this.calls.push([name, args]); return { success: true } } }
  const stores = createStores(command)
  const wrapper = mount(AppShell, {
    attachTo: document.body,
    global: { provide: { [STORES_KEY]: stores } },
  })
  return { wrapper, stores, command }
}

describe("mounted Runtime UI", () => {
  it("mounts app.vue once, subscribes explicitly, and requests one full state", async () => {
    const wrapper = mount(App, { attachTo: document.body })
    await settle()

    expect(wrapper.find(".scr-app").exists()).toBe(true)
    expect(wrapper.findAll('.scr-nav [role="tab"]')).toHaveLength(4)
    expect(bridgeHarness.loaded).toEqual(["soturineChaosRandomizer"])
    expect(bridgeHarness.envelopes.filter(value => value.command === "requestState")).toHaveLength(1)
    expect(eventHarness.total).toBe(3)
    expect(resizeHarness.active()).toBe(1)

    wrapper.unmount()
    expect(eventHarness.total).toBe(0)
    expect(resizeHarness.active()).toBe(0)
  })

  it("renders all primary panels, Race Policy, details, and compact mode", async () => {
    const { wrapper, stores } = mountShell()
    await settle()
    const tabs = () => wrapper.findAll('.scr-nav [role="tab"]')

    await tabs()[1].trigger("click")
    expect(wrapper.find("#scr-garage-title").exists()).toBe(true)
    expect(wrapper.findAll(".scr-body > .scr-panel")).toHaveLength(1)

    await tabs()[2].trigger("click")
    expect(wrapper.find("#scr-race-title").exists()).toBe(true)
    const policy = wrapper.find("details.scr-card")
    expect(policy.exists()).toBe(true)
    expect(policy.find("summary").text()).toContain("Race Policy")
    await policy.find("summary").trigger("click")
    expect(policy.element.open).toBe(true)

    await tabs()[3].trigger("click")
    expect(wrapper.find("#scr-settings-title").exists()).toBe(true)
    expect(wrapper.findAll(".scr-body .scr-card").length).toBeGreaterThanOrEqual(6)

    await tabs()[0].trigger("click")
    stores.core.state.lastResult = { success: true, message: "Done" }
    await nextTick()
    await wrapper.find(".scr-global-status button").trigger("click")
    await settle()
    expect(wrapper.find(".scr-details").exists()).toBe(true)
    await wrapper.find(".scr-details header button").trigger("click")
    expect(wrapper.find(".scr-details").exists()).toBe(false)

    await wrapper.find('button[aria-label="Compact mode"]').trigger("click")
    await settle()
    expect(wrapper.find(".scr-compact").exists()).toBe(true)
    await wrapper.find('button[aria-label="Expanded mode"]').trigger("click")
    await settle()
    expect(wrapper.find(".scr-body").exists()).toBe(true)
    wrapper.unmount()
  })

  it("uses real Vue reactivity for automatic game language changes", async () => {
    gameSettingsHarness.values.uiLanguage = "es-MX"
    const wrapper = mount(App, { attachTo: document.body })
    await settle()
    expect(wrapper.findAll('.scr-nav [role="tab"]')[3].text()).toBe("Ajustes")

    gameSettingsHarness.values.uiLanguage = "pt-PT"
    await nextTick()
    expect(wrapper.findAll('.scr-nav [role="tab"]')[3].text()).toBe("Configurações")

    gameSettingsHarness.values.uiLanguage = "de-DE"
    await nextTick()
    expect(wrapper.findAll('.scr-nav [role="tab"]')[3].text()).toBe("Settings")

    await wrapper.findAll('.scr-nav [role="tab"]')[3].trigger("click")
    const localeSelect = wrapper.findAll(".scr-select")[0]
    await choose(localeSelect, "es-ES")
    expect(wrapper.findAll('.scr-nav [role="tab"]')[3].text()).toBe("Ajustes")
    expect(bridgeHarness.envelopes.some(value => value.command === "updateUIPreferences"
      && value.arguments[0].localeMode === "manual" && value.arguments[0].manualLocale === "es-ES")).toBe(true)

    gameSettingsHarness.values.uiLanguage = "pt-BR"
    await nextTick()
    expect(wrapper.findAll('.scr-nav [role="tab"]')[3].text()).toBe("Ajustes")
    await choose(localeSelect, "auto")
    expect(wrapper.findAll('.scr-nav [role="tab"]')[3].text()).toBe("Configurações")
    wrapper.unmount()
  })

  it("uses official smart selects without native controls and preserves instance isolation", async () => {
    const { wrapper } = mountShell()
    await settle()
    expect(wrapper.findAll("select")).toHaveLength(0)

    await wrapper.findAll('.scr-nav [role="tab"]')[3].trigger("click")
    await settle()
    expect(wrapper.findAll("select")).toHaveLength(0)
    expect(wrapper.findAll(".bng-smart-select-trigger").length).toBeGreaterThanOrEqual(5)

    const controls = wrapper.findAll(".scr-select")
    await controls[0].find(".bng-smart-select-trigger").trigger("click")
    await controls[1].find(".bng-smart-select-trigger").trigger("click")
    expect(controls[0].find('[role="listbox"]').exists()).toBe(true)
    expect(controls[1].find('[role="listbox"]').exists()).toBe(true)
    await controls[0].find(".bng-smart-select-trigger").trigger("keydown", { key: "Escape" })
    expect(controls[0].find('[role="listbox"]').exists()).toBe(false)
    expect(controls[1].find('[role="listbox"]').exists()).toBe(true)
    wrapper.unmount()
  })

  it("keeps smart-select state synchronized over 50 selections and honors disabled state", async () => {
    const wrapper = mount(ScrSelect, {
      attachTo: document.body,
      props: {
        modelValue: "a",
        label: "Fixture",
        items: [{ value: "a", label: "Alpha" }, { value: "b", label: "Bravo" }],
        "onUpdate:modelValue": value => wrapper.setProps({ modelValue: value }),
      },
    })
    for (let cycle = 0; cycle < 50; cycle += 1) {
      const value = cycle % 2 === 0 ? "b" : "a"
      await choose(wrapper, value)
      expect(wrapper.props("modelValue")).toBe(value)
      expect(wrapper.find(".bng-smart-select-trigger").text()).toBe(value === "a" ? "Alpha" : "Bravo")
    }
    await wrapper.setProps({ disabled: true, modelValue: "b" })
    expect(wrapper.find(".bng-smart-select-trigger").attributes("disabled")).toBeDefined()
    expect(wrapper.find(".bng-smart-select-trigger").text()).toBe("Bravo")
    wrapper.unmount()
  })

  it("normalizes map-shaped managed vehicles at ingress without crashing placement", async () => {
    const { wrapper, stores } = mountShell()
    const source = {
      beta: { name: "Beta", status: "ready" },
      alpha: { handle: "physical-alpha", name: "Alpha", status: "placed" },
    }
    stores.applyDiff("race", { spawnDirector: { managed: source } })
    stores.uiLayout.setTab("race")
    stores.uiLayout.state.raceStep = "placement"
    await settle()

    expect(stores.race.state.spawnDirector.managed.map(item => item.handle)).toEqual(["physical-alpha", "beta"])
    expect(stores.diagnostics.state.protocolErrors.at(-1)).toMatchObject({
      code: "normalized_state_shape",
      path: "spawnDirector.managed",
      receivedType: "object_map",
    })
    expect(wrapper.find(".scr-panel").text()).toContain("Alpha")
    expect(wrapper.findAll("select")).toHaveLength(0)
    wrapper.unmount()
  })

  it("opens backend-driven Details and applies domain diffs without a full request", async () => {
    const wrapper = mount(App, { attachTo: document.body })
    await settle()
    const initialRequests = bridgeHarness.envelopes.filter(value => value.command === "requestState").length
    const state = createDefaultState()
    state.lastResult = { success: true, message: "Completed" }
    eventHarness.emit("SoturineChaosRandomizerState", {
      protocolVersion: 2,
      stateVersion: 1,
      eventType: "full",
      domain: "all",
      payload: state,
    })
    await nextTick()
    expect(wrapper.find(".scr-global-status").text()).toContain("Completed")

    eventHarness.emit("SoturineChaosRandomizerStateDiff", {
      protocolVersion: 2,
      stateVersion: 2,
      eventType: "diff",
      domain: "core",
      payload: { seed: "mounted-diff-seed" },
      dirtySections: ["core"],
    })
    await nextTick()
    expect(wrapper.find(".scr-global-status").text()).toContain("mounted-diff-seed")
    expect(bridgeHarness.envelopes.filter(value => value.command === "requestState")).toHaveLength(initialRequests)
    wrapper.unmount()
  })

  it("deduplicates ResizeObserver callbacks and commits at most once per frame", async () => {
    const { wrapper, stores } = mountShell()
    await settle()
    const observer = resizeHarness.instances.at(-1)
    observer.emit(400, 500)
    observer.emit(400, 500)
    observer.emit(400, 500)
    observer.emit(410, 510)
    observer.emit(420, 520)
    await settle()

    expect(stores.uiPerformance.state.resizeObserverCallbacks).toBe(5)
    expect(stores.uiPerformance.state.resizeUpdates).toBe(1)
    expect(stores.uiPerformance.state.resizeCallbacksDeduplicated).toBe(2)
    expect(stores.uiLayout.state.width).toBe(420)
    expect(stores.uiLayout.state.height).toBe(520)

    observer.emit(600, 700)
    wrapper.unmount()
    await settle()
    expect(stores.uiLayout.state.width).toBe(420)
    expect(resizeHarness.active()).toBe(0)
  })

  it("keeps synthetic mounted tab and local-button p95 below 50 ms", async () => {
    const { wrapper, stores } = mountShell()
    await settle()
    for (let index = 0; index < 40; index += 1) {
      const tabs = wrapper.findAll('.scr-nav [role="tab"]')
      await tabs[index % tabs.length].trigger("click")
      await settle()
      expect(wrapper.findAll(".scr-body > .scr-panel")).toHaveLength(1)
    }
    for (let index = 0; index < 20; index += 1) {
      const label = stores.uiLayout.state.compact ? "Expanded mode" : "Compact mode"
      await wrapper.find(`button[aria-label="${label}"]`).trigger("click")
      await settle()
    }
    const summary = stores.uiPerformance.summary.value
    expect(summary.tabSwitchP95Ms).toBeLessThan(50)
    expect(summary.buttonResponseP95Ms).toBeLessThan(50)
    expect(summary.renderCount).toBe(60)
    expect(summary.fullStateApplies).toBe(0)
    expect(summary.diffApplies).toBe(0)
    console.log(`SCR_UI_LATENCY_METRICS ${JSON.stringify(summary)}`)
    wrapper.unmount()
  })

  it("returns subscriptions, observers, and handlers to baseline over 100 mounted cycles", async () => {
    vi.useFakeTimers()
    try {
      const timerBaseline = vi.getTimerCount()
      for (let cycle = 0; cycle < 100; cycle += 1) {
        const wrapper = mount(App, { attachTo: document.body })
        await settle()
        expect(eventHarness.total).toBe(3)
        expect(resizeHarness.active()).toBe(1)
        wrapper.unmount()
        expect(eventHarness.total).toBe(0)
        expect(resizeHarness.active()).toBe(0)
        expect(vi.getTimerCount()).toBe(timerBaseline)
      }
      expect(bridgeHarness.envelopes.filter(value => value.command === "requestState")).toHaveLength(100)
      expect(eventHarness.total).toBe(0)
      expect(resizeHarness.active()).toBe(0)
      expect(vi.getTimerCount()).toBe(timerBaseline)
    } finally {
      vi.useRealTimers()
    }
  }, 60_000)
})
