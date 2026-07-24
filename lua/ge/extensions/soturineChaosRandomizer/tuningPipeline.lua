local util = require("ge/extensions/soturineChaosRandomizer/util")
local tuningLedger = require("ge/extensions/soturineChaosRandomizer/tuningCoverageLedger")

local M = {}

local function text(value)
  return type(value) == "string" and value ~= "" and value or nil
end

local function normalize(name, raw, currentValues, isLocked)
  raw = type(raw) == "table" and raw or {}
  local variable = {
    name = tostring(name or ""), title = text(raw.title), description = text(raw.description),
    category = text(raw.category), subCategory = text(raw.subCategory), unit = text(raw.unit),
    sourcePart = text(raw.sourcePart), correlationGroup = text(raw.correlationGroup),
    hidden = raw.hideInUI == true, internal = raw.internal == true or raw.isInternal == true or raw.action == true,
    minimum = tonumber(raw.min), maximum = tonumber(raw.max), default = tonumber(raw.default),
    step = tonumber(raw.step or raw.stepDis), current = tonumber(currentValues and currentValues[name]),
  }
  variable.locked = isLocked and isLocked(variable.name, variable.category, variable.subCategory) == true or false
  if variable.hidden then variable.status, variable.reason = "hidden", "hideInUI"
  elseif variable.internal then variable.status, variable.reason = "internal", "internal_or_action"
  elseif variable.name == "" or not util.isFinite(variable.minimum) or not util.isFinite(variable.maximum)
    or variable.maximum < variable.minimum
  then variable.status, variable.reason = "invalid_metadata", "invalid_range"
  else
    if not util.isFinite(variable.default) then variable.default = (variable.minimum + variable.maximum) * 0.5 end
    if not util.isFinite(variable.current) then variable.current = variable.default end
    variable.current = util.clamp(variable.current, variable.minimum, variable.maximum)
    if not util.isFinite(variable.step) or variable.step <= 0 then variable.step = nil end
    variable.eligible = not variable.locked and variable.minimum ~= variable.maximum
    variable.status = variable.locked and "locked" or (variable.minimum == variable.maximum and "fixed_value" or "eligible")
    variable.reason = variable.status
  end
  local range = variable.minimum and variable.maximum and variable.maximum - variable.minimum or 0
  variable.tolerance = variable.step and math.max(variable.step * 0.45, 1e-9) or math.max(math.abs(range) * 1e-7, 1e-9)
  return variable
end

local function selected(variable, policy, generator)
  if not variable.eligible or variable.status == "fixed_value" then return false end
  if tonumber(policy.slider) == 100 then return true end
  return generator:boolean(util.clamp(policy.chaos or 0, 0, 1))
end

local function choose(variable, policy, generator, extremeTuning)
  local minimum, maximum, current = variable.minimum, variable.maximum, variable.current
  if maximum == minimum then return current, "fixed_value", 0 end
  local range = maximum - minimum
  local useExtreme = extremeTuning == true and tonumber(policy.slider) == 100
    or generator:boolean((policy.extremeTuningChance or 0) * (extremeTuning == false and 0 or 1))
  local value
  if useExtreme then
    local atMin = math.abs(current - minimum) <= variable.tolerance
    local atMax = math.abs(current - maximum) <= variable.tolerance
    if atMin and not atMax then value = maximum
    elseif atMax and not atMin then value = minimum
    else value = generator:boolean(0.5) and minimum or maximum end
  else
    local amplitude = util.clamp(policy.chaos or 0, 0, 1)
    local center = amplitude < 0.5 and (variable.default or current) or current
    local half = range * (0.05 + 0.95 * amplitude) * 0.5
    value = generator:float(math.max(minimum, center - half), math.min(maximum, center + half))
  end
  value = util.clamp(util.roundToStep(value, variable.step, minimum), minimum, maximum)
  local attempts = 0
  while math.abs(value - current) <= variable.tolerance and attempts < 4 do
    attempts = attempts + 1
    local retry = type(generator.fork) == "function" and generator:fork("same-value-retry:" .. tostring(attempts)) or generator
    if variable.step and range / variable.step <= 4096 then
      local steps = math.max(1, math.floor(range / variable.step + 0.5))
      local currentIndex = math.floor((current - minimum) / variable.step + 0.5)
      local index = retry:integer(0, math.max(0, steps - 1))
      if index >= currentIndex then index = index + 1 end
      value = util.clamp(minimum + math.min(index, steps) * variable.step, minimum, maximum)
    else
      value = math.abs(current - minimum) > math.abs(current - maximum) and minimum or maximum
    end
  end
  local status = math.abs(value - current) <= variable.tolerance and "same_value_unavoidable"
    or (attempts > 0 and "same_value_retried" or "attempted")
  return value, status, attempts
end

local function plan(variables, currentValues, policy, generator, options, state, pass)
  options = options or {}
  state = state or tuningLedger.create()
  pass = tonumber(pass) or 1
  local values = util.deepCopy(currentValues or {})
  local changes = {}
  local newly = {}
  for _, name in ipairs(util.sortedKeys(variables or {})) do
    local variable = normalize(name, variables[name], currentValues, options.isLocked)
    local key = tuningLedger.identity(variable)
    local existed = state.entries[key] ~= nil
    local isNew = not existed and pass > 1
    local entry = tuningLedger.observe(state, variable, pass, isNew)
    if isNew then newly[#newly + 1] = name end
    if options.onlyNew and existed then
      -- Existing entries were already verified by the preceding read-back.
    elseif variable.status ~= "eligible" then
      tuningLedger.update(state, key, variable.status, {eligible = variable.eligible == true, tolerance = variable.tolerance})
    else
      local variableGenerator = type(generator.fork) == "function" and generator:fork("tuning-variable:" .. name) or generator
      local coverageGenerator = type(variableGenerator.fork) == "function"
        and variableGenerator:fork("coverage") or variableGenerator
      if not selected(variable, policy, coverageGenerator) then
        tuningLedger.update(state, key, "not_selected_by_chaos", {eligible = true})
      else
        local value, status, attempts = choose(variable, policy, variableGenerator, options.extremeTuning)
        if status == "same_value_unavoidable" then
          tuningLedger.update(state, key, status, {eligible = true, selectedByChaos = true, tolerance = variable.tolerance})
        else
          values[name] = value
          tuningLedger.update(state, key, "attempted", {
            eligible = true, requested = value, tolerance = variable.tolerance,
            attemptCount = (entry.attemptCount or 0) + attempts,
          })
          changes[#changes + 1] = {
            identity = key, name = name, previousValue = variable.current, selectedValue = value,
            minimum = variable.minimum, maximum = variable.maximum, step = variable.step,
            default = variable.default, category = variable.category, subCategory = variable.subCategory,
            sourcePart = variable.sourcePart, correlationGroup = variable.correlationGroup,
            distribution = status,
          }
        end
      end
    end
  end
  return values, changes, state, newly
end

M.normalize = normalize
M.selected = selected
M.choose = choose
M.plan = plan

return M
