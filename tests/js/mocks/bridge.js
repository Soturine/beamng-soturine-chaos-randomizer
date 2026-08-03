export const bridgeHarness = {
  loaded: [],
  envelopes: [],
  engineCalls: [],
  reset() {
    this.loaded.length = 0
    this.envelopes.length = 0
    this.engineCalls.length = 0
  },
}

export const lua = {
  extensions: {
    async load(name) { bridgeHarness.loaded.push(name) },
  },
}

const api = {
  serializeToLua(envelope) {
    bridgeHarness.envelopes.push(envelope)
    return "SERIALIZED_TEST_ENVELOPE"
  },
  engineLua(target, callback) {
    bridgeHarness.engineCalls.push(target)
    callback?.({ success: true, code: "test_command_completed" })
  },
}

export const useBridge = () => ({ api })
