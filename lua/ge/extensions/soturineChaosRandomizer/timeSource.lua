local M = {}

local function finiteNumber(value)
  value = tonumber(value)
  if value == nil or value ~= value or value == math.huge or value == -math.huge then return nil end
  return value
end

local function create(clock)
  clock = type(clock) == "function" and clock or os.clock
  local now = finiteNumber(clock()) or 0
  return {
    clock = clock,
    realMonotonicTime = now,
    simulationTime = 0,
    realDelta = 0,
    simulationDelta = 0,
    rawDelta = 0,
    frameCounter = 0,
    paused = false,
    pauseKnown = false,
    slowMotionRatio = 1,
    lastRealMonotonicTime = now,
    source = "clock_fallback",
  }
end

local function sample(state, dtReal, dtSim, dtRaw, paused, explicitNow)
  local clockNow = finiteNumber(explicitNow)
  if clockNow == nil then clockNow = finiteNumber(state.clock()) or state.realMonotonicTime end
  if clockNow < state.realMonotonicTime then clockNow = state.realMonotonicTime end

  local measuredRealDelta = math.max(0, clockNow - state.realMonotonicTime)
  local realDelta = finiteNumber(dtReal)
  if realDelta == nil or realDelta < 0 then realDelta = measuredRealDelta end

  local pauseKnown = type(paused) == "boolean"
  local simulationDelta = finiteNumber(dtSim)
  if simulationDelta == nil or simulationDelta < 0 then
    simulationDelta = pauseKnown and paused and 0 or realDelta
  end

  state.lastRealMonotonicTime = state.realMonotonicTime
  state.realMonotonicTime = clockNow
  state.realDelta = realDelta
  state.simulationDelta = simulationDelta
  state.rawDelta = math.max(0, finiteNumber(dtRaw) or realDelta)
  state.simulationTime = state.simulationTime + simulationDelta
  state.frameCounter = state.frameCounter + 1
  state.pauseKnown = pauseKnown
  state.paused = pauseKnown and paused or (realDelta > 0 and simulationDelta <= 0)
  state.slowMotionRatio = realDelta > 0 and math.max(0, simulationDelta / realDelta) or 0
  state.source = finiteNumber(dtReal) ~= nil and finiteNumber(dtSim) ~= nil
    and "beamng_onUpdate_deltas" or "clock_fallback"
  return state
end

local function snapshot(state)
  return {
    realMonotonicTime = state.realMonotonicTime,
    simulationTime = state.simulationTime,
    realDelta = state.realDelta,
    simulationDelta = state.simulationDelta,
    rawDelta = state.rawDelta,
    frameCounter = state.frameCounter,
    paused = state.paused,
    pauseKnown = state.pauseKnown,
    slowMotionRatio = state.slowMotionRatio,
    source = state.source,
  }
end

M.create = create
M.sample = sample
M.snapshot = snapshot

return M
