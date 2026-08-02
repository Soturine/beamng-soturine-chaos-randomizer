local uiProtocol = require("ge/extensions/soturineChaosRandomizer/uiProtocol")

local M = {}

local function create(handlers, options)
  options = type(options) == "table" and options or {}
  return {
    handlers = type(handlers) == "table" and handlers or {},
    encodeJSON = options.encodeJSON,
    completed = {},
    completedOrder = {},
    completedLimit = math.max(16, math.floor(tonumber(options.completedLimit) or 128)),
  }
end

local function remember(router, commandId, result)
  if router.completed[commandId] == nil then
    router.completedOrder[#router.completedOrder + 1] = commandId
  end
  router.completed[commandId] = result
  while #router.completedOrder > router.completedLimit do
    local oldest = table.remove(router.completedOrder, 1)
    router.completed[oldest] = nil
  end
end

local function encodedBytes(router, envelope)
  if type(router.encodeJSON) ~= "function" then return nil end
  local ok, value = router.encodeJSON(envelope, false)
  return ok and type(value) == "string" and #value or nil
end

local function dispatch(router, envelope)
  local commandId = type(envelope) == "table" and envelope.commandId or "unknown"
  local ok, reason = uiProtocol.validateCommand(envelope, encodedBytes(router, envelope))
  if not ok then return uiProtocol.rejection(commandId, reason) end

  local prior = router.completed[envelope.commandId]
  if prior then return prior end

  local handler = router.handlers[envelope.command]
  if type(handler) ~= "function" then
    local rejected = uiProtocol.rejection(envelope.commandId, "command_not_allowed")
    remember(router, envelope.commandId, rejected)
    return rejected
  end

  local callOk, value, secondary = pcall(handler, unpack(envelope.arguments))
  local result
  if not callOk then
    result = uiProtocol.rejection(envelope.commandId, "command_handler_failed", value)
  elseif value == false then
    result = uiProtocol.rejection(envelope.commandId, type(secondary) == "string" and secondary or "command_failed")
  else
    result = {
      success = true,
      terminal = true,
      protocolVersion = uiProtocol.PROTOCOL_VERSION,
      commandId = envelope.commandId,
      code = "command_completed",
      result = value,
    }
  end
  remember(router, envelope.commandId, result)
  return result
end

M.create = create
M.dispatch = dispatch

return M
