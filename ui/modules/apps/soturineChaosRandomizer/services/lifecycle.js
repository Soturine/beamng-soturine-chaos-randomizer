export function createLifecycleRegistry() {
  const cleanups = new Set()
  let disposed = false
  return {
    add(cleanup) {
      if (typeof cleanup !== "function") return cleanup
      if (disposed) cleanup()
      else cleanups.add(cleanup)
      return cleanup
    },
    remove(cleanup) { cleanups.delete(cleanup) },
    dispose() {
      if (disposed) return
      disposed = true
      for (const cleanup of [...cleanups].reverse()) {
        try { cleanup() } catch (error) { console.error("SCR lifecycle cleanup failed", error) }
      }
      cleanups.clear()
    },
    get size() { return cleanups.size },
    get disposed() { return disposed },
  }
}
