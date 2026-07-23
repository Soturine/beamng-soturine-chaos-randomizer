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
    groupId = type(raw.correlationGroup) == "string" and raw.correlationGroup ~= "" and raw.correlationGroup
      or type(raw.correlationGroupId) == "string" and raw.correlationGroupId ~= "" and raw.correlationGroupId
      or nil,
    groupStrategy = raw.correlationStrategy,
  }
end

local function fork(generator, label)
  if type(generator.fork) == "function" then return generator:fork(label) end
  return generator
end

local function normalizeGroups(variables, currentValues)
  local normalized = {}
  local groups = {}
  local independent = {}
  for _, name in ipairs(util.sortedKeys(variables or {})) do
    local variable = normalizeVariable(name, variables[name], currentValues)
    if variable then
      normalized[name] = variable
      if variable.groupId and variable.groupStrategy == "shared_normalized_sample" then
        local group = groups[variable.groupId]
        if not group then
          group = {id = variable.groupId, strategy = variable.groupStrategy, members = {}}
          groups[variable.groupId] = group
        end
        group.members[#group.members + 1] = variable
      else
        independent[#independent + 1] = variable
      end
    end
  end
  return normalized, groups, independent
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
  local groupDiagnostics = {}
  local _, groups, independent = normalizeGroups(variables, currentValues)

  for _, groupId in ipairs(util.sortedKeys(groups)) do
    local group = groups[groupId]
    table.sort(group.members, function(a, b) return a.name < b.name end)
    local groupGenerator = fork(generator, "tuning-group:" .. groupId)
    local base = groupGenerator:float(0, 1)
    local diagnostics = {
      groupId = groupId,
      memberCount = #group.members,
      strategy = group.strategy,
      sampledBase = base,
      values = {},
    }
    for _, variable in ipairs(group.members) do
      local value = variable.minimum + (variable.maximum - variable.minimum) * base
      value = util.clamp(util.roundToStep(value, variable.step, variable.minimum), variable.minimum, variable.maximum)
      diagnostics.values[variable.name] = value
      if math.abs(value - variable.current) > 1e-10 then
        values[variable.name] = value
        changes[#changes + 1] = {
          name = variable.name,
          previousValue = variable.current,
          selectedValue = value,
          minimum = variable.minimum,
          maximum = variable.maximum,
          step = variable.step,
          distribution = "group_shared_normalized",
          groupId = groupId,
        }
      end
    end
    groupDiagnostics[#groupDiagnostics + 1] = diagnostics
  end

  table.sort(independent, function(a, b) return a.name < b.name end)
  for _, variable in ipairs(independent) do
    local value, distribution = sample(variable, policy, fork(generator, "tuning-variable:" .. variable.name))
    if math.abs(value - variable.current) > 1e-10 then
      values[variable.name] = value
      changes[#changes + 1] = {
        name = variable.name,
        previousValue = variable.current,
        selectedValue = value,
        minimum = variable.minimum,
        maximum = variable.maximum,
        step = variable.step,
        distribution = distribution,
      }
    end
  end
  table.sort(changes, function(a, b) return a.name < b.name end)
  return values, changes, groupDiagnostics
end

M.normalizeVariable = normalizeVariable
M.sample = sample
M.randomize = randomize
M.normalizeGroups = normalizeGroups

return M
