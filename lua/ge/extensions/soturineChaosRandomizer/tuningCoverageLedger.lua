local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local TERMINAL = {
  changed = true, not_selected_by_chaos = true, locked = true, hidden = true,
  internal = true, invalid_metadata = true, fixed_value = true, single_value = true,
  same_value_unavoidable = true, same_value_retried = true, readback_confirmed = true,
  readback_clamped = true, readback_rejected = true, write_failed = true,
  rolled_back = true, category_rolled_back = true, unsupported = true,
  disappeared_after_apply = true,
}

local function create(context)
  return {
    entries = {}, order = {}, pass = 0, finalReadBack = false, unsupported = false,
    operationId = context and context.operationId,
    targetGeneration = context and context.targetGeneration,
    modelKey = context and context.modelKey,
    configIdentity = util.deepCopy(context and context.configIdentity),
  }
end

local function bindContext(state, context)
  context = type(context) == "table" and context or {}
  if state.operationId ~= nil and context.operationId ~= nil and state.operationId ~= context.operationId then return false, "coverage_operation_mismatch" end
  if state.targetGeneration ~= nil and context.targetGeneration ~= nil and state.targetGeneration ~= context.targetGeneration then return false, "coverage_target_generation_mismatch" end
  state.operationId = state.operationId or context.operationId
  state.targetGeneration = state.targetGeneration or context.targetGeneration
  state.modelKey = state.modelKey or context.modelKey
  state.configIdentity = state.configIdentity or util.deepCopy(context.configIdentity)
  return true
end

local function identity(variable)
  return table.concat({
    tostring(variable.name or ""), tostring(variable.category or ""),
    tostring(variable.subCategory or ""), tostring(variable.sourcePart or ""),
  }, "\31")
end

local function observe(state, variable, pass, newlyDiscovered)
  local key = identity(variable)
  local entry = state.entries[key]
  if not entry then
    entry = {
      identity = key, name = variable.name, title = variable.title,
      description = variable.description, category = variable.category,
      subCategory = variable.subCategory, sourcePart = variable.sourcePart,
      unit = variable.unit, minimum = variable.minimum, maximum = variable.maximum,
      step = variable.step, default = variable.default, before = variable.current,
      eligible = variable.eligible == true, locked = variable.locked == true,
      hidden = variable.hidden == true, internal = variable.internal == true,
      status = variable.status or "discovered", reason = variable.reason or "discovered",
      correlationGroup = variable.correlationGroup, firstSeenPass = pass,
      attemptCount = 0, rollbackCount = 0,
      newlyDiscovered = newlyDiscovered == true,
    }
    state.entries[key] = entry
    state.order[#state.order + 1] = key
  end
  entry.lastSeenPass = pass
  return entry
end

local function update(state, key, status, details)
  local entry = state.entries[key]
  if not entry then return false end
  entry.status = status
  entry.reason = details and details.reason or status
  for field, value in pairs(type(details) == "table" and details or {}) do
    if field ~= "reason" then entry[field] = util.deepCopy(value) end
  end
  if status == "attempted" then
    entry.attempted, entry.selectedByChaos = true, true
    entry.attemptCount = entry.attemptCount + 1
  elseif status == "changed" or status == "readback_confirmed" or status == "readback_clamped" then
    entry.attempted, entry.selectedByChaos = true, true
    entry.changed = entry.readBack ~= nil and math.abs((tonumber(entry.readBack) or 0) - (tonumber(entry.before) or 0)) > (entry.tolerance or 0)
    entry.clamped = status == "readback_clamped"
  elseif status == "not_selected_by_chaos" then entry.selectedByChaos = false
  elseif status == "locked" then entry.locked = true
  elseif status == "rolled_back" or status == "category_rolled_back" then
    entry.rollbackCount = entry.rollbackCount + 1
  end
  return true, entry
end

local function readBack(state, values, pass)
  values = type(values) == "table" and values or {}
  for _, key in ipairs(state.order) do
    local entry = state.entries[key]
    if entry.lastSeenPass and entry.lastSeenPass < pass and values[entry.name] == nil and not TERMINAL[entry.status] then
      entry.status, entry.reason = "disappeared_after_apply", "disappeared_after_apply"
    elseif entry.attempted and values[entry.name] ~= nil then
      local observed = tonumber(values[entry.name])
      entry.readBack = observed
      local tolerance = tonumber(entry.tolerance) or 1e-9
      if not util.isFinite(observed) then
        entry.status, entry.reason = "readback_rejected", "readback_non_numeric"
      elseif math.abs(observed - (tonumber(entry.requested) or observed)) <= tolerance then
        entry.status, entry.reason = "readback_confirmed", "readback_confirmed"
        entry.changed = math.abs(observed - (tonumber(entry.before) or observed)) > tolerance
      elseif observed >= (entry.minimum or observed) - tolerance and observed <= (entry.maximum or observed) + tolerance then
        entry.status, entry.reason, entry.clamped = "readback_clamped", "readback_clamped", true
        entry.changed = math.abs(observed - (tonumber(entry.before) or observed)) > tolerance
      else
        entry.status, entry.reason = "readback_rejected", "readback_out_of_range"
      end
    end
  end
  state.pass = math.max(state.pass, tonumber(pass) or 0)
  state.finalReadBack = true
end

local function summary(state)
  local result = {
    tuningDiscovered = #state.order, tuningEligible = 0, tuningSelectedByChaos = 0,
    tuningAttempted = 0, tuningChanged = 0, tuningFixed = 0, tuningLocked = 0,
    tuningInvalid = 0, tuningClamped = 0, tuningRejected = 0, tuningRolledBack = 0,
    tuningNewlyDiscovered = 0, tuningUnresolved = 0, tuningClassified = 0,
    tuningCoveragePercent = 100, tuningChangePercent = 0,
    finalReadBack = state.finalReadBack == true,
  }
  for _, key in ipairs(state.order) do
    local entry = state.entries[key]
    if entry.eligible then result.tuningEligible = result.tuningEligible + 1 end
    if entry.selectedByChaos then result.tuningSelectedByChaos = result.tuningSelectedByChaos + 1 end
    if entry.attempted then result.tuningAttempted = result.tuningAttempted + 1 end
    if entry.changed then result.tuningChanged = result.tuningChanged + 1 end
    if entry.status == "fixed_value" or entry.status == "single_value" then result.tuningFixed = result.tuningFixed + 1 end
    if entry.locked then result.tuningLocked = result.tuningLocked + 1 end
    if entry.status == "invalid_metadata" then result.tuningInvalid = result.tuningInvalid + 1 end
    if entry.clamped then result.tuningClamped = result.tuningClamped + 1 end
    if entry.status == "readback_rejected" or entry.status == "write_failed" then result.tuningRejected = result.tuningRejected + 1 end
    if (entry.rollbackCount or 0) > 0 then result.tuningRolledBack = result.tuningRolledBack + 1 end
    if entry.newlyDiscovered then result.tuningNewlyDiscovered = result.tuningNewlyDiscovered + 1 end
    if entry.eligible and TERMINAL[entry.status] then result.tuningClassified = result.tuningClassified + 1 end
    if entry.eligible and not TERMINAL[entry.status] then result.tuningUnresolved = result.tuningUnresolved + 1 end
  end
  if result.tuningEligible > 0 then
    result.tuningCoveragePercent = result.tuningClassified * 100 / result.tuningEligible
    result.tuningChangePercent = result.tuningChanged * 100 / result.tuningEligible
  end
  return result
end

M.TERMINAL = TERMINAL
M.create = create
M.bindContext = bindContext
M.identity = identity
M.observe = observe
M.update = update
M.readBack = readBack
M.summary = summary
M.isComplete = function(state)
  local result = summary(state)
  return result.tuningUnresolved == 0 and (state.finalReadBack or result.tuningAttempted == 0)
end

return M
