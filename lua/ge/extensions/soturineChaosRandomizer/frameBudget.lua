local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local DEFAULTS = {
  idleBudgetMs = 0.50,
  busyBudgetMs = 2.50,
  raceBudgetMs = 3.50,
  uiPublishBudgetMs = 1.50,
  indexChunkBudgetMs = 2.00,
}

local function normalize(values)
  values = type(values) == "table" and values or {}
  local result = {}
  for name, fallback in pairs(DEFAULTS) do
    local value = tonumber(values[name]) or fallback
    result[name] = util.clamp(value, 0.05, 20)
  end
  return result
end

local function create(values, options)
  options = type(options) == "table" and options or {}
  return {
    values = normalize(values),
    warningCooldown = util.clamp(tonumber(options.warningCooldown) or 5, 0.25, 120),
    lastWarningAt = {}, exceeded = {}, totalExceeded = 0,
  }
end

local function budgetFor(state, mode)
  local key = mode == "race" and "raceBudgetMs" or mode == "busy" and "busyBudgetMs" or "idleBudgetMs"
  return state.values[key], key
end

local function check(state, stage, elapsedMs, budgetMs, now, warningSink)
  if type(state) ~= "table" or type(stage) ~= "string" or stage == ""
    or not util.isFinite(elapsedMs) or elapsedMs < 0
  then return false end
  budgetMs = tonumber(budgetMs) or 0
  if elapsedMs <= budgetMs then return true, false end
  state.totalExceeded = state.totalExceeded + 1
  state.exceeded[stage] = (state.exceeded[stage] or 0) + 1
  now = tonumber(now) or 0
  local last = state.lastWarningAt[stage]
  local shouldWarn = last == nil or now - last >= state.warningCooldown
  if shouldWarn then
    state.lastWarningAt[stage] = now
    if type(warningSink) == "function" then
      warningSink({stage = stage, elapsedMs = elapsedMs, budgetMs = budgetMs, repetitions = state.exceeded[stage]})
    end
  end
  -- A budget excess is evidence, never a cancellation signal.
  return true, shouldWarn
end

local function snapshot(state)
  return {
    values = util.shallowMerge({}, state.values),
    warningCooldown = state.warningCooldown,
    totalExceeded = state.totalExceeded,
    exceeded = util.shallowMerge({}, state.exceeded),
  }
end

M.DEFAULTS = DEFAULTS
M.normalize = normalize
M.create = create
M.budgetFor = budgetFor
M.check = check
M.snapshot = snapshot

return M
