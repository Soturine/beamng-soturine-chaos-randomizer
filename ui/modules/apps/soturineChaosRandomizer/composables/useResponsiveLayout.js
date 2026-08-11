import { onMounted, onUnmounted } from "vue"

export const widthClassFor = width => Number(width) < 400 ? "narrow" : Number(width) < 640 ? "medium" : "wide"

export function useResponsiveLayout(target, layout, profiler = null) {
  profiler = profiler || layout.profiler || null
  const state = layout.state || layout
  let observer = null
  let media = null
  let active = false
  let pendingSize = null
  let frameId = null
  let frameUsesTimeout = false
  let lastWidth = null
  let lastHeight = null
  const metrics = { resizeObserverCallbacks: 0, resizeUpdates: 0, deduplicatedCallbacks: 0 }
  const updateMotion = () => { state.reducedMotion = media?.matches === true }
  const flushSize = () => {
    frameId = null
    if (!active || !pendingSize) return
    const { width, height } = pendingSize
    pendingSize = null
    if (width === lastWidth && height === lastHeight) {
      metrics.deduplicatedCallbacks += 1
      profiler?.recordResizeDeduplicated?.()
      return
    }
    lastWidth = width
    lastHeight = height
    metrics.resizeUpdates += 1
    profiler?.recordResizeUpdate?.()
    if (typeof layout.recordHostSize === "function") layout.recordHostSize(width, height, { source: "appHost" })
    else { state.width = width; state.height = height }
  }
  const scheduleSize = (width, height) => {
    pendingSize = { width, height }
    if (frameId !== null) return
    if (typeof window.requestAnimationFrame === "function") {
      frameUsesTimeout = false
      frameId = window.requestAnimationFrame(flushSize)
    } else {
      frameUsesTimeout = true
      frameId = window.setTimeout(flushSize, 0)
    }
  }

  onMounted(() => {
    active = true
    if (typeof ResizeObserver === "function" && target.value) {
      // AppHost owns outer placement and size. Observing the application's
      // auto-sized child created a shrink/reflow/measure feedback loop in
      // v0.7.5, so responsiveness is driven only by the host container.
      const appHost = target.value.parentElement || target.value
      observer = new ResizeObserver(entries => {
        metrics.resizeObserverCallbacks += 1
        profiler?.recordResizeCallback?.()
        const rect = entries[entries.length - 1]?.contentRect
        if (!rect) return
        const width = Math.max(1, Math.round(Number(rect.width) || state.width || 1))
        const height = Math.max(1, Math.round(Number(rect.height) || state.height || 1))
        if ((width === lastWidth && height === lastHeight)
          || (pendingSize?.width === width && pendingSize?.height === height)) {
          metrics.deduplicatedCallbacks += 1
          profiler?.recordResizeDeduplicated?.()
          return
        }
        scheduleSize(width, height)
      })
      observer.observe(appHost)
    }
    media = window.matchMedia?.("(prefers-reduced-motion: reduce)") || null
    media?.addEventListener?.("change", updateMotion)
    updateMotion()
  })

  onUnmounted(() => {
    active = false
    observer?.disconnect()
    observer = null
    if (frameId !== null) {
      if (frameUsesTimeout) window.clearTimeout(frameId)
      else window.cancelAnimationFrame?.(frameId)
    }
    frameId = null
    pendingSize = null
    media?.removeEventListener?.("change", updateMotion)
    media = null
  })

  return { metrics }
}
