import { afterEach, beforeEach } from "vitest"
import { bridgeHarness } from "./mocks/bridge.js"
import { eventHarness } from "./mocks/events.js"
import { gameSettingsHarness } from "./mocks/settings.js"

export const resizeHarness = {
  instances: [],
  reset() { this.instances.length = 0 },
  active() { return this.instances.filter(instance => !instance.disconnected).length },
}

class TestResizeObserver {
  constructor(callback) {
    this.callback = callback
    this.disconnected = false
    resizeHarness.instances.push(this)
  }
  observe(element) { this.element = element }
  disconnect() { this.disconnected = true }
  emit(width, height) { this.callback([{ contentRect: { width, height } }]) }
}

let nextFrame = 1
const frames = new Map()

beforeEach(() => {
  bridgeHarness.reset()
  eventHarness.reset()
  gameSettingsHarness.reset()
  resizeHarness.reset()
  frames.clear()
  nextFrame = 1
  globalThis.ResizeObserver = TestResizeObserver
  window.requestAnimationFrame = callback => {
    const id = nextFrame++
    frames.set(id, callback)
    queueMicrotask(() => {
      const scheduled = frames.get(id)
      if (!scheduled) return
      frames.delete(id)
      scheduled(performance.now())
    })
    return id
  }
  window.cancelAnimationFrame = id => frames.delete(id)
  window.matchMedia = () => ({
    matches: false,
    addEventListener() {},
    removeEventListener() {},
  })
})

afterEach(() => {
  eventHarness.reset()
  frames.clear()
  document.body.innerHTML = ""
})
