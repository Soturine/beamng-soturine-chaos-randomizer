local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function create(context)
  context = type(context) == "table" and context or {}
  return {
    operationId = context.operationId,
    targetGeneration = context.targetGeneration,
    modelKey = context.modelKey,
    configIdentity = util.deepCopy(context.configIdentity),
  }
end

local function bind(state, context)
  context = type(context) == "table" and context or {}
  if state.operationId ~= nil and context.operationId ~= nil and state.operationId ~= context.operationId then
    return false, "coverage_operation_mismatch"
  end
  if state.targetGeneration ~= nil and context.targetGeneration ~= nil
    and state.targetGeneration ~= context.targetGeneration
  then
    return false, "coverage_target_generation_mismatch"
  end
  state.operationId = state.operationId or context.operationId
  state.targetGeneration = state.targetGeneration or context.targetGeneration
  state.modelKey = state.modelKey or context.modelKey
  state.configIdentity = state.configIdentity or util.deepCopy(context.configIdentity)
  return true
end

M.create = create
M.bind = bind

return M
