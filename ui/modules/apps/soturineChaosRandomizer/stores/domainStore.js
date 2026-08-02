import { reactive } from "vue"

export const createDomainStore = (name, initial) => {
  const state = reactive(initial)
  const replaceValue = (current, next) => {
    if (Array.isArray(current) && Array.isArray(next)) {
      current.splice(0, current.length, ...next)
      return current
    }
    if (current && next && typeof current === "object" && typeof next === "object" && !Array.isArray(current) && !Array.isArray(next)) {
      for (const key of Object.keys(current)) if (!(key in next)) delete current[key]
      for (const [key, value] of Object.entries(next)) current[key] = replaceValue(current[key], value)
      return current
    }
    return next
  }
  return {
    name,
    state,
    replace(value) {
      const next = value || {}
      for (const key of Object.keys(state)) if (!(key in next)) delete state[key]
      for (const [key, child] of Object.entries(next)) state[key] = replaceValue(state[key], child)
    },
    patch(value) { for (const [key, child] of Object.entries(value || {})) state[key] = replaceValue(state[key], child) },
  }
}
