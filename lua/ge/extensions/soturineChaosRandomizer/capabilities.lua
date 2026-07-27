local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function capability(status, reason)
  return {status = status, available = status == "available", reason = reason}
end

local function paired(readable, writable, unavailableReason)
  if readable and writable then return capability("available") end
  if readable or writable then return capability("degraded", "Only one side of the read/write contract is available.") end
  return capability("unavailable", unavailableReason)
end

local function report(raw)
  raw = type(raw) == "table" and raw or {}
  return {
    vehicleReplaceSpawn = (raw.vehicleReplace or raw.vehicleSpawn)
      and capability(raw.vehicleReplace and raw.vehicleSpawn and "available" or "degraded",
        raw.vehicleReplace and raw.vehicleSpawn and nil or "Only replace or spawn is available in this build.")
      or capability("unavailable", "Vehicle replace/spawn APIs are unavailable."),
    partsReadWrite = paired(raw.partsRead, raw.partsWrite, "Hierarchical parts read/write is unavailable."),
    tuningReadWrite = paired(raw.tuningRead, raw.tuningWrite, "Tuning read/write is unavailable."),
    paintReadWrite = paired(raw.paintRead, raw.paintWrite, "Paint read/write is unavailable."),
    navgraph = raw.navgraph and capability("available")
      or capability("unavailable", "No reachable NavGraph API is available in this map/build."),
    aiDestination = raw.navgraph and raw.vehicleLuaQueue and capability("available")
      or capability("unavailable", "Destination AI requires NavGraph and Vehicle Lua queue support."),
    aiRoute = raw.navgraph and raw.vehicleLuaQueue and capability("available")
      or capability("unavailable", "Route AI requires NavGraph and Vehicle Lua queue support."),
    managedMultiVehicle = raw.managedMultiVehicle and capability("available")
      or capability("unavailable", "Managed multi-vehicle spawning is unavailable."),
    scriptAI = capability("unsupported", "Script AI playback has no bounded portable path-transfer contract."),
    raycastCustomPoint = raw.raycast and capability("available")
      or capability("degraded", "Custom points cannot be ground/collision checked by raycast."),
    thumbnail = raw.thumbnailCapture and capability("available")
      or capability("unavailable", "Thumbnail capture is unavailable."),
    clipboard = raw.uiEvents and capability("degraded", "Clipboard availability is confirmed by the UI runtime when used.")
      or capability("unavailable", "UI event delivery for clipboard actions is unavailable."),
    fileImportExport = (raw.dnaPackageRead or raw.dnaPackageWrite)
      and capability(raw.dnaPackageRead and raw.dnaPackageWrite and "available" or "degraded",
        raw.dnaPackageRead and raw.dnaPackageWrite and nil or "Only package import or export is available.")
      or capability("unavailable", "Vehicle DNA file import/export is unavailable."),
  }
end

local function derive(raw)
  raw = type(raw) == "table" and raw or {}
  local result = util.deepCopy(raw)
  result.randomConfig = raw.vehicleRegistry == true
    and (raw.vehicleReplace == true or raw.vehicleSpawn == true) and raw.lifecycleConfirmation == true
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
  result.dnaPackageWrite = raw.dnaPackageWrite == true
  result.dnaPackageRead = raw.dnaPackageRead == true
  result.thumbnailCapture = raw.thumbnailCapture == true
  result.thumbnailDelete = raw.thumbnailDelete == true
  result.report = report(raw)
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
M.report = report

return M
