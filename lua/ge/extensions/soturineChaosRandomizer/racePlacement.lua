-- Fast one-click reposition of existing Race vehicles.
--
-- plan -> authorize -> teleport every slot -> parallel readback -> one bounded
-- retry of only the failed slots -> complete. Reposition never inherits the
-- conservative spawn pipeline. Engine side effects arrive through deps:
--   deps.registry        managed registry state
--   deps.authorize(c)    -> entry | nil, reason, placementState
--   deps.place(id, p)    -> ok, reason   (spawn.safeTeleport underneath)
--   deps.exists(id)      -> boolean
--   deps.position(id)    -> ok, {x,y,z} | reason
--   deps.aiUsable(c)     -> boolean
--   deps.now, deps.timeout
local util = require("ge/extensions/soturineChaosRandomizer/util")
local managedRegistry = require("ge/extensions/soturineChaosRandomizer/managedVehicleRegistry")

local M = {}

local ARRIVAL_DISTANCE = 1.5  -- metres from the requested position
local SETTLED_DISTANCE = 0.05 -- metres between consecutive readbacks
local SETTLED_SCANS = 2
local MAX_ATTEMPTS = 2
-- A teleport lands immediately; this bounds one attempt, not the spawn wait.
local TIMEOUT = 5

local function distanceSquared(a, b)
  local dx = (tonumber(a.x) or 0) - (tonumber(b.x) or 0)
  local dy = (tonumber(a.y) or 0) - (tonumber(b.y) or 0)
  local dz = (tonumber(a.z) or 0) - (tonumber(b.z) or 0)
  return dx * dx + dy * dy + dz * dz
end

local function fail(run, competitor, reason, placementState)
  run.failures[#run.failures + 1] = {index = competitor.index, reason = reason}
  competitor.placementState, competitor.placementReady = placementState or "placement_failed", false
  run.completed, run.failed = run.completed + 1, run.failed + 1
end

local function release(deps, handle)
  local entry = deps.registry.entries[handle]
  if entry then entry.status, entry.targetConfirmed, entry.validated = "ready", true, true end
  managedRegistry.setPending(deps.registry, handle, {writes = 0, timers = 0, callbacks = 0})
end

-- Teleports every authorized slot in the same step.
local function dispatch(run, deps)
  run.pendingBatch, run.failures, run.spawned = run.pendingBatch or {}, run.failures or {}, run.spawned or {}
  run.completed, run.failed = run.completed or 0, run.failed or 0
  for index, competitor in ipairs(run.competitors or {}) do
    local placement = run.placements[index]
    local entry, reason, placementState = deps.authorize(competitor)
    if not entry then
      fail(run, competitor, reason, placementState)
    else
      local generation = managedRegistry.beginGeneration(deps.registry, entry.handle, "placement_batch")
      managedRegistry.setPending(deps.registry, entry.handle, {writes = 1, timers = 1, callbacks = 0})
      local placed, placementReason = deps.place(entry.vehicleId, placement)
      if placed then
        managedRegistry.setPending(deps.registry, entry.handle, {writes = 0, timers = 1, callbacks = 0})
        run.pendingBatch[#run.pendingBatch + 1] = {
          handle = entry.handle, targetGeneration = generation, vehicleId = entry.vehicleId,
          competitor = competitor, placement = util.deepCopy(placement),
          deadline = deps.now + deps.timeout, settledScans = 0, attempts = 1,
        }
        competitor.raceStatus, competitor.placementState = "Loading", "placing"
      else
        release(deps, entry.handle)
        fail(run, competitor, placementReason)
      end
    end
  end
  run.batchDispatched = true
end

-- Reads every pending slot back once. Returns true when any slot finished.
local function poll(run, deps)
  local changed = false
  for _, pending in ipairs(run.pendingBatch or {}) do
    if not pending.terminal then
      local readable, positionOrReason = deps.position(pending.vehicleId)
      local arrived = readable and distanceSquared(positionOrReason, pending.placement.position)
        <= ARRIVAL_DISTANCE * ARRIVAL_DISTANCE
      if arrived then
        local settled = pending.lastPosition
          and distanceSquared(positionOrReason, pending.lastPosition) <= SETTLED_DISTANCE * SETTLED_DISTANCE
        pending.settledScans = settled and pending.settledScans + 1 or 1
        pending.lastPosition = util.deepCopy(positionOrReason)
      end
      if arrived and pending.settledScans >= SETTLED_SCANS then
        managedRegistry.setPending(deps.registry, pending.handle, {writes = 0, timers = 0, callbacks = 0})
        managedRegistry.updateState(deps.registry, pending.handle, pending.targetGeneration,
          {vehicleId = pending.vehicleId, position = pending.lastPosition, placementOnly = true})
        local ready, readyReason = managedRegistry.markReady(deps.registry, pending.handle,
          pending.targetGeneration, {busy = false, targetConfirmed = true, validated = true})
        if ready then
          run.spawned[#run.spawned + 1] = pending.handle
          pending.competitor.raceStatus = "Ready"
          pending.competitor.placementState, pending.competitor.placementReady = "placed", true
          pending.competitor.aiReady = deps.aiUsable(pending.competitor) == true
          pending.competitor.aiState = pending.competitor.aiReady and "ELIGIBLE" or "BLOCKED_NOT_DRIVABLE"
          local entry = deps.registry.entries[pending.handle]
          if entry then entry.spawnTransform = util.deepCopy(pending.placement) end
          run.completed = run.completed + 1
        else
          fail(run, pending.competitor, readyReason)
        end
        pending.terminal, changed = true, true
      elseif (not readable and positionOrReason == "vehicle_missing") or deps.now >= pending.deadline then
        -- Only this slot is retried; the rest of the batch keeps settling.
        if pending.attempts < MAX_ATTEMPTS and deps.exists(pending.vehicleId) then
          pending.attempts, pending.settledScans, pending.lastPosition = pending.attempts + 1, 0, nil
          pending.deadline = deps.place(pending.vehicleId, pending.placement) and deps.now + deps.timeout or deps.now
        else
          release(deps, pending.handle)
          pending.competitor.raceStatus = "Ready"
          fail(run, pending.competitor, readable and "placement_readback_timeout" or positionOrReason)
          pending.terminal, changed = true, true
        end
      end
    end
  end
  return changed
end

local function finished(run)
  return (run.completed or 0) >= (run.requested or 0)
end

M.TIMEOUT = TIMEOUT
M.ARRIVAL_DISTANCE = ARRIVAL_DISTANCE
M.SETTLED_DISTANCE = SETTLED_DISTANCE
M.dispatch = dispatch
M.poll = poll
M.finished = finished

return M
