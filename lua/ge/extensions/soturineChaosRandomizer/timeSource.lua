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
    pauseTransitions = 0,
    lastPauseChangedAt = nil,
    pausedRealDuration = 0,
    recentSamples = {},
    lastRealMonotonicTime = now,
    source = "clock_fallback",
    externalClockStalls = 0,
    clockStalledThisFrame = false,
    clockDiscontinuityThisFrame = false,
    externalClockDelta = 0,
  }
end

local function sample(state, dtReal, dtSim, dtRaw, paused, explicitNow)
  local previousNow = finiteNumber(state.realMonotonicTime) or 0
  local externalNow = finiteNumber(explicitNow)
  if externalNow == nil then externalNow = finiteNumber(state.clock()) end
  if externalNow == nil or externalNow < previousNow then externalNow = previousNow end

  local measuredRealDelta = math.max(0, externalNow - previousNow)
  local realDelta = finiteNumber(dtReal)
  if realDelta == nil or realDelta < 0 then realDelta = measuredRealDelta end

  -- BeamNG supplies dtReal for every GE onUpdate call, including while the
  -- simulation is paused. Some Windows builds expose an os.clockhp/os.clock
  -- value that can remain unchanged across many graphical frames. Lifecycle
  -- polling must therefore advance from dtReal as well as from the external
  -- clock. Otherwise 50 ms poll intervals never become due and replacement or
  -- part reload waits remain at 22/57 percent until pause changes the clock.
  local deltaAdvancedNow = previousNow + math.max(0, realDelta or 0)
  local clockAdvanced = externalNow > previousNow
  local monotonicNow = math.max(previousNow, externalNow, deltaAdvancedNow)
  if not clockAdvanced and realDelta and realDelta > 0 then
    state.externalClockStalls = (state.externalClockStalls or 0) + 1
  end
  state.externalClockDelta = measuredRealDelta
  state.clockStalledThisFrame = not clockAdvanced and realDelta and realDelta > 0 or false
  state.clockDiscontinuityThisFrame = measuredRealDelta
    > math.max(0.1, math.max(0, realDelta or 0) * 4)

  local pauseKnown = type(paused) == "boolean"
  local simulationDelta = finiteNumber(dtSim)
  if simulationDelta == nil or simulationDelta < 0 then
    simulationDelta = pauseKnown and paused and 0 or realDelta
  end

  local wasPaused = state.paused
  state.lastRealMonotonicTime = previousNow
  state.realMonotonicTime = monotonicNow
  state.realDelta = realDelta
  state.simulationDelta = simulationDelta
  state.rawDelta = math.max(0, finiteNumber(dtRaw) or realDelta)
  state.simulationTime = state.simulationTime + simulationDelta
  state.frameCounter = state.frameCounter + 1
  state.pauseKnown = pauseKnown
  state.paused = pauseKnown and paused or (realDelta > 0 and simulationDelta <= 0)
  if state.paused ~= wasPaused then
    state.pauseTransitions = state.pauseTransitions + 1
    state.lastPauseChangedAt = monotonicNow
  end
  if state.paused then state.pausedRealDuration = state.pausedRealDuration + realDelta end
  state.slowMotionRatio = realDelta > 0 and math.max(0, simulationDelta / realDelta) or 0
  state.source = finiteNumber(dtReal) ~= nil
    and (clockAdvanced and "beamng_dtReal_plus_clock" or "beamng_dtReal_monotonic")
    or "clock_fallback"
  state.recentSamples[#state.recentSamples + 1] = {
    wall = state.realMonotonicTime,
    externalWall = externalNow,
    dtReal = state.realDelta,
    dtSim = state.simulationDelta,
    dtRaw = state.rawDelta,
    frame = state.frameCounter,
    paused = state.paused,
  }
  while #state.recentSamples > 12 do table.remove(state.recentSamples, 1) end
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
    pauseTransitions = state.pauseTransitions,
    lastPauseChangedAt = state.lastPauseChangedAt,
    pausedRealDuration = state.pausedRealDuration,
    externalClockStalls = state.externalClockStalls or 0,
    clockStalledThisFrame = state.clockStalledThisFrame == true,
    clockDiscontinuityThisFrame = state.clockDiscontinuityThisFrame == true,
    externalClockDelta = state.externalClockDelta or 0,
    recentSamples = state.recentSamples,
  }
end

M.create = create
M.sample = sample
M.snapshot = snapshot

return M
