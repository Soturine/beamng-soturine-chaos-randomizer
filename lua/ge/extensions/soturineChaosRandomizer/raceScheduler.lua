local M = {}

local function audit(lineup, context)
  context = type(context) == "table" and context or {}
  if type(lineup) ~= "table" then return {state = "idle", schedule = false} end
  if lineup.active ~= true then return {state = "finished", schedule = false} end
  if context.busy == true or context.activeOperation == true then
    return {state = "operation_active", schedule = false}
  end
  if context.pendingNext == true then
    return {state = "scheduled", schedule = false}
  end
  local open
  for _, competitor in ipairs(lineup.competitors or {}) do
    if competitor.generationClosed ~= true then open = competitor; break end
  end
  local healed = false
  if open and open.status ~= "planned" then
    local previousStatus = open.status
    open.status = "failed"
    open.phase = "failed"
    open.terminalState = "failed"
    open.failureCode = "lineup_scheduler_lost_operation"
    open.generationStatus = "failed"
    open.generationClosed = true
    open.dna, open.dnaId, open.vehicleDNAId = nil, nil, nil
    open.warning = "The abandoned slot was closed so later competitors can continue"
    lineup.nextIndex = open.index + 1
    healed = true
    return {
      state = "self_healed", schedule = true, healed = true,
      slot = open.index, previousStatus = previousStatus,
    }
  end
  return {
    state = "scheduled", schedule = true, healed = healed,
    slot = open and open.index or nil,
  }
end

M.audit = audit

return M
