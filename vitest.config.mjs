import { fileURLToPath, URL } from "node:url"
import { defineConfig } from "vitest/config"
import vue from "@vitejs/plugin-vue"

const fixture = name => fileURLToPath(new URL(`./tests/js/mocks/${name}`, import.meta.url))

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: [
      { find: "@/bridge", replacement: fixture("bridge.js") },
      { find: "@/services/events", replacement: fixture("events.js") },
      { find: "@/services/settings", replacement: fixture("settings.js") },
      { find: "@/common/directives", replacement: fixture("directives.js") },
      { find: "@/common/components/base", replacement: fixture("base.js") },
    ],
  },
  test: {
    environment: "jsdom",
    include: ["tests/js/**/*.mounted.test.js"],
    setupFiles: ["tests/js/mounted.setup.js"],
    restoreMocks: true,
    clearMocks: true,
  },
})
