-- Deterministic pick that avoids recently used items and falls back to the
-- whole pool when every item was used recently. Vehicle models and
-- configurations follow the same rule with their own identity.
local M = {}

local function identifier(config)
  return tostring(config.modelKey) .. "/" .. tostring(config.key)
end

local function modelKey(model)
  return model.key
end

local function pickAvoidingRecent(items, generator, recentIds, identify, emptyReason)
  if type(items) ~= "table" or #items == 0 then return nil, emptyReason end
  local recent = {}
  for _, id in ipairs(recentIds or {}) do recent[id] = true end

  local candidates = {}
  for _, item in ipairs(items) do
    if not recent[identify(item)] then candidates[#candidates + 1] = item end
  end
  if #candidates == 0 then candidates = items end
  return generator:choice(candidates)
end

local function select(configs, generator, recentIds)
  return pickAvoidingRecent(configs, generator, recentIds, identifier, "no_eligible_configurations")
end

local function selectModel(models, generator, recentKeys)
  return pickAvoidingRecent(models, generator, recentKeys, modelKey, "no_eligible_vehicles")
end

M.select = select
M.selectModel = selectModel
M.identifier = identifier

return M
