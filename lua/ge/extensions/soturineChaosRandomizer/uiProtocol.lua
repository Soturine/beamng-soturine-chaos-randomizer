local M = {}

M.PROTOCOL_VERSION = 2
M.MAX_COMMAND_BYTES = 131072
M.MAX_COMMAND_ID = 128
M.MAX_SOURCE_VIEW = 32
M.MAX_ARGUMENTS = 16
M.MAX_DEPTH = 12
M.MAX_ELEMENTS = 4096

local EVENT_TYPES = {full = true, diff = true, reset = true, rejection = true}
local DOMAINS = {
  all = true, core = true, chaos = true, garage = true, race = true,
  settings = true, compatibility = true, diagnostics = true,
  performance = true, uiLayout = true,
}

local function safeIdentifier(value, maximum)
  return type(value) == "string" and #value >= 1 and #value <= maximum
    and value:match("^[A-Za-z0-9_.:-]+$") ~= nil
end

local function inspectValue(value, depth, seen, counter)
  if depth > M.MAX_DEPTH then return false, "command_depth_exceeded" end
  local kind = type(value)
  if kind == "nil" or kind == "boolean" then return true end
  if kind == "number" then
    if value ~= value or value == math.huge or value == -math.huge then
      return false, "command_number_invalid"
    end
    return true
  end
  if kind == "string" then
    if #value > M.MAX_COMMAND_BYTES then return false, "command_string_oversize" end
    return true
  end
  if kind ~= "table" then return false, "command_type_invalid" end
  if seen[value] then return false, "command_cycle_invalid" end
  seen[value] = true
  for key, child in pairs(value) do
    counter.count = counter.count + 1
    if counter.count > M.MAX_ELEMENTS then
      seen[value] = nil
      return false, "command_elements_exceeded"
    end
    local keyKind = type(key)
    if keyKind ~= "string" and keyKind ~= "number" then
      seen[value] = nil
      return false, "command_key_invalid"
    end
    local ok, reason = inspectValue(child, depth + 1, seen, counter)
    if not ok then seen[value] = nil; return false, reason end
  end
  seen[value] = nil
  return true
end

local function validateCommand(value, encodedBytes)
  if type(value) ~= "table" then return false, "command_envelope_invalid" end
  if value.protocolVersion ~= M.PROTOCOL_VERSION then return false, "protocol_version_unsupported" end
  if not safeIdentifier(value.command, 96) then return false, "command_name_invalid" end
  if not safeIdentifier(value.commandId, M.MAX_COMMAND_ID) then return false, "command_id_invalid" end
  if not safeIdentifier(value.sourceView, M.MAX_SOURCE_VIEW) then return false, "command_source_invalid" end
  if type(value.arguments) ~= "table" then return false, "command_arguments_invalid" end
  if #value.arguments > M.MAX_ARGUMENTS then return false, "command_argument_count_exceeded" end
  if encodedBytes and encodedBytes > M.MAX_COMMAND_BYTES then return false, "command_payload_oversize" end
  return inspectValue(value.arguments, 0, {}, {count = 0})
end

local function nextVersion(sequence)
  sequence.stateVersion = math.max(0, math.floor(tonumber(sequence.stateVersion) or 0)) + 1
  return sequence.stateVersion
end

local function envelope(sequence, eventType, domain, payload, dirtySections, lifecycle, timestamp)
  if not EVENT_TYPES[eventType] then return nil, "event_type_invalid" end
  if not DOMAINS[domain] then return nil, "event_domain_invalid" end
  lifecycle = type(lifecycle) == "table" and lifecycle or {}
  return {
    protocolVersion = M.PROTOCOL_VERSION,
    stateVersion = nextVersion(sequence),
    eventType = eventType,
    domain = domain,
    operationId = lifecycle.operationId,
    operationGeneration = lifecycle.operationGeneration,
    targetGeneration = lifecycle.targetGeneration,
    timestamp = tonumber(timestamp) or 0,
    payload = payload,
    dirtySections = type(dirtySections) == "table" and dirtySections or {domain},
  }
end

local function createSequence()
  return {stateVersion = 0}
end

local function rejection(commandId, code, message)
  return {
    success = false,
    terminal = true,
    protocolVersion = M.PROTOCOL_VERSION,
    commandId = tostring(commandId or "unknown"),
    code = tostring(code or "command_rejected"),
    message = tostring(message or "The UI command was rejected"),
  }
end

M.validateCommand = validateCommand
M.createSequence = createSequence
M.envelope = envelope
M.rejection = rejection
M.isDomain = function(value) return DOMAINS[value] == true end

return M
