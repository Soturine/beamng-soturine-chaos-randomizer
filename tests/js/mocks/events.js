const handlers = new Map()

export const eventHarness = {
  reset() { handlers.clear() },
  emit(name, payload) {
    for (const handler of [...(handlers.get(name) || [])]) handler(payload)
  },
  count(name) { return handlers.get(name)?.size || 0 },
  get total() { return [...handlers.values()].reduce((total, values) => total + values.size, 0) },
}

const events = {
  on(name, handler) {
    if (!handlers.has(name)) handlers.set(name, new Set())
    handlers.get(name).add(handler)
    return () => events.off(name, handler)
  },
  off(name, handler) {
    handlers.get(name)?.delete(handler)
    if (handlers.get(name)?.size === 0) handlers.delete(name)
  },
}

export const useEvents = () => events
