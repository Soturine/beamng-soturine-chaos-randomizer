local M = {}

local function select(models, generator, recentKeys)
  if type(models) ~= "table" or #models == 0 then return nil, "no_eligible_vehicles" end
  local recent = {}
  for _, key in ipairs(recentKeys or {}) do recent[key] = true end

  local candidates = {}
  for _, model in ipairs(models) do
    if not recent[model.key] then candidates[#candidates + 1] = model end
  end
  if #candidates == 0 then candidates = models end
  return generator:choice(candidates)
end

M.select = select

return M
