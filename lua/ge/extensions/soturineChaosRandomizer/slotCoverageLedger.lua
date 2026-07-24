local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local TERMINAL = {
  changed = true,
  unchanged_same_selection = true,
  not_selected_by_chaos = true,
  no_alternative = true,
  locked = true,
  protected = true,
  skipped_incompatible = true,
  candidate_exhausted = true,
  failed_and_rolled_back = true,
  disappeared_after_parent_change = true,
  unsupported = true,
}

local function configKey(value)
  if type(value) == "table" then
    return tostring(value.path or value.key or value.signature or "")
  end
  return tostring(value or "")
end

local function identity(context, slot)
  return table.concat({
    tostring(context and context.modelKey or ""),
    configKey(context and context.configIdentity),
    tostring(slot and slot.parentPath or ""),
    tostring(slot and slot.path or ""),
    tostring(slot and (slot.slotType or slot.id) or ""),
    tostring(slot and slot.depth or 0),
  }, "\31")
end

local function create(context)
  return {
    operationId = context and context.operationId,
    targetGeneration = context and context.targetGeneration,
    modelKey = context and context.modelKey,
    configIdentity = util.deepCopy(context and context.configIdentity),
    entries = {},
    order = {},
    passesUsed = 0,
    reloadsUsed = 0,
    candidateAttempts = 0,
    limitReason = nil,
    converged = false,
    finalReadBack = false,
  }
end

local function bindContext(state, context)
  context = type(context) == "table" and context or {}
  if state.operationId ~= nil and context.operationId ~= nil and state.operationId ~= context.operationId then
    return false, "coverage_operation_mismatch"
  end
  if state.targetGeneration ~= nil and context.targetGeneration ~= nil and state.targetGeneration ~= context.targetGeneration then
    return false, "coverage_target_generation_mismatch"
  end
  state.operationId = state.operationId or context.operationId
  state.targetGeneration = state.targetGeneration or context.targetGeneration
  state.modelKey = state.modelKey or context.modelKey
  state.configIdentity = state.configIdentity or util.deepCopy(context.configIdentity)
  return true
end

local function observe(state, context, slot, pass)
  local key = identity(context, slot)
  local entry = state.entries[key]
  if not entry then
    entry = {
      identity = key,
      modelKey = context and context.modelKey,
      configIdentity = util.deepCopy(context and context.configIdentity),
      parentPath = slot.parentPath,
      slotPath = slot.path,
      slotType = slot.slotType or slot.id,
      depth = tonumber(slot.depth) or 0,
      firstSeenPass = pass,
      status = "discovered",
      reason = "discovered",
      newlyDiscovered = pass > 1,
      rollbackCount = 0,
      attemptCount = 0,
      quarantinedCandidates = {},
    }
    state.entries[key] = entry
    state.order[#state.order + 1] = key
  end
  entry.lastSeenPass = pass
  entry.currentPart = slot.currentPart or ""
  entry.finalPart = entry.finalPart or entry.currentPart
  entry.candidateCount = #(slot.candidates or {})
  entry.disappeared = false
  return entry
end

local function observeScan(state, context, scan, pass)
  state.passesUsed = math.max(state.passesUsed or 0, tonumber(pass) or 0)
  local seen = {}
  for _, slot in ipairs(scan and scan.slots or {}) do
    local entry = observe(state, context, slot, pass)
    seen[entry.identity] = true
  end
  for _, key in ipairs(state.order) do
    local entry = state.entries[key]
    if entry.lastSeenPass and entry.lastSeenPass < pass and not seen[key] and not TERMINAL[entry.status] then
      entry.disappeared = true
      entry.eligible = entry.eligible == true
      entry.status = "disappeared_after_parent_change"
      entry.reason = "disappeared_after_parent_change"
    end
  end
end

local function classify(state, key, status, details)
  local entry = state.entries[key]
  if not entry then return false, "unknown_slot_identity" end
  details = type(details) == "table" and details or {}
  entry.status = status
  entry.reason = details.reason or status
  for field, value in pairs(details) do
    if field ~= "reason" then entry[field] = util.deepCopy(value) end
  end
  if status == "pending" or status == "eligible" then entry.eligible = true end
  if status == "attempted" then
    entry.eligible, entry.selectedByChaos, entry.attempted = true, true, true
    entry.attemptCount = (entry.attemptCount or 0) + 1
    state.candidateAttempts = (state.candidateAttempts or 0) + 1
  elseif status == "changed" then
    entry.eligible, entry.selectedByChaos, entry.attempted, entry.changed = true, true, true, true
  elseif status == "not_selected_by_chaos" then
    entry.eligible, entry.selectedByChaos = true, false
  elseif status == "locked" then
    entry.locked = true
  elseif status == "protected" then
    entry.protected = true
  elseif status == "failed_and_rolled_back" then
    entry.rollbackCount = (entry.rollbackCount or 0) + 1
  end
  return true, entry
end

local function classifyDecision(state, context, slot, decision, pass)
  local entry = observe(state, context, slot, pass)
  decision = decision or {}
  entry.eligible = true
  entry.selectedByChaos = decision.reason ~= "not_selected_by_chaos"
  entry.attempted = not decision.skipped and decision.selectedPart ~= nil
  if entry.attempted then
    entry.attemptCount = (entry.attemptCount or 0) + 1
    state.candidateAttempts = (state.candidateAttempts or 0) + 1
  end
  entry.finalPart = decision.selectedPart or slot.currentPart or ""
  entry.locked = decision.locked == true
  entry.protected = decision.protected == true
  local status = decision.reason or "unresolved"
  if entry.locked then status = "locked"
  elseif entry.protected then status = "protected"
  elseif decision.deferred then status = "pending"
  elseif decision.selectedPart ~= nil and decision.selectedPart ~= decision.previousPart then status = "changed"
  elseif status == "candidate_blacklisted" or status == "candidate_suspect_suppressed" then status = "skipped_incompatible"
  elseif status == "compatible_alternative" or status == "chaos_missing_part" then status = "unchanged_same_selection"
  end
  entry.changed = status == "changed"
  entry.status = status
  entry.reason = decision.reason or status
  return entry
end

local function markFinalParts(state, parts)
  for _, key in ipairs(state.order) do
    local entry = state.entries[key]
    if parts and parts[entry.slotPath] ~= nil then
      entry.finalPart = parts[entry.slotPath]
      entry.changed = entry.finalPart ~= entry.currentPart
      if entry.status == "attempted" or entry.status == "pending" then
        entry.status = entry.changed and "changed" or "unchanged_same_selection"
        entry.reason = "final_readback"
      end
    end
  end
  state.finalReadBack = true
end

local function summary(state)
  local result = {
    slotsDiscovered = #state.order, slotsEligible = 0, slotsSelectedByChaos = 0,
    slotsAttempted = 0, slotsChanged = 0, slotsUnchanged = 0, slotsLocked = 0,
    slotsProtected = 0, slotsNoAlternative = 0, slotsIncompatible = 0,
    slotsCandidateExhausted = 0, slotsRolledBack = 0, slotsNewlyDiscovered = 0,
    slotsUnresolved = 0, slotsClassified = 0, passesUsed = state.passesUsed or 0,
    reloadsUsed = state.reloadsUsed or 0, coveragePercent = 100, changePercent = 0,
    limitReason = state.limitReason, converged = state.converged == true,
    finalReadBack = state.finalReadBack == true,
  }
  for _, key in ipairs(state.order) do
    local entry = state.entries[key]
    if entry.eligible then result.slotsEligible = result.slotsEligible + 1 end
    if entry.selectedByChaos then result.slotsSelectedByChaos = result.slotsSelectedByChaos + 1 end
    if entry.attempted then result.slotsAttempted = result.slotsAttempted + 1 end
    if entry.changed then result.slotsChanged = result.slotsChanged + 1 end
    if entry.locked then result.slotsLocked = result.slotsLocked + 1 end
    if entry.protected then result.slotsProtected = result.slotsProtected + 1 end
    if entry.status == "no_alternative" then result.slotsNoAlternative = result.slotsNoAlternative + 1 end
    if entry.status == "skipped_incompatible" then result.slotsIncompatible = result.slotsIncompatible + 1 end
    if entry.status == "candidate_exhausted" then result.slotsCandidateExhausted = result.slotsCandidateExhausted + 1 end
    if (entry.rollbackCount or 0) > 0 then result.slotsRolledBack = result.slotsRolledBack + 1 end
    if entry.newlyDiscovered then result.slotsNewlyDiscovered = result.slotsNewlyDiscovered + 1 end
    if entry.eligible and TERMINAL[entry.status] then result.slotsClassified = result.slotsClassified + 1 end
    if entry.eligible and not TERMINAL[entry.status] then result.slotsUnresolved = result.slotsUnresolved + 1 end
  end
  result.slotsUnchanged = math.max(0, result.slotsClassified - result.slotsChanged)
  if result.slotsEligible > 0 then
    result.coveragePercent = result.slotsClassified * 100 / result.slotsEligible
    result.changePercent = result.slotsChanged * 100 / result.slotsEligible
  end
  return result
end

M.TERMINAL = TERMINAL
M.create = create
M.bindContext = bindContext
M.identity = identity
M.observe = observe
M.observeScan = observeScan
M.classify = classify
M.classifyDecision = classifyDecision
M.markFinalParts = markFinalParts
M.summary = summary
M.isComplete = function(state)
  local result = summary(state)
  return result.slotsUnresolved == 0 and state.finalReadBack == true and state.limitReason == nil
end

return M
