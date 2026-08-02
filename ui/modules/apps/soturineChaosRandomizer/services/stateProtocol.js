import { UI_PROTOCOL_VERSION } from "./commandBridge"

export const EVENT_TYPES = new Set(["full", "diff", "reset", "rejection"])
export const DOMAINS = new Set([
  "all", "core", "chaos", "garage", "race", "settings",
  "compatibility", "diagnostics", "performance", "uiLayout",
])

export function createStateProtocol({ applyFull, applyDiff, requestFull, reject }) {
  let appliedVersion = 0
  let recoveryPending = false

  function validate(envelope) {
    return envelope && typeof envelope === "object"
      && envelope.protocolVersion === UI_PROTOCOL_VERSION
      && Number.isInteger(envelope.stateVersion) && envelope.stateVersion > 0
      && EVENT_TYPES.has(envelope.eventType)
      && DOMAINS.has(envelope.domain)
      && envelope.payload && typeof envelope.payload === "object"
  }

  async function recover(reason) {
    if (recoveryPending) return
    recoveryPending = true
    reject(reason)
    try { await requestFull() } finally { recoveryPending = false }
  }

  function apply(envelope) {
    if (!validate(envelope)) { recover("state_envelope_invalid"); return false }
    if (envelope.eventType !== "reset" && envelope.stateVersion <= appliedVersion) return false
    if (envelope.eventType === "diff" && envelope.stateVersion !== appliedVersion + 1) {
      recover("state_version_gap")
      return false
    }
    if (envelope.eventType === "full" || envelope.eventType === "reset") {
      applyFull(envelope.payload, envelope)
    } else if (envelope.eventType === "diff") {
      applyDiff(envelope.domain, envelope.payload, envelope.dirtySections || [], envelope)
    } else {
      reject(envelope.payload.code || "state_rejected")
    }
    appliedVersion = envelope.stateVersion
    return true
  }

  return {
    apply,
    reset: () => { appliedVersion = 0; recoveryPending = false },
    get appliedVersion() { return appliedVersion },
    get recoveryPending() { return recoveryPending },
  }
}
