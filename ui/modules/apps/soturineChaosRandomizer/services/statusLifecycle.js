import { reactive } from "vue"

export function createStatusLifecycle(options = {}) {
  const now = options.now || (() => Date.now())
  const schedule = options.setTimeout || globalThis.setTimeout?.bind(globalThis)
  const cancel = options.clearTimeout || globalThis.clearTimeout?.bind(globalThis)
  const items = reactive([])
  const timers = new Map()
  let sequence = 0

  function remove(id) {
    const index = items.findIndex(item => item.id === id)
    if (index >= 0) items.splice(index, 1)
    if (timers.has(id)) cancel?.(timers.get(id))
    timers.delete(id)
  }

  function prune() {
    const current = now()
    for (const item of [...items]) if (!item.persistent && item.expiresAt <= current) remove(item.id)
  }

  function push(value = {}) {
    prune()
    const createdAt = Number(value.createdAt) || now()
    const scope = value.scope || "global"
    const tab = value.tab || null
    const operationId = value.operationId || null
    const duplicate = items.find(item => item.code === value.code && item.scope === scope
      && item.tab === tab && item.operationId === operationId)
    if (duplicate) remove(duplicate.id)
    const persistent = value.persistent === true
    const ttl = Math.max(250, Number(value.ttl) || 5000)
    const item = {
      id: value.id || `status-${++sequence}`,
      code: String(value.code || "unknown"),
      scope,
      severity: value.severity || "info",
      createdAt,
      expiresAt: persistent ? Number.POSITIVE_INFINITY : createdAt + ttl,
      operationId,
      tab,
      persistent,
      values: value.values || {},
      recoverable: value.recoverable === true,
      dismissible: value.dismissible === true,
      action: value.action || null,
    }
    items.push(item)
    if (!persistent && schedule) timers.set(item.id, schedule(() => remove(item.id), ttl))
    return item
  }

  function replaceOperation(value) {
    for (const item of [...items]) if (item.scope === "operation") remove(item.id)
    return value ? push({ ...value, scope: "operation" }) : null
  }

  function clearWhere(predicate) {
    if (typeof predicate !== "function") return 0
    const matches = items.filter(predicate)
    for (const item of matches) remove(item.id)
    return matches.length
  }

  function current(tab, operationId = null) {
    prune()
    const severity = { error: 3, warning: 2, success: 1, info: 0 }
    const scopePriority = { operation: 2, tab: 1, global: 0 }
    return [...items].filter(item => item.scope === "global"
      || item.scope === "tab" && item.tab === tab
      || item.scope === "operation" && (!item.operationId || item.operationId === operationId))
      .sort((left, right) => (severity[right.severity] || 0) - (severity[left.severity] || 0)
        || (scopePriority[right.scope] || 0) - (scopePriority[left.scope] || 0)
        || right.createdAt - left.createdAt)[0] || null
  }

  function dispose() {
    for (const id of [...timers.keys()]) remove(id)
    items.splice(0, items.length)
  }

  return { items, push, remove, prune, replaceOperation, clearWhere, current, dispose }
}
