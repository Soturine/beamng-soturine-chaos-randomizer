local uiProtocol = require("ge/extensions/soturineChaosRandomizer/uiProtocol")

local M = {}

local ALL_SECTIONS = {
  "core", "chaos", "garage", "race", "settings", "compatibility",
  "diagnostics", "performance", "uiLayout",
}

local function lifecycleOf(state)
  return type(state) == "table" and type(state.lifecycle) == "table" and state.lifecycle or {}
end

local function full(sequence, state, timestamp, eventType)
  return uiProtocol.envelope(
    sequence, eventType or "full", "all", state, ALL_SECTIONS,
    lifecycleOf(state), timestamp
  )
end

local function diff(sequence, domain, payload, dirtySections, lifecycle, timestamp)
  return uiProtocol.envelope(
    sequence, "diff", domain, payload, dirtySections,
    lifecycle, timestamp
  )
end

M.ALL_SECTIONS = ALL_SECTIONS
M.full = full
M.diff = diff

return M
