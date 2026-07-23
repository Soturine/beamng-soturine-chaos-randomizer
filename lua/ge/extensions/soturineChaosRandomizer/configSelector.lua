local M = {}

local function identifier(config)
  return tostring(config.modelKey) .. "/" .. tostring(config.key)
end

local function select(configs, generator, recentIds)
  if type(configs) ~= "table" or #configs == 0 then return nil, "no_eligible_configurations" end
  local recent = {}
  for _, id in ipairs(recentIds or {}) do recent[id] = true end

  local candidates = {}
  for _, config in ipairs(configs) do
    if not recent[identifier(config)] then candidates[#candidates + 1] = config end
  end
  if #candidates == 0 then candidates = configs end
  return generator:choice(candidates)
end

M.select = select
M.identifier = identifier

return M
