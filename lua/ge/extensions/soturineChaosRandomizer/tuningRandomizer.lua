local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function normalizeVariable(name, raw, currentValues)
  if type(raw) ~= "table" or raw.hideInUI == true then return nil end
  local minimum = tonumber(raw.min)
  local maximum = tonumber(raw.max)
  local default = tonumber(raw.default)
  if not util.isFinite(minimum) or not util.isFinite(maximum) or maximum < minimum then return nil end
  if not util.isFinite(default) then default = (minimum + maximum) * 0.5 end
  default = util.clamp(default, minimum, maximum)
  local current = tonumber(currentValues and currentValues[name])
  if not util.isFinite(current) then current = default end
  local step = tonumber(raw.step or raw.stepDis)
  if not util.isFinite(step) or step <= 0 then step = nil end
  return {
    name = name,
    minimum = minimum,
    maximum = maximum,
    default = default,
    current = util.clamp(current, minimum, maximum),
    step = step,
  }
end

local function sample(variable, policy, generator)
  local range = variable.maximum - variable.minimum
  if range == 0 then return variable.current, "fixed" end

  local value
  local distribution
  if generator:boolean(policy.extremeTuningChance) then
    value = generator:boolean(0.5) and variable.minimum or variable.maximum
    distribution = "extreme"
  elseif generator:boolean(policy.chaos) then
    value = generator:float(variable.minimum, variable.maximum)
    distribution = "uniform"
  else
    local triangular = (generator:float(-1, 1) + generator:float(-1, 1)) * 0.5
    value = variable.default + triangular * range * policy.tuningSpread
    distribution = "default_centered"
  end

  value = util.clamp(value, variable.minimum, variable.maximum)
  value = util.roundToStep(value, variable.step, variable.minimum)
  value = util.clamp(value, variable.minimum, variable.maximum)
  return value, distribution
end

local function randomize(variables, currentValues, policy, generator)
  local values = util.deepCopy(currentValues or {})
  local changes = {}
  for _, name in ipairs(util.sortedKeys(variables or {})) do
    local variable = normalizeVariable(name, variables[name], currentValues)
    if variable then
      local value, distribution = sample(variable, policy, generator)
      if math.abs(value - variable.current) > 1e-10 then
        values[name] = value
        changes[#changes + 1] = {
          name = name,
          previousValue = variable.current,
          selectedValue = value,
          minimum = variable.minimum,
          maximum = variable.maximum,
          step = variable.step,
          distribution = distribution,
        }
      end
    end
  end
  return values, changes
end

M.normalizeVariable = normalizeVariable
M.sample = sample
M.randomize = randomize

return M
