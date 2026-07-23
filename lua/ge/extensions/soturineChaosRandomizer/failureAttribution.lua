local M = {}

local function targetForPhase(phase, baseConfirmed)
  if phase == "spawn" and not baseConfirmed then return "config" end
  if phase == "parts" then return "part" end
  if phase == "tuning" then return "tuning" end
  return nil
end

M.targetForPhase = targetForPhase

return M
