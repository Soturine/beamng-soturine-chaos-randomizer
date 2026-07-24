local M = {}

local TERMINAL = {
  changed = true, locked = true, unsupported = true,
  not_selected_by_chaos = true, readback_confirmed = true, readback_rejected = true,
}

local FIELDS = {"baseColor", "metallic", "roughness", "clearcoat", "clearcoatRoughness"}

local function create(paints, isLocked, supported, context)
  local state = {
    entries = {}, order = {}, finalReadBack = false,
    operationId = context and context.operationId,
    targetGeneration = context and context.targetGeneration,
    modelKey = context and context.modelKey,
    configIdentity = context and context.configIdentity,
  }
  if supported == false then
    state.entries.unsupported = {identity = "unsupported", status = "unsupported", reason = "paint_capability_unavailable"}
    state.order[1] = "unsupported"
    return state
  end
  for layer = 1, #(paints or {}) do
    for _, field in ipairs(FIELDS) do
      local key = tostring(layer) .. ":" .. field
      local locked = isLocked and isLocked(layer, field) == true or false
      state.entries[key] = {
        identity = key, layer = layer, field = field, discovered = true,
        eligible = not locked, attempted = false, changed = false, locked = locked,
        status = locked and "locked" or "discovered", reason = locked and "locked" or "discovered",
      }
      state.order[#state.order + 1] = key
    end
  end
  return state
end

local function bindContext(state, context)
  context = type(context) == "table" and context or {}
  if state.operationId ~= nil and context.operationId ~= nil and state.operationId ~= context.operationId then return false, "coverage_operation_mismatch" end
  if state.targetGeneration ~= nil and context.targetGeneration ~= nil and state.targetGeneration ~= context.targetGeneration then return false, "coverage_target_generation_mismatch" end
  state.operationId = state.operationId or context.operationId
  state.targetGeneration = state.targetGeneration or context.targetGeneration
  state.modelKey = state.modelKey or context.modelKey
  state.configIdentity = state.configIdentity or context.configIdentity
  return true
end

local function requested(state, before, after, selectedLayers)
  for _, key in ipairs(state.order) do
    local entry = state.entries[key]
    if entry.eligible then
      local selected = selectedLayers and selectedLayers[entry.layer]
      entry.selectedByChaos = selected == true
      if not selected then
        entry.status, entry.reason = "not_selected_by_chaos", "not_selected_by_chaos"
      else
        entry.attempted = true
        entry.before = before and before[entry.layer] and before[entry.layer][entry.field]
        entry.requested = after and after[entry.layer] and after[entry.layer][entry.field]
        entry.status, entry.reason = "attempted", "attempted"
      end
    end
  end
end

local function scalarEqual(left, right, tolerance)
  if type(left) == "number" and type(right) == "number" then return math.abs(left - right) <= tolerance end
  if type(left) == "table" and type(right) == "table" then
    for index = 1, math.max(#left, #right) do if not scalarEqual(left[index], right[index], tolerance) then return false end end
    return true
  end
  return left == right
end

local function readBack(state, paints)
  for _, key in ipairs(state.order) do
    local entry = state.entries[key]
    if entry.attempted then
      entry.readBack = paints and paints[entry.layer] and paints[entry.layer][entry.field]
      if scalarEqual(entry.requested, entry.readBack, 1e-5) then
        entry.changed = not scalarEqual(entry.before, entry.readBack, 1e-5)
        entry.status, entry.reason = "readback_confirmed", "readback_confirmed"
      else
        entry.status, entry.reason = "readback_rejected", "paint_readback_mismatch"
      end
    end
  end
  state.finalReadBack = true
end

local function summary(state)
  local result = {paintDiscovered = #state.order, paintEligible = 0, paintAttempted = 0, paintChanged = 0, paintLocked = 0, paintUnsupported = 0, paintRejected = 0, paintUnresolved = 0, paintClassified = 0, paintCoveragePercent = 100, paintChangePercent = 0, finalReadBack = state.finalReadBack == true}
  for _, key in ipairs(state.order) do
    local entry = state.entries[key]
    if entry.eligible then result.paintEligible = result.paintEligible + 1 end
    if entry.attempted then result.paintAttempted = result.paintAttempted + 1 end
    if entry.changed then result.paintChanged = result.paintChanged + 1 end
    if entry.locked then result.paintLocked = result.paintLocked + 1 end
    if entry.status == "unsupported" then result.paintUnsupported = result.paintUnsupported + 1 end
    if entry.status == "readback_rejected" then result.paintRejected = result.paintRejected + 1 end
    if entry.eligible and TERMINAL[entry.status] then result.paintClassified = result.paintClassified + 1 end
    if entry.eligible and not TERMINAL[entry.status] then result.paintUnresolved = result.paintUnresolved + 1 end
  end
  if result.paintEligible > 0 then
    result.paintCoveragePercent = result.paintClassified * 100 / result.paintEligible
    result.paintChangePercent = result.paintChanged * 100 / result.paintEligible
  end
  return result
end

M.FIELDS = FIELDS
M.create = create
M.bindContext = bindContext
M.requested = requested
M.readBack = readBack
M.summary = summary
M.isComplete = function(state)
  local result = summary(state)
  return result.paintUnresolved == 0 and (state.finalReadBack or result.paintAttempted == 0)
end

return M
