const objectType = value => {
  if (value === null) return "null"
  if (Array.isArray(value)) return "array"
  return typeof value
}

const managedEntry = (value, fallbackHandle) => {
  if (!value || typeof value !== "object" || Array.isArray(value)) return null
  const handle = value.handle ?? fallbackHandle
  if (handle === undefined || handle === null || String(handle).length === 0) return null
  return { ...value, handle: String(handle) }
}

export function normalizeManagedVehicles(value, report = () => {}) {
  if (value === undefined || value === null) return []

  if (Array.isArray(value)) {
    const normalized = value.map(entry => managedEntry(entry)).filter(Boolean)
    if (normalized.length !== value.length) {
      report({ code: "invalid_state_shape", path: "spawnDirector.managed", receivedType: "array_with_invalid_entries" })
    }
    return normalized
  }

  if (typeof value === "object") {
    report({ code: "normalized_state_shape", path: "spawnDirector.managed", receivedType: "object_map" })
    return Object.keys(value)
      .sort((left, right) => left.localeCompare(right))
      .map(key => managedEntry(value[key], key))
      .filter(Boolean)
  }

  report({ code: "invalid_state_shape", path: "spawnDirector.managed", receivedType: objectType(value) })
  return []
}

export function normalizeRaceState(value, report = () => {}) {
  const race = value && typeof value === "object" && !Array.isArray(value) ? value : {}
  const spawnDirector = race.spawnDirector && typeof race.spawnDirector === "object"
    ? race.spawnDirector
    : {}
  return {
    ...race,
    spawnDirector: {
      ...spawnDirector,
      managed: normalizeManagedVehicles(spawnDirector.managed, report),
    },
  }
}

export function normalizeFullState(value, report = () => {}) {
  const state = value && typeof value === "object" && !Array.isArray(value) ? value : {}
  const spawnDirector = state.spawnDirector && typeof state.spawnDirector === "object"
    ? state.spawnDirector
    : {}
  return {
    ...state,
    spawnDirector: {
      ...spawnDirector,
      managed: normalizeManagedVehicles(spawnDirector.managed, report),
    },
  }
}

export function normalizeDomainPayload(domain, payload, report = () => {}) {
  if (domain !== "race") return payload
  return normalizeRaceState(payload, report)
}
