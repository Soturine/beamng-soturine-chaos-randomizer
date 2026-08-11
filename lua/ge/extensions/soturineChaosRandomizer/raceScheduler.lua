local M = {}

local function schedulerState(lineup)
  lineup.scheduler = type(lineup.scheduler) == "table" and lineup.scheduler or {
    idleAudits = 0, requeueAttempts = 0, enqueueFailures = 0,
    maxIdleAudits = 3, maxRequeueAttempts = 4, maxEnqueueFailures = 3,
  }
  return lineup.scheduler
end

local function audit(lineup, context)
  context = type(context) == "table" and context or {}
  if type(lineup) ~= "table" then return {state = "idle", schedule = false} end
  if lineup.active ~= true then return {state = "finished", schedule = false} end
  local scheduler = schedulerState(lineup)
  if context.busy == true or context.activeOperation == true then
    scheduler.idleAudits = 0
    return {state = "operation_active", schedule = false}
  end
  if context.pendingNext == true then
    scheduler.idleAudits = scheduler.idleAudits + 1
    if scheduler.idleAudits >= scheduler.maxIdleAudits then
      scheduler.idleAudits = 0
      scheduler.requeueAttempts = scheduler.requeueAttempts + 1
      if scheduler.requeueAttempts > scheduler.maxRequeueAttempts then
        return {state = "terminal", schedule = false, terminal = true,
          reason = "lineup_scheduler_progress_exhausted"}
      end
      return {state = "requeueing", schedule = true, requeue = true,
        attempt = scheduler.requeueAttempts}
    end
    return {state = "scheduled", schedule = false}
  end
  scheduler.idleAudits = 0
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

local function noteEnqueue(lineup, succeeded, reason)
  if type(lineup) ~= "table" then return {terminal = false} end
  local scheduler = schedulerState(lineup)
  scheduler.lastEnqueueReason = tostring(reason or "")
  if succeeded then
    scheduler.lastEnqueueSucceeded = true
    return {terminal = false}
  end
  scheduler.lastEnqueueSucceeded = false
  scheduler.enqueueFailures = scheduler.enqueueFailures + 1
  if scheduler.enqueueFailures >= scheduler.maxEnqueueFailures then
    return {terminal = true, reason = "lineup_scheduler_enqueue_exhausted"}
  end
  return {terminal = false, retry = true}
end

local function noteDispatch(lineup)
  if type(lineup) ~= "table" then return false end
  local scheduler = schedulerState(lineup)
  scheduler.idleAudits = 0
  scheduler.requeueAttempts = 0
  scheduler.enqueueFailures = 0
  scheduler.dispatches = (scheduler.dispatches or 0) + 1
  return true
end

M.audit = audit
M.noteEnqueue = noteEnqueue
M.noteDispatch = noteDispatch

return M
