import { flushPromises, mount } from "@vue/test-utils"
import { defineComponent, h, nextTick } from "vue"
import { describe, expect, it, vi } from "vitest"

import App from "../../ui/modules/apps/soturineChaosRandomizer/app.vue"
import AppShell from "../../ui/modules/apps/soturineChaosRandomizer/components/shell/AppShell.vue"
import ScrSelect from "../../ui/modules/apps/soturineChaosRandomizer/components/common/ScrSelect.vue"
import ErrorBoundary from "../../ui/modules/apps/soturineChaosRandomizer/components/common/ErrorBoundary.vue"
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
    const policy = wrapper.findAll("details.scr-card").find(item => item.find("summary").text().includes("Advanced options"))
    expect(policy).toBeTruthy()
    await policy.find("summary").trigger("click")
    expect(policy.element.open).toBe(true)

    await tabs()[3].trigger("click")
    expect(wrapper.find("#scr-settings-title").exists()).toBe(true)
    expect(wrapper.findAll(".scr-body .scr-card").length).toBeGreaterThanOrEqual(6)

    await tabs()[0].trigger("click")
    stores.status.push({ code: "completed", scope: "tab", tab: "chaos", severity: "success" })
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

  it("uses AppHost width classes at every required width and keeps Race selects usable", async () => {
    const { wrapper, stores } = mountShell()
    await settle()
    const observer = resizeHarness.instances.at(-1)
    const expected = new Map([
      [320, "narrow"], [360, "narrow"], [400, "medium"], [440, "medium"],
      [520, "medium"], [560, "medium"], [640, "wide"], [720, "wide"],
    ])
    for (const [width, widthClass] of expected) {
      observer.emit(width, 640)
      await settle()
      expect(stores.uiLayout.state.width).toBe(width)
      expect(wrapper.find(".scr-app").classes()).toContain(`scr-width-${widthClass}`)
    }

    await wrapper.findAll('.scr-nav [role="tab"]')[2].trigger("click")
    await settle()
    const raceSelects = wrapper.findAll(".scr-select")
    expect(raceSelects.length).toBeGreaterThanOrEqual(2)
    await raceSelects[0].find(".bng-smart-select-trigger").trigger("click")
    expect(raceSelects[0].find('[role="listbox"]').exists()).toBe(true)
    expect(raceSelects[0].find(".scr-smart-select").exists()).toBe(true)
    await raceSelects[0].find(".bng-smart-select-trigger").trigger("keydown", { key: "Escape" })
    expect(raceSelects[0].find('[role="listbox"]').exists()).toBe(false)
    wrapper.unmount()
  })

  it("keeps full lock administration inside a dismissible drawer", async () => {
    const { wrapper } = mountShell()
    await settle()
    expect(wrapper.find(".scr-lock-manager-controls").exists()).toBe(false)
    const manage = wrapper.findAll(".scr-card button").find(button => button.text() === "Manage locks")
    expect(manage).toBeTruthy()
    await manage.trigger("click")
    await settle()
    expect(wrapper.find(".scr-details.is-drawer").exists()).toBe(true)
    expect(wrapper.find(".scr-lock-manager-controls").exists()).toBe(true)
    await wrapper.find(".scr-details.is-drawer").trigger("keydown", { key: "Escape" })
    await settle()
    expect(wrapper.find(".scr-details.is-drawer").exists()).toBe(false)
    wrapper.unmount()
  })

  it("cycles every compact tab 50 times with tab-specific content and no idle footer", async () => {
    const { wrapper, stores } = mountShell()
    stores.garage.state.entries = [{ id: "dna-1", name: "us_semi DNA", final: { modelKey: "us_semi" } }]
    stores.race.state.options.count = 4
    stores.race.state.options.participationMode = "player"
    await settle()
    const expectedText = {
      chaos: "Random car",
      garage: "Gavril T-Series",
      race: "player + 3 opponents",
      settings: "Open settings",
    }
    const tabs = ["chaos", "garage", "race", "settings"]
    for (let tabIndex = 0; tabIndex < tabs.length; tabIndex += 1) {
      const tab = tabs[tabIndex]
      await wrapper.findAll('.scr-nav [role="tab"]')[tabIndex].trigger("click")
      for (let cycle = 0; cycle < 50; cycle += 1) {
        await wrapper.find('button[aria-label="Compact mode"]').trigger("click")
        await settle()
        expect(stores.uiLayout.state.activeTab).toBe(tab)
        expect(wrapper.find(".scr-compact").text()).toContain(expectedText[tab])
        expect(wrapper.find(".scr-global-status").exists()).toBe(false)
        expect(wrapper.find(".scr-body").exists()).toBe(false)
        await wrapper.find('button[aria-label="Expanded mode"]').trigger("click")
        await settle()
        expect(stores.uiLayout.state.activeTab).toBe(tab)
        expect(wrapper.find(".scr-body").exists()).toBe(true)
      }
    }
    wrapper.unmount()
  }, 60_000)

  it("translates placement unavailability instead of rendering backend English or policy codes", async () => {
    const { wrapper, stores } = mountShell()
    stores.race.state.spawnDirector.placement = { available: false, reason: "Create or import a Race first." }
    stores.uiLayout.setTab("race")
    stores.uiLayout.state.raceStep = "formation"
    await settle()
    expect(wrapper.text()).not.toContain("Create or import a Race first.")
    expect(wrapper.text()).toContain("Generate or import a lineup first.")
    expect(wrapper.text()).not.toMatch(/waiting_[a-z_]+|tracking_[a-z_]+/)
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
    stores.uiLayout.state.raceStep = "formation"
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

  it("keeps Events behavior presets simple and advanced AI controls disclosed", async () => {
    const { wrapper, stores } = mountShell()
    stores.race.state.aiDirector.capabilities = {
      supportedModes: ["Destination", "Route", "Follow", "Chase", "Flee", "Traffic", "Roam"],
      quickPresets: ["Follow", "Convoy", "Chase", "Flee", "Traffic", "Roam", "Swarm"],
    }
    stores.race.state.lineup = { current: { generationState: "lineup_ready" } }
    stores.race.state.spawnDirector.managed = [{ handle: "npc-1", name: "Alpha", status: "ready" }]
    stores.uiLayout.setTab("race")
    stores.uiLayout.state.raceStep = "behavior"
    await settle()

    const panel = wrapper.find(".scr-panel")
    for (const label of ["Follow me", "Convoy", "Chase", "Flee", "Chaotic traffic", "Roam", "Swarm"]) {
      expect(panel.text()).toContain(label)
    }
    const advanced = panel.findAll("details").find(item => item.find("summary").text().includes("Advanced options"))
    expect(advanced).toBeTruthy()
    expect(advanced.element.open).toBe(false)
    await advanced.find("summary").trigger("click")
    expect(advanced.element.open).toBe(true)
    expect(advanced.text()).toContain("AI mode")
    expect(wrapper.findAll("select")).toHaveLength(0)
    await advanced.find("summary").trigger("click")
    expect(advanced.element.open).toBe(false)
    wrapper.unmount()
  })

  it("isolates component failures, keeps the surrounding shell, and retries without backend commands", async () => {
    const command = { calls: [], async send(name, args = []) { this.calls.push([name, args]); return { success: true } } }
    const stores = createStores(command)
    let mounts = 0
    const ThrowingChild = defineComponent({
      name: "ThrowingPlacementFixture",
      setup() { mounts += 1; throw new Error("managed state incompatible") },
      render: () => h("div"),
    })
    const ShellFixture = defineComponent({
      setup: () => () => h("main", [
        h("nav", { class: "fixture-nav" }, "Navigation remains"),
        h(ErrorBoundary, { scope: "race:placement", areaKey: "race.step.placement", backKey: "errors.backToCars" }, { default: () => h(ThrowingChild) }),
      ]),
    })
    const wrapper = mount(ShellFixture, { global: { provide: { [STORES_KEY]: stores } } })
    await settle()
    expect(wrapper.find(".fixture-nav").exists()).toBe(true)
    expect(wrapper.find(".scr-error-boundary").text()).toContain("Could not load Placement")
    expect(wrapper.find(".scr-error-boundary").attributes("data-error-code")).toBe("ui_component_error")
    await wrapper.find(".scr-error-boundary button").trigger("click")
    await settle()
    expect(wrapper.find(".scr-error-boundary").exists()).toBe(true)
    expect(mounts).toBe(2)
    expect(command.calls).toHaveLength(0)
    wrapper.unmount()
  })

  it("opens backend-driven Details and applies domain diffs without a full request", async () => {
    const wrapper = mount(App, { attachTo: document.body })
    await settle()
    const initialRequests = bridgeHarness.envelopes.filter(value => value.command === "requestState").length
    const state = createDefaultState()
    state.lastResult = { success: true, code: "completed", message: "Completed" }
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
    expect(wrapper.find(".scr-global-status").text()).not.toContain("mounted-diff-seed")
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
    for (let index = 0; index < 50; index += 1) {
      const label = stores.uiLayout.state.compact ? "Expanded mode" : "Compact mode"
      await wrapper.find(`button[aria-label="${label}"]`).trigger("click")
      await settle()
    }
    const summary = stores.uiPerformance.summary.value
    expect(summary.tabSwitchP95Ms).toBeLessThan(50)
    expect(summary.buttonResponseP95Ms).toBeLessThan(50)
    expect(summary.renderCount).toBe(90)
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
