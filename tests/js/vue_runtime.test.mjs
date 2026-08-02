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
  layout.setCompact(cycle % 2 === 0)
  layout.toggleDetails(tab)
  layout.recordHostSize(300 + cycle, 400 + cycle)
  check(layout.state.activeTab, tab)
  check(layout.state.details[tab], true)
  check(layout.state.userSizeByTab[tab].width, 300 + cycle)
  truthy(layout.preferredSize(tab).height >= 400)
}
const invalidLayout = layoutModule.createUILayoutStore()
invalidLayout.setTab("not-a-tab")
check(invalidLayout.state.activeTab, "chaos")
for (const tab of ["chaos", "garage", "race", "settings"]) {
  truthy(invalidLayout.state.expandedSizeByTab[tab].height > invalidLayout.state.compactSizeByTab[tab].height)
  check(invalidLayout.state.resizeModeByTab[tab], "host")
}

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

const enUS = JSON.parse(await source("ui/modules/apps/soturineChaosRandomizer/i18n/en-US.json"))
const ptBR = JSON.parse(await source("ui/modules/apps/soturineChaosRandomizer/i18n/pt-BR.json"))
const i18nModule = await load(
  "ui/modules/apps/soturineChaosRandomizer/services/i18n.js",
  [
    [/import \{ computed, ref \} from "vue"/, "const ref = value => ({ value }); const computed = getter => ({ get value() { return getter() } })"],
    [/import enUS from "\.\.\/i18n\/en-US\.json"/, `const enUS = ${JSON.stringify(enUS)}`],
    [/import ptBR from "\.\.\/i18n\/pt-BR\.json"/, `const ptBR = ${JSON.stringify(ptBR)}`],
  ],
)
const i18n = i18nModule.createI18n()
check(i18n.locale.value, "en-US")
check(i18n.t("nav.garage"), "Garage")
check(i18n.t("missing.semantic.key"), "missing.semantic.key")
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
i18n.setPreference("invalid")
check(i18n.locale.value, "pt-BR")
check(Object.keys(enUS).length, Object.keys(ptBR).length)
truthy(Object.keys(enUS).length >= 180)
for (const technical of ["modelKey", "generatorVersion", "stateVersion", "operationId"]) check(i18n.t(technical), technical)
truthy(ptBR["garage.restoreConfirm"].length > enUS["garage.restoreConfirm"].length)
truthy(!Object.values(enUS).some(value => /<[^>]+>/.test(value)))
truthy(!Object.values(ptBR).some(value => /<[^>]+>/.test(value)))

console.log(`SCR_UI_JS_TESTS_PASSED ${checks}`)
