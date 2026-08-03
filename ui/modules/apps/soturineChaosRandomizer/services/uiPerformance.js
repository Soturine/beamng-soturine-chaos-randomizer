import { computed, nextTick, reactive } from "vue"

const now = () => globalThis.performance?.now?.() ?? Date.now()
const bytes = value => {
  try { return new TextEncoder().encode(JSON.stringify(value ?? null)).byteLength }
  catch { return 0 }
}
const percentile = (samples, ratio) => {
  if (!samples.length) return 0
  const sorted = [...samples].sort((left, right) => left - right)
  return sorted[Math.min(sorted.length - 1, Math.ceil(sorted.length * ratio) - 1)]
}
const nextFrame = () => new Promise(resolve => {
  if (typeof window !== "undefined" && typeof window.requestAnimationFrame === "function") {
    window.requestAnimationFrame(resolve)
  } else {
    setTimeout(resolve, 0)
  }
})

export function createUIPerformanceProfiler(sampleLimit = 200) {
  let renderCount = 0
  const state = reactive({
    tabSwitchSamples: [], buttonResponseSamples: [],
    fullStateApplies: 0, diffApplies: 0, fullStateApplyMs: 0, diffApplyMs: 0,
    keysChanged: 0, bytesApplied: 0, deepCloneBytes: 0,
    resizeObserverCallbacks: 0, resizeUpdates: 0, resizeCallbacksDeduplicated: 0,
    eventCount: 0, eventBytes: 0, firstEventAt: 0,
  })
  const append = (field, duration) => {
    state[field].push(duration)
    if (state[field].length > sampleLimit) state[field].splice(0, state[field].length - sampleLimit)
  }

  async function measure(kind, mutation) {
    const started = now()
    const result = mutation()
    await nextTick()
    await nextFrame()
    renderCount += 1
    append(kind === "tabSwitch" ? "tabSwitchSamples" : "buttonResponseSamples", now() - started)
    return result
  }

  function recordApply(kind, started, payload) {
    const duration = Math.max(0, now() - started)
    const payloadBytes = bytes(payload)
    const changed = payload && typeof payload === "object" ? Object.keys(payload).length : 0
    if (!state.firstEventAt) state.firstEventAt = now()
    state.eventCount += 1
    state.eventBytes += payloadBytes
    state.keysChanged = changed
    state.bytesApplied = payloadBytes
    state.deepCloneBytes += payloadBytes
    if (kind === "full") {
      state.fullStateApplies += 1
      state.fullStateApplyMs = duration
    } else {
      state.diffApplies += 1
      state.diffApplyMs = duration
    }
  }

  const summary = computed(() => {
    const elapsedSeconds = state.firstEventAt ? Math.max(0.001, (now() - state.firstEventAt) / 1000) : 0
    return {
      tabSwitchP50Ms: percentile(state.tabSwitchSamples, 0.50),
      tabSwitchP95Ms: percentile(state.tabSwitchSamples, 0.95),
      buttonResponseP50Ms: percentile(state.buttonResponseSamples, 0.50),
      buttonResponseP95Ms: percentile(state.buttonResponseSamples, 0.95),
      renderCount,
      fullStateApplies: state.fullStateApplies,
      diffApplies: state.diffApplies,
      deepCloneBytes: state.deepCloneBytes,
      resizeObserverCallbacks: state.resizeObserverCallbacks,
      guihooksPerSecond: elapsedSeconds ? state.eventCount / elapsedSeconds : 0,
      bytesPerSecond: elapsedSeconds ? state.eventBytes / elapsedSeconds : 0,
      fullStateApplyMs: state.fullStateApplyMs,
      diffApplyMs: state.diffApplyMs,
      keysChanged: state.keysChanged,
      bytesApplied: state.bytesApplied,
      componentsInvalidated: renderCount,
    }
  })

  return {
    state,
    summary,
    measure,
    recordApply,
    recordRender: () => { renderCount += 1 },
    recordResizeCallback: () => { state.resizeObserverCallbacks += 1 },
    recordResizeUpdate: () => { state.resizeUpdates += 1 },
    recordResizeDeduplicated: () => { state.resizeCallbacksDeduplicated += 1 },
  }
}
