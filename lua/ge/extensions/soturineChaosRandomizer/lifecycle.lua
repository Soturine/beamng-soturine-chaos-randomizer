local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local WAIT_REASONS = {
  spawn = "waitingForVehicleReplace",
  parts = "waitingForPartsReload",
  tuning = "waitingForTuningReload",
  rollback = "waitingForRollbackReplace",
  undo = "waitingForUndoReplace",
}

local function createExpectation(options)
  options = type(options) == "table" and options or {}
  return {
    token = options.token,
    phase = options.phase,
    reason = WAIT_REASONS[options.phase] or options.reason,
    eventType = options.eventType or "onVehicleSpawned",
    vehicleId = options.vehicleId,
    modelKey = options.modelKey,
    configKey = options.configKey,
    parts = util.deepCopy(options.parts or {}),
    tuning = util.deepCopy(options.tuning or {}),
    paints = options.paints and util.deepCopy(options.paints) or nil,
    startedAt = options.startedAt,
  }
end

local function matches(expectation, event)
  if type(expectation) ~= "table" or type(event) ~= "table" then return false, "missing_expectation" end
  if event.token and expectation.token ~= event.token then return false, "stale_operation_token" end
  if expectation.eventType ~= event.eventType then return false, "unexpected_event_type" end
  if expectation.vehicleId and event.vehicleId ~= expectation.vehicleId then return false, "wrong_vehicle_event" end
  return true
end

local function configKey(value)
  if type(value) ~= "string" then return nil end
  local normalized = value:gsub("\\", "/"):gsub("^/", "")
  local name = normalized:match("([^/]+)%.pc$") or normalized:match("([^/]+)$")
  return name
end

local function verify(expectation, state)
  state = type(state) == "table" and state or {}
  if expectation.modelKey and state.modelKey ~= expectation.modelKey then
    return false, "model_mismatch"
  end
  if expectation.configKey then
    local actualKey = configKey(state.configKey)
    local expectedKey = configKey(expectation.configKey)
    if not actualKey or actualKey ~= expectedKey then return false, "config_mismatch" end
  end
  for path, candidate in pairs(expectation.parts or {}) do
    if not state.parts or state.parts[path] ~= candidate then
      return false, "parts_state_mismatch:" .. tostring(path)
    end
  end
  for name, value in pairs(expectation.tuning or {}) do
    local actual = state.tuning and tonumber(state.tuning[name])
    if not actual or math.abs(actual - value) > 1e-8 then
      return false, "tuning_state_mismatch:" .. tostring(name)
    end
  end
  if expectation.paints and not util.deepEqual(state.paints or {}, expectation.paints, 1e-8) then
    return false, "paint_state_mismatch"
  end
  return true
end

M.WAIT_REASONS = WAIT_REASONS
M.createExpectation = createExpectation
M.matches = matches
M.verify = verify
M.configKey = configKey

return M
