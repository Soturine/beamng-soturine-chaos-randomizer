local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function derive(raw)
  raw = type(raw) == "table" and raw or {}
  local result = util.deepCopy(raw)
  result.randomConfig = raw.vehicleRegistry == true
    and raw.vehicleReplace == true and raw.lifecycleConfirmation == true
  result.scrambleParts = raw.partsRead == true
    and raw.partsWrite == true and raw.lifecycleConfirmation == true
  result.scrambleTuning = raw.tuningRead == true
    and raw.tuningWrite == true and raw.lifecycleConfirmation == true
  result.scramblePaint = raw.paintRead == true and raw.paintWrite == true
  result.scramble = result.scrambleParts
  result.fullRandom = result.randomConfig and result.scrambleParts
  result.undo = raw.vehicleReplace == true and raw.lifecycleConfirmation == true
  result.developerStress = result.randomConfig or result.scramble
  result.dnaRead = raw.dnaRead == true
  result.dnaWrite = raw.dnaWrite == true
  result.dnaList = result.dnaRead
  result.dnaDelete = result.dnaWrite
  result.dnaImportText = result.dnaWrite
  result.dnaExportFile = raw.dnaExportFile == true
  result.dnaBackup = raw.dnaBackup == true
  result.warnings = {}
  if result.scrambleParts and not result.scrambleTuning then
    result.warnings[#result.warnings + 1] = "Tuning writes are unavailable and will be skipped."
  end
  if result.scrambleParts and not result.scramblePaint then
    result.warnings[#result.warnings + 1] = "Paint writes are unavailable and will be skipped."
  end
  if not raw.settingsPersistence and not raw.settingsWrite then
    result.warnings[#result.warnings + 1] = "Settings persistence is unavailable."
  end
  if not result.dnaWrite then
    result.warnings[#result.warnings + 1] = "Vehicle DNA persistence is unavailable; capture and restore controls are disabled."
  elseif not result.dnaExportFile then
    result.warnings[#result.warnings + 1] = "Vehicle DNA file export is unavailable; Copy DNA JSON remains available."
  end
  return result
end

M.derive = derive

return M
