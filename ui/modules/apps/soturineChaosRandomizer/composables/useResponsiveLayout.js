import { onMounted, onUnmounted } from "vue"

export function useResponsiveLayout(target, layout) {
  const state = layout.state || layout
  let observer = null
  let media = null
  const updateMotion = () => { state.reducedMotion = media?.matches === true }

  onMounted(() => {
    if (typeof ResizeObserver === "function" && target.value) {
      observer = new ResizeObserver(entries => {
        const rect = entries[entries.length - 1]?.contentRect
        if (!rect) return
        if (typeof layout.recordHostSize === "function") layout.recordHostSize(rect.width, rect.height)
        else { state.width = Math.round(rect.width); state.height = Math.round(rect.height) }
      })
      observer.observe(target.value)
    }
    media = window.matchMedia?.("(prefers-reduced-motion: reduce)") || null
    media?.addEventListener?.("change", updateMotion)
    updateMotion()
  })

  onUnmounted(() => {
    observer?.disconnect()
    observer = null
    media?.removeEventListener?.("change", updateMotion)
    media = null
  })
}
