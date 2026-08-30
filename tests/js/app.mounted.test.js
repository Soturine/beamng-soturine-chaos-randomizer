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
    stores.applyDiff("core", {
      lastResult: {
        success: true,
        code: "completed",
        message: "Completed",
        details: { operationId: "op-mounted-details", phase: "COMPLETED" },
      },
    })
    stores.status.push({ code: "completed", scope: "tab", tab: "chaos", severity: "success" })
    await nextTick()
    const detailsButton = wrapper.findAll(".scr-global-status button").find(button => button.text() === "Details")
    expect(detailsButton).toBeTruthy()
    await detailsButton.trigger("click")
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
    await wrapper.setProps({ items: {
      zulu: { label: "Zulu", disabled: true }, alpha: "Alpha",
    }, modelValue: "alpha", disabled: false })
    await settle()
    expect(wrapper.find(".bng-smart-select-trigger").text()).toBe("Alpha")
    await wrapper.find(".bng-smart-select-trigger").trigger("click")
    expect(wrapper.findAll('[role="option"]')).toHaveLength(2)
    await wrapper.setProps({ items: {} })
    await settle()
    expect(wrapper.find(".scr-select").exists()).toBe(true)
    wrapper.unmount()
  })

  it("uses AppHost width classes at every required width and keeps Race selects usable", async () => {
    const { wrapper, stores } = mountShell()
    await settle()
    const observer = resizeHarness.instances.at(-1)
    expect(observer.element).toBe(wrapper.element.parentElement)
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

  it("keeps explicit normal geometry stable across tiny content, tabs, drawers, and compact cycles", async () => {
    const { wrapper, stores } = mountShell()
    await settle()
    const observer = resizeHarness.instances.at(-1)
    const initial = stores.uiLayout.preferredSize()

    expect(wrapper.find(".scr-app").attributes("data-layout-mode")).toBe("normal")
    expect(wrapper.find(".scr-normal-layout").exists()).toBe(true)
    expect(initial).toEqual({ width: 440, height: null })
    expect(wrapper.find(".scr-app").attributes("style")).not.toContain("--scr-target-height")
    observer.emit(120, 80)
    await settle()
    expect(stores.uiLayout.preferredSize()).toEqual(initial)
    expect(stores.uiLayout.state.normalSizePinned).toBe(false)
    expect(wrapper.find(".scr-app").classes()).toContain("is-normal")
    expect(wrapper.find(".scr-app").classes()).not.toContain("is-user-sized")

    observer.emit(560, 610)
    await settle()
    const userSize = { width: 560, height: 610 }
    expect(stores.uiLayout.state.userPreferredNormalSize).toEqual(userSize)
    expect(wrapper.find(".scr-app").classes()).toContain("is-user-sized")
    expect(wrapper.find(".scr-app").attributes("style")).toContain("--scr-target-height: 610px")
    const tabs = ["chaos", "garage", "race", "settings"]
    for (let cycle = 0; cycle < 50; cycle += 1) {
      stores.uiLayout.setTab(tabs[cycle % tabs.length])
      stores.uiLayout.toggleDetails()
      stores.uiLayout.toggleDetails()
      expect(stores.uiLayout.preferredSize()).toEqual(userSize)
    }
    await settle()

    for (let cycle = 0; cycle < 50; cycle += 1) {
      stores.uiLayout.setCompact(true, false)
      expect(stores.uiLayout.state.mode).toBe("compact")
      stores.uiLayout.setCompact(false, false)
      expect(stores.uiLayout.preferredSize()).toEqual(userSize)
    }
    await settle()
    expect(wrapper.find(".scr-normal-layout").exists()).toBe(true)
    expect(wrapper.find(".scr-compact-layout").exists()).toBe(false)
    wrapper.unmount()
  })

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

  it("normalizes legacy formation values and map-shaped Preview slots without a filter crash", async () => {
    const { wrapper, stores } = mountShell()
    const state = createDefaultState()
    state.settings.uiPreferences = {
      ...(state.settings.uiPreferences || {}),
      race: { formation: "Automatic Best Fit" },
    }
    state.spawnDirector.racePreview = {
      enabled: true, state: "PREVIEW_FAILED", formation: "Automatic Best Fit",
      slots: {
        2: { name: "Mapped two", transform: { position: { x: 2, y: 4, z: 1 } } },
        1: { name: "Mapped one", transform: { position: { x: 1, y: 3, z: 1 } } },
      },
      renderer: { availabilityState: "RENDER_UNAVAILABLE", lastErrorCode: "preview_renderer_unavailable" },
    }
    stores.applyFull(state)
    stores.uiLayout.setTab("race")
    stores.uiLayout.state.raceStep = "formation"
    await settle()

    expect(stores.race.state.options.formation).toBe("AUTO_BEST_FIT")
    expect(stores.race.state.placementOptions.mode).toBe("AUTO_BEST_FIT")
    expect(stores.race.state.spawnDirector.racePreview.slots.map(item => item.slot)).toEqual([1, 2])
    expect(wrapper.text()).toContain("2 placement positions are ready")
    expect(wrapper.find(".scr-error-boundary").exists()).toBe(false)
    wrapper.unmount()
  })

  it("keeps coverage status readable at narrow width and exposes ledger counts in Details", async () => {
    const { wrapper, stores } = mountShell()
    stores.uiLayout.state.width = 320
    stores.applyDiff("core", { lastResult: {
      success: true, code: "full_random_partial_applied", message: "fixture",
      details: { operationId: "coverage-op", skippedCount: 2, coverage: {
        slots: { slotsChanged: 4, slotsAttempted: 6, slotsClassified: 8, slotsEligible: 9, slotsUnresolved: 1 },
        tuning: { tuningChanged: 3, tuningAttempted: 3, tuningClassified: 4, tuningEligible: 4, tuningUnresolved: 0 },
        paint: { paintChanged: 2, paintAttempted: 2, paintClassified: 3, paintEligible: 3, paintUnresolved: 0 },
      } },
    } })
    await settle()

    const status = wrapper.find(".scr-global-status")
    expect(status.exists()).toBe(true)
    expect(status.text()).toContain("4 parts")
    expect(status.text()).toContain("15/16 eligible items classified")
    expect(status.find(".scr-global-status-content").exists()).toBe(true)
    expect(status.find(".scr-global-status-actions").exists()).toBe(true)
    await status.findAll("button").find(button => button.text() === "Details").trigger("click")
    await settle()
    expect(wrapper.find(".scr-coverage-details").text()).toContain("4 changed")
    expect(wrapper.find(".scr-coverage-details").text()).toContain("8/9 classified")
    wrapper.unmount()
  })

  it("normalizes every Garage entries shape before Compare and survives dynamic updates", async () => {
    const { wrapper, stores } = mountShell()
    stores.uiLayout.setTab("garage")
    await settle()
    const compare = wrapper.findAll('[role="tab"]').find(tab => tab.text() === "Compare")
    expect(compare).toBeTruthy()
    await compare.trigger("click")
    await settle()

    const shapes = [
      [{ id: "dna-array", name: "Array vehicle" }, null],
      { dnaMap: { name: "Mapped vehicle" } },
      {}, null, undefined, "invalid", 42,
      { liveLuaOne: { id: "dna-lua-1", name: "Lua one", final: { modelKey: "pickup" } } },
    ]
    for (const entries of shapes) {
      stores.applyDiff("garage", { entries })
      await settle()
      expect(Array.isArray(stores.garage.state.entries)).toBe(true)
      expect(wrapper.find(".scr-error-boundary").exists()).toBe(false)
      expect(wrapper.findAll("select")).toHaveLength(0)
    }

    stores.uiLayout.setTab("chaos")
    stores.applyDiff("garage", { entries: { afterTab: { name: "After tab" } } })
    stores.uiLayout.setTab("garage")
    stores.uiLayout.state.garageSection = "saved"
    await settle()
    expect(wrapper.text()).toContain("After tab")
    expect(wrapper.find(".scr-error-boundary").exists()).toBe(false)
    wrapper.unmount()
  })

  it("reports renderer failure without blocking generation and survives 50 Preview toggle cycles", async () => {
    const { wrapper, stores, command } = mountShell()
    stores.uiLayout.setTab("race")
    stores.race.state.spawnDirector.racePreview = {
      enabled: true,
      state: "PREVIEW_FAILED",
      slots: [{ slot: 1 }],
      renderer: { available: true, renderState: "FAILED", lastErrorCode: "preview_renderer_returned_false" },
    }
    await settle()
    expect(wrapper.text()).toContain("renderer did not draw a frame")
    const generate = wrapper.findAll("button").find(button => button.text() === "Generate cars")
    expect(generate).toBeTruthy()
    expect(generate.attributes("disabled")).toBeUndefined()

    const previewToggle = wrapper.findAll("label.scr-toggle").find(label => label.text().includes("world preview"))
    expect(previewToggle).toBeTruthy()
    const input = previewToggle.find('input[type="checkbox"]')
    for (let cycle = 0; cycle < 50; cycle += 1) {
      await input.setValue(cycle % 2 !== 0)
      await settle()
    }
    expect(command.calls.filter(([name]) => name === "previewRaceGeneration")).toHaveLength(50)
    expect(command.calls.filter(([name]) => name === "updateUIPreferences")).toHaveLength(50)
    expect(stores.race.state.options.previewEnabled).toBe(true)
    wrapper.unmount()
  })

  it("offers placement fallback data while physical positioning stays renderer-independent", async () => {
    const { wrapper, stores, command } = mountShell()
    stores.uiLayout.setTab("race")
    stores.uiLayout.state.raceStep = "formation"
    stores.race.state.spawnDirector.racePreview = {
      enabled: true,
      state: "PREVIEW_FAILED",
      formation: "GRID",
      slots: [
        { slot: 1, slotId: "slot-1", name: "Competitor 1", transform: { position: { x: 10, y: 20, z: 3 } } },
        { slot: 2, slotId: "slot-2", name: "Competitor 2", transform: { position: { x: 14, y: 20, z: 3 } } },
      ],
      renderer: { availabilityState: "RENDER_UNAVAILABLE", renderState: "FAILED", lastErrorCode: "preview_renderer_unavailable" },
    }
    await settle()
    expect(wrapper.text()).toContain("2 placement positions are ready")
    expect(wrapper.text()).toContain("Calculate placements")
    expect(wrapper.text()).toContain("10.0, 20.0, 3.0")

    const next = wrapper.findAll("button").find(button => button.text() === "Place next")
    await next.trigger("click")
    expect(command.calls.at(-1)).toEqual(["startLineupSpawn", [expect.objectContaining({
      spawnAll: false, useNextLineupCompetitor: true, placementAction: "next",
    })]])
    wrapper.unmount()
  })

  it("locks conflicting placement controls and exposes one monotonic active operation", async () => {
    const { wrapper, stores, command } = mountShell()
    stores.uiLayout.setTab("race")
    stores.uiLayout.state.raceStep = "formation"
    stores.race.state.spawnDirector.run = {
      active: true, operationId: "race-placement:fixture:1", generation: 1,
      kind: "reposition", requested: 4, completed: 2, failed: 0, currentSlot: 3,
    }
    await settle()
    expect(wrapper.text()).toContain("Positioning 2/4 vehicles")
    for (const label of ["Preview formation", "Place first", "Place next", "Place all"]) {
      expect(wrapper.findAll("button").find(button => button.text() === label).attributes("disabled")).toBeDefined()
    }
    const cancel = wrapper.findAll("button").find(button => button.text() === "Cancel placement")
    expect(cancel.attributes("disabled")).toBeUndefined()
    await cancel.trigger("click")
    expect(command.calls.at(-1)).toEqual(["cancelLineupSpawn", []])
    wrapper.unmount()
  })

  it("separates a new blank-seed generation from an explicit repeat and exposes the used seed", async () => {
    const { wrapper, stores, command } = mountShell()
    stores.uiLayout.setTab("race")
    stores.race.state.options.episodeSeed = ""
    await settle()

    const generate = wrapper.findAll("button").find(button => button.text() === "Generate cars")
    await generate.trigger("click")
    expect(command.calls.at(-1)[0]).toBe("createChaosLineup")
    expect(command.calls.at(-1)[1][0]).toMatchObject({ episodeSeed: "", seedIntent: "new" })

    stores.race.state.lineup.current = {
      id: "lineup-seed-a", episodeSeed: "RACE-ABCD-1234", generationState: "lineup_ready",
      summary: { ready: 3 }, competitors: [],
    }
    await settle()
    expect(wrapper.text()).toContain("Seed used")
    expect(wrapper.text()).toContain("RACE-ABCD-1234")
    expect(wrapper.findAll("button").some(button => button.text() === "Copy seed")).toBe(true)

    const repeat = wrapper.findAll("button").find(button => button.text() === "Repeat previous seed")
    expect(repeat.attributes("disabled")).toBeUndefined()
    await repeat.trigger("click")
    expect(command.calls.at(-1)[0]).toBe("createChaosLineup")
    expect(command.calls.at(-1)[1][0]).toMatchObject({
      episodeSeed: "RACE-ABCD-1234", seedIntent: "repeat", repeatOfLineupId: "lineup-seed-a",
    })
    wrapper.unmount()
  })

  it("keeps Events behavior presets simple and advanced AI controls disclosed", async () => {
    const { wrapper, stores, command } = mountShell()
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
    for (const preset of ["Follow", "Convoy", "Chase", "Flee", "Traffic", "Roam", "Swarm"]) {
      const button = panel.findAll("button").find(item => item.text() === ({
        Follow: "Follow me", Convoy: "Convoy", Chase: "Chase", Flee: "Flee",
        Traffic: "Chaotic traffic", Roam: "Roam", Swarm: "Swarm",
      })[preset])
      await button.trigger("click")
      expect(command.calls.at(-1)).toEqual(["startAIQuickPreset", [preset]])
    }
    command.send = async function (name, args = []) {
      this.calls.push([name, args])
      throw new Error("fixture_command_rejected")
    }
    await panel.findAll("button").find(item => item.text() === "Follow me").trigger("click")
    await settle()
    expect(wrapper.find(".scr-error-boundary").exists()).toBe(false)
    expect(panel.text()).toContain("additional details")
    expect(panel.text()).toContain("Follow me")
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

  it("keeps compact Events actionable before and after lineup placement", async () => {
    const { wrapper, stores, command } = mountShell()
    stores.uiLayout.setTab("race")
    stores.race.state.lineup = {
      current: { generationState: "lineup_partial", summary: { ready: 3, failed: 1 } },
    }
    stores.uiLayout.setCompact(true, false)
    await settle()
    const compact = wrapper.find(".scr-compact-summary")
    expect(compact.text()).toContain("3 ready · 1 failed")
    expect(compact.text()).toContain("Position / Start")
    await compact.find("button").trigger("click")
    expect(command.calls.at(-1)[0]).toBe("startLineupSpawn")
    expect(command.calls.at(-1)[1][0]).toMatchObject({ spawnAll: true, count: 3 })

    stores.race.state.spawnDirector.managed = [{ handle: "npc-1", status: "ready" }]
    await settle()
    await compact.find("button").trigger("click")
    expect(command.calls.at(-1)).toEqual(["startAIQuickPreset", ["Traffic"]])
    wrapper.unmount()
  })

  it("explains the blocked Behavior step and never leaks unknown result codes", async () => {
    const { wrapper, stores } = mountShell()
    stores.uiLayout.setTab("race")
    stores.uiLayout.state.raceStep = "behavior"
    await settle()
    expect(wrapper.find(".scr-race-blocked").text()).toContain("Missing: at least one ready NPC.")
    expect(wrapper.find(".scr-race-blocked button").text()).toBe("Generate and position NPCs")

    stores.applyDiff("core", {
      busy: false,
      lastResult: { success: false, code: "future_backend_failure_code", details: {} },
    })
    await settle()
    expect(wrapper.find(".scr-global-status").text()).toContain("additional details")
    expect(wrapper.text()).not.toContain("future_backend_failure_code")
    wrapper.unmount()
  })

  it("summarizes applied Chaos changes separately from skipped options", async () => {
    const { wrapper, stores } = mountShell()
    stores.applyDiff("core", {
      busy: false,
      lastResult: {
        success: true,
        code: "scramble_completed_with_skips",
        details: {
          operationId: "chaos:fixture:summary",
          terminalOutcome: "COMPLETED_WITH_SKIPS",
          partsChanged: 49,
          tuningValues: Array.from({ length: 24 }, (_, index) => ({ name: `v${index}` })),
          paintLayers: 3,
          skippedCount: 2,
        },
      },
    })
    await settle()
    const banner = wrapper.find(".scr-global-status")
    expect(banner.text()).toContain("49 parts · 24 tuning values · 3 paints")
    expect(banner.text()).toContain("2 incompatible options were skipped.")
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

  it("hides dead Details CTAs and opens the exact Race operation payload", async () => {
    const { wrapper, stores, command } = mountShell()
    stores.uiLayout.setTab("race")
    stores.status.push({ code: "warning", scope: "tab", tab: "race", severity: "warning" })
    await settle()
    expect(wrapper.findAll(".scr-global-status button").some(button => button.text() === "Details")).toBe(false)

    stores.applyDiff("core", {
      lastResult: {
        success: false,
        code: "race_zero_pool_mods_showcase",
        message: "backend-only English fixture",
        details: {
          operationId: "race:lineup_generation:77", generation: 77,
          preset: "Mods Showcase", episodeSeed: "EPISODE-77", slotId: "slot-2",
          model: "vivace", configuration: "gravel.pc", concreteVehicleId: 707,
          recoverable: true, retryAction: "createChaosLineup",
        },
      },
    })
    await settle()
    const details = wrapper.findAll(".scr-global-status button").find(button => button.text() === "Details")
    expect(details).toBeTruthy()
    await details.trigger("click")
    await settle()
    const drawer = wrapper.find(".scr-details.is-drawer")
    expect(drawer.text()).toContain("race:lineup_generation:77")
    expect(drawer.text()).toContain("Mods Showcase")
    expect(drawer.text()).toContain("EPISODE-77")
    expect(drawer.text()).toContain("slot-2")
    expect(drawer.text()).toContain("vivace / gravel.pc")
    expect(drawer.text()).toContain("707")
    expect(drawer.text()).toContain("change the preset and content filters")
    expect(drawer.findAll(".scr-tech-grid")[0].text()).not.toContain("backend-only English fixture")
    await drawer.findAll("button").find(button => button.text() === "Copy diagnostics").trigger("click")
    expect(command.calls.at(-1)[0]).toBe("copyDiagnostics")
    wrapper.unmount()
  })

  it("renders canonical competitor order and persists move intent by slot identity", async () => {
    const { wrapper, stores, command } = mountShell()
    stores.uiLayout.setTab("race")
    stores.race.state.lineup.current = {
      generationState: "lineup_ready",
      competitors: [
        { index: 1, id: "slot-a", name: "A", position: 1, status: "ready" },
        { index: 2, id: "slot-b", name: "B", position: 3, status: "ready" },
        { index: 3, id: "slot-c", name: "C", position: 2, status: "ready", seed: "slot-c-seed" },
      ],
    }
    await settle()
    const names = wrapper.findAll(".scr-competitor input").map(input => input.element.value)
    expect(names).toEqual(["A", "C", "B"])
    const middle = wrapper.findAll(".scr-competitor")[1]
    await middle.findAll("button").find(button => button.text() === "Move down").trigger("click")
    expect(command.calls.at(-1)).toEqual(["reorderLineupCompetitor", [3, 3]])

    stores.race.state.lineup.current.competitors[1].position = 2
    stores.race.state.lineup.current.competitors[2].position = 3
    await settle()
    expect(wrapper.findAll(".scr-competitor input").map(input => input.element.value)).toEqual(["A", "B", "C"])
    expect(stores.race.state.lineup.current.competitors[2].seed).toBe("slot-c-seed")
    wrapper.unmount()
  })

  it("shows localized detected compatibility once and persists dismissal", async () => {
    const { wrapper, stores, command } = mountShell()
    stores.i18n.setPreference("pt-BR")
    stores.applyDiff("core", {
      conflicts: [{ id: "multiplayer_vehicle_sync", evidence: "loaded_extension:BeamMP" }],
    })
    await settle()
    const banner = wrapper.find(".scr-compatibility-compact")
    expect(banner.text()).toContain("A sincronização multiplayer está ativa")
    expect(banner.text()).not.toContain("Multiplayer vehicle synchronization may")
    await banner.findAll("button").find(button => button.text() === "Dispensar").trigger("click")
    expect(wrapper.find(".scr-compatibility-compact").exists()).toBe(false)
    expect(command.calls.at(-1)).toEqual(["updateUIPreferences", [{ compatibilityWarningDismissed: true }]])
    wrapper.unmount()
  })

  it("keeps long selector labels accessible at every required width and locale", async () => {
    const { wrapper, stores } = mountShell()
    stores.uiLayout.setTab("race")
    await settle()
    const observer = resizeHarness.instances.at(-1)
    for (const locale of ["pt-BR", "en-US", "es-ES"]) {
      stores.i18n.setPreference(locale)
      for (const width of [320, 360, 400, 480, 600, 720]) {
        observer.emit(width, 560)
        await settle()
        for (const trigger of wrapper.findAll(".bng-smart-select-trigger")) {
          expect(trigger.attributes("title")).toBe(trigger.text())
        }
        expect(wrapper.find(".scr-app").classes()).toContain(`scr-width-${width < 400 ? "narrow" : width < 640 ? "medium" : "wide"}`)
      }
    }
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

  it("keeps overall progress monotonic and localizes unknown runtime phases", async () => {
    const { wrapper, stores } = mountShell()
    stores.applyDiff("core", {
      busy: true,
      lifecyclePhase: "future_internal_phase",
      progress: {
        operationId: "chaos:fixture:1", phase: "future_internal_phase",
        phaseProgress: 0.8, overallProgress: 0.8, value: 0.8,
      },
    })
    await settle()
    expect(wrapper.find(".scr-progress strong").text()).toBe("Working")
    expect(wrapper.text()).not.toContain("future_internal_phase")

    stores.applyDiff("core", {
      progress: {
        operationId: "chaos:fixture:1", phase: "verifying_parts",
        phaseProgress: 0.2, overallProgress: 0.2, value: 0.2,
      },
    })
    await settle()
    expect(stores.core.state.progress.overallProgress).toBe(0.8)
    expect(stores.core.state.progress.value).toBe(0.8)
    expect(wrapper.find(".scr-progress strong").text()).toBe("Verifying parts")
    wrapper.unmount()
  })

  it("keeps recoverable Race errors actionable until dismiss or a successful retry", async () => {
    const { wrapper, stores, command } = mountShell()
    stores.uiLayout.setTab("race")
    stores.applyDiff("core", {
      busy: false,
      lastResult: {
        success: false,
        code: "position_blocked",
        details: { operationId: "race:preview_generation:1", generation: 1,
          recoverable: true, retryAction: "previewRaceGeneration" },
      },
    })
    await settle()

    const banner = wrapper.find(".scr-global-status")
    expect(banner.text()).toContain("No safe Preview position")
    expect(stores.status.current("race").persistent).toBe(true)
    await banner.findAll("button").find(button => button.text() === "Retry").trigger("click")
    expect(command.calls.at(-1)[0]).toBe("previewRaceGeneration")

    stores.applyDiff("core", {
      busy: false,
      lastResult: {
        success: false,
        code: "position_blocked",
        details: { operationId: "race:preview_generation:2", generation: 2,
          recoverable: true, retryAction: "previewRaceGeneration" },
      },
    })
    await settle()
    expect(stores.status.items.filter(item => item.recoverable)).toHaveLength(1)
    await wrapper.find(".scr-global-status").findAll("button").find(button => button.text() === "Dismiss").trigger("click")
    expect(stores.status.items.filter(item => item.recoverable)).toHaveLength(0)

    stores.applyDiff("core", {
      busy: false,
      lastResult: {
        success: false,
        code: "lineup_staging_unsafe",
        details: { operationId: "race:lineup_generation:1", generation: 1,
          recoverable: true, retryAction: "createChaosLineup" },
      },
    })
    await settle()
    expect(wrapper.find(".scr-global-status").text()).toContain("Safe staging")
    stores.applyDiff("core", {
      busy: false,
      lastResult: {
        success: true,
        code: "lineup_started",
        details: { operationId: "race:lineup_generation:2", generation: 2 },
      },
    })
    await settle()
    expect(stores.status.items.some(item => item.recoverable)).toBe(false)
    wrapper.unmount()
  })

  it("keeps a valid in-memory lineup usable while typed storage retry is available", async () => {
    const { wrapper, stores, command } = mountShell()
    stores.uiLayout.setTab("race")
    stores.race.state.lineup = {
      current: {
        active: true,
        generationState: "lineup_processing",
        competitors: [],
        persistence: {
          status: "warning",
          errorCode: "lineup_storage_atomic_commit",
          lastCause: "atomic_replace_failed",
          recoverable: true,
          retryAction: "retryLineupPersistence",
        },
      },
    }
    await settle()
    expect(wrapper.text()).toContain("valid in-memory lineup remains available")
    const retry = wrapper.findAll("button").find(button => button.text() === "Retry saving")
    expect(retry).toBeTruthy()
    await retry.trigger("click")
    expect(command.calls.at(-1)).toEqual(["retryLineupPersistence", []])
    wrapper.unmount()
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
