local M = {}

local function restore(options)
  options = type(options) == "table" and options or {}
  local playerVehicleId = tonumber(options.playerVehicleId)
  local candidateVehicleId = tonumber(options.candidateVehicleId)
  if playerVehicleId == nil then return false, "race_player_vehicle_missing" end
  if candidateVehicleId ~= nil and candidateVehicleId == playerVehicleId then
    return false, "race_candidate_is_player"
  end
  if type(options.getCurrentVehicleId) ~= "function" or type(options.enterVehicle) ~= "function" then
    return false, "race_focus_api_missing"
  end
  local currentOk, currentVehicleId = options.getCurrentVehicleId()
  if currentOk and tonumber(currentVehicleId) == playerVehicleId then
    return true, {restored = false, playerVehicleId = playerVehicleId, candidateVehicleId = candidateVehicleId}
  end
  local entered, reason = options.enterVehicle(playerVehicleId)
  if not entered then return false, reason or "race_player_focus_restore_failed" end
  return true, {
    restored = true, playerVehicleId = playerVehicleId,
    candidateVehicleId = candidateVehicleId, stolenFocusVehicleId = tonumber(currentVehicleId),
  }
end

M.restore = restore

return M
