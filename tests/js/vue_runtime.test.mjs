import assert from "node:assert/strict"
import { readFile } from "node:fs/promises"
import { resolve } from "node:path"

const root = resolve(import.meta.dirname, "../..")
let checks = 0
function check(actual, expected, message) {
  checks += 1
  if (arguments.length === 1) assert.ok(actual)
  else assert.deepEqual(actual, expected, message)
}
const truthy = (value, message) => { checks += 1; assert.ok(value, message) }
const rejects = async (promise, pattern) => { checks += 1; await assert.rejects(promise, pattern) }

async function source(relative) {
  return readFile(resolve(root, relative), "utf8")
}

async function load(relative, replacements = []) {
  let code = await source(relative)
  for (const [pattern, value] of replacements) code = code.replace(pattern, value)
  return import(`data:text/javascript;base64,${Buffer.from(code).toString("base64")}`)
}

const bridgeModule = await load("ui/modules/apps/soturineChaosRandomizer/services/commandBridge.js")
const calls = []
const api = {
  serializeToLua(value) { calls.push({ type: "serialize", value }); return "SAFE_SERIALIZED_ENVELOPE" },
  engineLua(target, callback) { calls.push({ type: "engine", target }); callback({ success: true, code: "command_completed" }) },
}
let view = "garage"
const bridge = bridgeModule.createCommandBridge(api, () => view)
const response = await bridge.send("renameVehicleDNA", ["dna-1", "O'Brien \\ Garage"])
check(response.success, true)
check(calls.length, 2)
check(calls[0].value.protocolVersion, 2)
check(calls[0].value.command, "renameVehicleDNA")
check(calls[0].value.arguments, ["dna-1", "O'Brien \\ Garage"])
check(calls[0].value.sourceView, "garage")
truthy(/^scr-vue-\d+-1$/.test(calls[0].value.commandId))
check(calls[1].target, "extensions.soturineChaosRandomizer.dispatchUICommand(SAFE_SERIALIZED_ENVELOPE)")
truthy(!calls[1].target.includes("O'Brien"))
await bridge.send("requestState")
truthy(/-2$/.test(calls[2].value.commandId))
await rejects(bridge.send("arbitraryLuaMethod"), /command_not_allowed/)
await rejects(bridge.send("renameVehicleDNA", ["only-one"]), /command_arguments_invalid/)
view = "invalid view with spaces"
await rejects(bridge.send("requestState"), /command_source_invalid/)
view = "chaos"
await rejects(bridge.send("importVehicleDNA", [{ text: "x".repeat(bridgeModule.MAX_COMMAND_BYTES) }]), /command_payload_oversize/)
bridge.dispose()
check(bridge.disposed, true)
await rejects(bridge.send("requestState"), /command_bridge_disposed/)
check(Object.isFrozen(bridgeModule.COMMAND_SCHEMAS), true)
truthy(Object.keys(bridgeModule.COMMAND_SCHEMAS).length >= 60)

const protocolModule = await load(
  "ui/modules/apps/soturineChaosRandomizer/services/stateProtocol.js",
  [[/import \{ UI_PROTOCOL_VERSION \} from "\.\/commandBridge\.js"/, "const UI_PROTOCOL_VERSION = 2"]],
)
const applied = []
const rejections = []
let recoveryRequests = 0
const protocol = protocolModule.createStateProtocol({
  applyFull: (payload, envelope) => applied.push(["full", payload, envelope]),
  applyDiff: (domain, payload, dirty, envelope) => applied.push([domain, payload, dirty, envelope]),
  requestFull: async () => { recoveryRequests += 1 },
  reject: reason => rejections.push(reason),
})
const envelope = (stateVersion, eventType, domain, payload = {}, extra = {}) => ({
  protocolVersion: 2, stateVersion, eventType, domain, payload,
  operationId: 7, operationGeneration: 3, targetGeneration: 4,
  timestamp: 10, dirtySections: [domain], ...extra,
})
check(protocol.apply(envelope(1, "full", "all", { busy: false })), true)
check(protocol.appliedVersion, 1)
check(applied[0][0], "full")
check(protocol.apply(envelope(2, "diff", "core", { busy: true })), true)
check(protocol.appliedVersion, 2)
check(applied[1][0], "core")
check(applied[1][1].busy, true)
check(protocol.apply(envelope(2, "diff", "core")), false)
check(applied.length, 2)
check(protocol.apply(envelope(4, "diff", "race")), false)
await Promise.resolve()
check(recoveryRequests, 1)
check(rejections.at(-1), "state_version_gap")
check(protocol.apply(envelope(7, "full", "all", { busy: false })), true)
check(protocol.appliedVersion, 7)
check(protocol.apply(envelope(1, "reset", "all", { busy: false })), true)
check(protocol.appliedVersion, 1)
check(protocol.apply(envelope(2, "diff", "unknown", {})), false)
await Promise.resolve()
check(rejections.at(-1), "state_envelope_invalid")
protocol.reset()
check(protocol.appliedVersion, 0)
check(protocol.recoveryPending, false)

const normalizerModule = await load("ui/modules/apps/soturineChaosRandomizer/services/stateNormalizer.js")
const shapeIssues = []
const normalizedMap = normalizerModule.normalizeManagedVehicles({
  zeta: { name: "Zeta" },
  alpha: { handle: "physical-alpha", name: "Alpha" },
}, issue => shapeIssues.push(issue))
check(normalizedMap.map(item => item.handle), ["physical-alpha", "zeta"])
check(shapeIssues, [{ code: "normalized_state_shape", path: "spawnDirector.managed", receivedType: "object_map" }])
check(normalizerModule.normalizeManagedVehicles("invalid", issue => shapeIssues.push(issue)), [])
check(shapeIssues.at(-1).receivedType, "string")
check(normalizerModule.normalizeManagedVehicles([{ handle: "ok" }, null]).map(item => item.handle), ["ok"])
const garageIssues = []
const garageArray = [{ id: "dna-2", name: "Two" }, null, { id: "dna-1", name: "One" }]
check(normalizerModule.normalizeGarageEntries(garageArray, issue => garageIssues.push(issue)).map(item => item.id), ["dna-2", "dna-1"])
check(garageIssues.at(-1), { code: "invalid_state_shape", path: "garage.entries", receivedType: "array_with_invalid_entries" })
check(normalizerModule.normalizeGarageEntries({
  beta: { name: "Beta" }, alpha: { id: "physical-alpha", name: "Alpha" },
}, issue => garageIssues.push(issue)).map(item => item.id), ["physical-alpha", "beta"])
check(garageIssues.at(-1), { code: "normalized_state_shape", path: "garage.entries", receivedType: "object_map" })
for (const invalid of [null, undefined, "invalid", 17]) {
  check(normalizerModule.normalizeGarageEntries(invalid).length, 0)
}
check(normalizerModule.normalizeFullState({ garage: { entries: {} } }).garage.entries, [])
check(normalizerModule.normalizeDomainPayload("garage", {
  entries: { dna: { name: "Fixture" } },
}).entries[0].id, "dna")
const previewIssues = []
const normalizedSlots = normalizerModule.normalizePreviewSlots({
  2: { name: "Two", transform: { position: { x: 2 } } },
  1: { slotId: "physical-one", name: "One" },
  bad: null,
}, issue => previewIssues.push(issue))
check(normalizedSlots.map(item => item.slot), [1, 2])
check(normalizedSlots[0].slotId, "physical-one")
check(previewIssues[0], {
  code: "normalized_state_shape", path: "spawnDirector.racePreview.slots", receivedType: "object_map",
})
check(normalizerModule.normalizePreviewSlots("invalid", issue => previewIssues.push(issue)), [])
check(previewIssues.at(-1).receivedType, "string")
const normalizedRace = normalizerModule.normalizeDomainPayload("race", {
  spawnDirector: { racePreview: { slots: { 1: { name: "Mapped" } } } },
  lineup: { current: { worldPreview: { slots: null } } },
})
check(normalizedRace.spawnDirector.racePreview.slots[0].name, "Mapped")
check(normalizedRace.lineup.current.worldPreview.slots, [])
const sparseRaceDiff = normalizerModule.normalizeDomainPayload("race", {
  spawnDirector: { placement: { available: true } },
})
check("managed" in sparseRaceDiff.spawnDirector, false)
check("racePreview" in sparseRaceDiff.spawnDirector, false)
check("lineup" in sparseRaceDiff, false)

const reactiveStub = "const reactive = value => value"
const domainModule = await load(
  "ui/modules/apps/soturineChaosRandomizer/stores/domainStore.js",
  [[/import \{ reactive \} from "vue"/, reactiveStub]],
)
const incoming = { nested: { count: 1 }, list: [{ id: 1, value: "a" }] }
const store = domainModule.createDomainStore("fixture", { nested: {}, list: [] })
store.replace(incoming)
check(store.name, "fixture")
check(store.state.nested.count, 1)
check(store.state.list.length, 1)
store.patch({ nested: { count: 2 }, list: [{ id: 2, value: "b" }] })
check(store.state.nested.count, 2)
check(store.state.list[0].id, 2)
check(incoming.nested.count, 1, "previous backend snapshot must remain immutable")
check(incoming.list[0].id, 1, "previous backend array must remain immutable")
const nestedReference = store.state.nested
store.patch({ nested: { count: 3, ready: true } })
check(store.state.nested === nestedReference, true)
check(store.state.nested.ready, true)

const layoutModule = await load(
  "ui/modules/apps/soturineChaosRandomizer/stores/uiLayout.js",
  [[/import \{ reactive \} from "vue"/, reactiveStub]],
)
for (let cycle = 0; cycle < 100; cycle += 1) {
  const layout = layoutModule.createUILayoutStore()
  const tab = ["chaos", "garage", "race", "settings"][cycle % 4]
  layout.setTab(tab)
  layout.recordHostSize(360 + cycle, 400 + cycle)
  check(layout.state.normalSizePinned, false, "the first AppHost measurement is only a baseline")
  check(layout.preferredSize(tab).height, null, "unowned normal height must remain content-driven")
  layout.setCompact(true)
  layout.toggleDetails(tab)
  layout.recordHostSize(200, 210)
  check(layout.state.activeTab, tab)
  check(layout.state.detailsOpenByTab[tab], true)
  check(layout.preferredSize(tab).height, layout.state.compactSizeByTab[tab].height)
  layout.setCompact(false)
  check(layout.preferredSize(tab).height, null)
  check(layout.state.mode, "normal")
}
const invalidLayout = layoutModule.createUILayoutStore()
invalidLayout.setTab("not-a-tab")
check(invalidLayout.state.activeTab, "chaos")
const initialNormal = { ...invalidLayout.state.userPreferredNormalSize }
invalidLayout.recordHostSize(180, 90, { source: "appHost" })
check(invalidLayout.state.userPreferredNormalSize, initialNormal, "tiny baseline must not overwrite a user preference")
check(invalidLayout.preferredSize().height, null, "tiny content must not pin normal geometry")
invalidLayout.recordHostSize(580, 610, { source: "appHost" })
invalidLayout.setTab("race")
check(invalidLayout.preferredSize().width, 580, "manual AppHost size must survive a tab switch")
check(invalidLayout.preferredSize().height, 610, "manual AppHost height must survive a tab switch")
for (const tab of ["chaos", "garage", "race", "settings"]) {
  truthy(invalidLayout.state.normalMinSizeByTab[tab].height > 0)
  check(invalidLayout.state.expandedSizeByTab[tab].height, undefined,
    "normal tabs must not carry fixed target heights")
  check(invalidLayout.state.resizeModeByTab[tab], "appHost")
}

const raceProtocol = await load("ui/modules/apps/soturineChaosRandomizer/services/raceProtocol.js")
check(raceProtocol.RACE_FORMATION_CODES.length, 9)
check(raceProtocol.formationRuntimeName("AUTO_BEST_FIT"), "Automatic Best Fit")
check(raceProtocol.formationRuntimeName("RADIAL"), "Circular / Radial")
check(raceProtocol.normalizeFormationCode("Automatic Best Fit"), "AUTO_BEST_FIT")
check(raceProtocol.normalizeFormationCode("Melhor ajuste automático"), "AUTO_BEST_FIT")
check(raceProtocol.normalizeFormationCode("Parrilla escalonada"), "STAGGERED_GRID")
check(raceProtocol.normalizeFormationCode({ invalid: true }), "AUTO_BEST_FIT")
truthy(raceProtocol.isRaceFormation("SIDE_BY_SIDE_GRID"))
truthy(raceProtocol.isPreviewOrigin("player_front"))
truthy(raceProtocol.isHeadingMode("destination"))
truthy(raceProtocol.isSpacingMode("manual"))
check(raceProtocol.isRaceFormation("Automatic Best Fit"), false, "UI protocol must expose stable formation codes")

const selectAdapter = await load("ui/modules/apps/soturineChaosRandomizer/services/selectAdapter.js")
check(selectAdapter.normalizeSelectItems(null), [])
check(selectAdapter.normalizeSelectItems("invalid"), [])
check(selectAdapter.normalizeSelectItems([null, "one", { id: "two" }, {}]), [
  { value: "one", label: "one" }, { id: "two", value: "two", label: "two" },
])
check(selectAdapter.normalizeSelectItems({ beta: "Beta", alpha: { label: "Alpha", disabled: true } }), [
  { value: "alpha", label: "Alpha", disabled: true }, { value: "beta", label: "Beta" },
])

const lifecycleModule = await load("ui/modules/apps/soturineChaosRandomizer/services/lifecycle.js")
let cleanupCount = 0
for (let cycle = 0; cycle < 100; cycle += 1) {
  const lifecycle = lifecycleModule.createLifecycleRegistry()
  lifecycle.add(() => { cleanupCount += 1 })
  lifecycle.add(() => { cleanupCount += 1 })
  check(lifecycle.size, 2)
  lifecycle.dispose()
  lifecycle.dispose()
  check(lifecycle.size, 0)
  check(lifecycle.disposed, true)
}
check(cleanupCount, 200)
const disposedLifecycle = lifecycleModule.createLifecycleRegistry()
disposedLifecycle.dispose()
disposedLifecycle.add(() => { cleanupCount += 1 })
check(cleanupCount, 201)

const statusModule = await load(
  "ui/modules/apps/soturineChaosRandomizer/services/statusLifecycle.js",
  [[/import \{ reactive \} from "vue"/, reactiveStub]],
)
let statusNow = 1000
let timerId = 0
const pendingTimers = new Map()
const status = statusModule.createStatusLifecycle({
  now: () => statusNow,
  setTimeout: callback => { const id = ++timerId; pendingTimers.set(id, callback); return id },
  clearTimeout: id => pendingTimers.delete(id),
})
status.push({ code: "lock_profile_updated", scope: "tab", tab: "chaos", ttl: 500 })
status.push({ code: "lock_profile_updated", scope: "tab", tab: "chaos", ttl: 500 })
check(status.items.length, 1, "equal statuses must be deduplicated")
check(status.current("race"), null, "tab status must not leak")
check(status.current("chaos").code, "lock_profile_updated")
status.replaceOperation({ code: "applying_parts", operationId: "op-1", persistent: true })
check(status.current("chaos", "op-1").code, "applying_parts")
status.replaceOperation({ code: "validating", operationId: "op-1", persistent: true })
check(status.items.filter(item => item.scope === "operation").length, 1)
status.push({ code: "position_blocked", scope: "tab", tab: "race", persistent: true,
  recoverable: true, dismissible: true, action: { command: "previewRaceGeneration" } })
statusNow = 100000
status.prune()
check(status.current("race").code, "position_blocked", "recoverable status must not expire")
check(status.current("race").dismissible, true)
check(status.clearWhere(item => item.recoverable), 1)
check(status.items.some(item => item.recoverable), false)
statusNow = 2000
status.prune()
check(status.items.some(item => item.code === "lock_profile_updated"), false)
status.dispose()
check(status.items.length, 0)

const enUS = JSON.parse(await source("ui/modules/apps/soturineChaosRandomizer/i18n/en-US.json"))
const ptBR = JSON.parse(await source("ui/modules/apps/soturineChaosRandomizer/i18n/pt-BR.json"))
const esES = JSON.parse(await source("ui/modules/apps/soturineChaosRandomizer/i18n/es-ES.json"))
const i18nModule = await load(
  "ui/modules/apps/soturineChaosRandomizer/services/i18n.js",
  [
    [/import \{ computed, ref \} from "vue"/, "const ref = value => ({ value }); const computed = getter => ({ get value() { return getter() } })"],
    [/import enUS from "\.\.\/i18n\/en-US\.json"/, `const enUS = ${JSON.stringify(enUS)}`],
    [/import ptBR from "\.\.\/i18n\/pt-BR\.json"/, `const ptBR = ${JSON.stringify(ptBR)}`],
    [/import esES from "\.\.\/i18n\/es-ES\.json"/, `const esES = ${JSON.stringify(esES)}`],
    [/import \{ auditCatalog, terminologyForLocale \} from "\.\.\/i18n\/terminology\.js"/,
      "const terminologyForLocale = locale => ({ locale, brand: {}, preservedTerms: [] }); const auditCatalog = () => []"],
  ],
)
const i18n = i18nModule.createI18n()
check(i18n.locale.value, "en-US")
check(i18n.t("nav.garage"), "Garage")
check(i18n.t("missing.semantic.key"), "Key")
check(i18n.t("status.progress", { percent: 42 }), "42% complete")
check(i18n.plural("race.competitors", 1), "1 competitor")
check(i18n.plural("race.competitors", 4), "4 competitors")
i18n.setGameLocale("pt_PT")
check(i18n.locale.value, "pt-BR")
check(i18n.t("nav.garage"), "Garagem")
check(i18n.plural("race.competitors", 1), "1 competidor")
check(i18n.plural("race.competitors", 8), "8 competidores")
i18n.setPreference("en-US")
check(i18n.locale.value, "en-US")
i18n.setPreference({ localeMode: "auto", manualLocale: "en-US" })
i18n.setGameLocale("es_MX")
check(i18n.locale.value, "es-ES")
check(i18n.t("nav.garage"), "Garaje")
check(i18n.plural("race.competitors", 2), "2 competidores")
i18n.setGameLocale("de-DE")
check(i18n.locale.value, "en-US")
i18n.setPreference({ localeMode: "manual", manualLocale: "es-ES" })
check(i18n.locale.value, "es-ES")
check(i18n.localeMode.value, "manual")
check(i18n.manualLocale.value, "es-ES")
check(Object.keys(enUS).length, Object.keys(ptBR).length)
check(Object.keys(enUS).length, Object.keys(esES).length)
truthy(Object.keys(enUS).length >= 180)
for (const technical of ["modelKey", "generatorVersion", "stateVersion", "operationId"]) truthy(i18n.t(technical) !== technical)
truthy(ptBR["garage.restoreConfirm"].length > enUS["garage.restoreConfirm"].length)
truthy(!Object.values(enUS).some(value => /<[^>]+>/.test(value)))
truthy(!Object.values(ptBR).some(value => /<[^>]+>/.test(value)))
truthy(!Object.values(esES).some(value => /<[^>]+>/.test(value)))
const terminology = await load("ui/modules/apps/soturineChaosRandomizer/i18n/terminology.js")
check(terminology.PRODUCT_BRAND.official, "Soturine's Chaos Randomizer")
check(terminology.PRODUCT_BRAND.short, "Soturine's Chaos")
for (const term of ["Seed", "DNA", "HUD", "Preview", "Grid", "Mod", "Preset", "AI", "BeamMP"]) {
  truthy(terminology.PRESERVED_TERMS.includes(term))
}
check(terminology.auditCatalog("pt-BR", ptBR), [])
check(terminology.auditCatalog("pt-BR", { bad: "Semente e prévia" }).map(item => item.preferred), ["Seed", "Preview"])

const humanLabels = await load("ui/modules/apps/soturineChaosRandomizer/services/humanLabels.js")
const labelI18n = i18nModule.createI18n()
labelI18n.setPreference("pt-BR")
check(humanLabels.humanPartLabel({ description: "Body" }, labelI18n.t), "Carroceria")
check(humanLabels.humanPartLabel({ description: "Navigation Unit" }, labelI18n.t), "Unidade de navegação")
check(humanLabels.humanPartLabel({ description: "Left Antenna" }, labelI18n.t), "Antena esquerda")
check(humanLabels.humanPartLabel({ description: "Right Antenna" }, labelI18n.t), "Antena direita")
check(humanLabels.humanPartLabel({ description: "Backlight" }, labelI18n.t), "Luz traseira")
check(humanLabels.humanPartLabel({ description: "Front Left Mud Flap" }, labelI18n.t), "Para-barro dianteiro esquerdo")
check(humanLabels.humanPartLabel({ description: "Left Highbeam Headlight Bulb" }, labelI18n.t), "Lâmpada esquerda do farol alto")
check(humanLabels.humanPartLabel({ description: "ModBrand Flux Capacitor" }, labelI18n.t), "ModBrand Flux Capacitor")
check(humanLabels.vehicleDisplayName({ name: "us_semi DNA", final: { modelKey: "us_semi" } }, labelI18n.t), "Gavril T-Series")
check(humanLabels.vehicleDisplayName({ name: "Minha criação", final: { modelKey: "us_semi" } }, labelI18n.t), "Minha criação")

const responsiveModule = await load(
  "ui/modules/apps/soturineChaosRandomizer/composables/useResponsiveLayout.js",
  [[/import \{ onMounted, onUnmounted \} from "vue"/, "const onMounted = () => {}; const onUnmounted = () => {}"]],
)
for (const width of [320, 360]) check(responsiveModule.widthClassFor(width), "narrow")
for (const width of [400, 440, 520, 560]) check(responsiveModule.widthClassFor(width), "medium")
for (const width of [640, 720]) check(responsiveModule.widthClassFor(width), "wide")

const beamNG0394 = JSON.parse(await source("tests/fixtures/v0.7.3/beamng-0.39.4.json"))
check(beamNG0394.targetBeamNG, "0.39.4")
truthy(beamNG0394.registry.model.registryKey !== beamNG0394.registry.model.displayName)
truthy(beamNG0394.registry.configuration.registryKey !== beamNG0394.registry.configuration.filename)
check(Object.keys(beamNG0394.managed).length, 2)
check(beamNG0394.managedAI.policy.driveInLane, true)
check(new Set(beamNG0394.resourceIncidents.map(value => value.expected)).size, 3)

const hostLocales = await Promise.all(["en-US", "pt-BR", "es-ES"].map(async locale =>
  JSON.parse(await source(`locales/translations/${locale}/main.translation.json`))))
for (const catalog of hostLocales) {
  truthy(catalog["ui.apps.soturineChaosRandomizer.name"])
  truthy(catalog["ui.apps.soturineChaosRandomizer.description"])
}

console.log(`SCR_UI_JS_TESTS_PASSED ${checks}`)
