local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local MINIMUM_FUEL_RATIO = 0.10

local function lower(value)
  return tostring(value or ""):lower()
end

local function textEvidence(value)
  return table.concat({
    lower(value and value.name), lower(value and value.title), lower(value and value.description),
    lower(value and value.category), lower(value and value.subCategory), lower(value and value.unit),
    lower(value and value.sourcePart), lower(value and value.type), lower(value and value.energyType),
  }, " ")
end

local function contains(text, patterns)
  for _, pattern in ipairs(patterns) do if text:find(pattern, 1, true) then return true, pattern end end
  return false
end

local EXCLUDED = {
  nitrous = {"nitrous", "n2o", "nitro bottle"},
  air_pressure = {"pressuretank", "pressure tank", "air tank", "pneumatic", "compressed air"},
  hydraulic = {"hydraulic", "hydraulics", "hydro reservoir", "hydraulic reservoir"},
  electric_energy = {"electricbattery", "electric battery", "battery", "electricenergy", "electric energy", "kwh"},
}

local function classifyStorage(storage)
  storage = type(storage) == "table" and storage or {}
  local storageType = lower(storage.type)
  local energyType = lower(storage.energyType)
  local evidence = textEvidence(storage)
  if storageType == "fueltank" then return "fuel", "storage_type:fueltank" end
  if storageType == "n2otank" then return "nitrous", "storage_type:n2otank" end
  if storageType == "electricbattery" then return "electric_energy", "storage_type:electricbattery" end
  if storageType == "pressuretank" then
    local hydraulic = contains(evidence, EXCLUDED.hydraulic)
    return hydraulic and "hydraulic" or "air_pressure", hydraulic and "pressure_tank_hydraulic" or "storage_type:pressuretank"
  end
  for classification, patterns in pairs(EXCLUDED) do
    local matched, token = contains(evidence, patterns)
    if matched then return classification, "storage_metadata:" .. token end
  end
  if energyType == "gasoline" or energyType == "diesel" or energyType == "kerosene"
    or util.isFinite(tonumber(storage.fuelCapacity))
  then return "fuel", "fuel_capacity_or_energy_type" end
  return "unknown_storage", "storage_metadata_unclassified"
end

local function classifyVariable(variable)
  variable = type(variable) == "table" and variable or {}
  local evidence = textEvidence(variable)
  for classification, patterns in pairs(EXCLUDED) do
    local matched, token = contains(evidence, patterns)
    if matched then return classification, {"excluded_token:" .. token} end
  end
  local reasons, score = {}, 0
  local name = lower(variable.name):gsub("^%$", "")
  if name == "fuel" or name == "fuelvolume" or name == "fuel_volume" then score = score + 6; reasons[#reasons + 1] = "canonical_name" end
  local fuelToken = contains(evidence, {"fuel volume", "fuel level", "starting fuel", "gasoline", "diesel", "petrol"})
  if fuelToken then score = score + 3; reasons[#reasons + 1] = "fuel_metadata" end
  local unit = lower(variable.unit)
  if unit == "l" or unit == "liter" or unit == "liters" or unit == "litre" or unit == "litres" then
    score = score + 1; reasons[#reasons + 1] = "volume_unit"
  end
  if score >= 4 then return "fuel", reasons end
  return "normal_tuning", reasons
end

local function storageList(storages)
  local result = {}
  for key, storage in pairs(type(storages) == "table" and storages or {}) do
    if type(storage) == "table" then
      local copy = util.deepCopy(storage)
      copy.name = copy.name or (type(key) == "string" and key or nil)
      result[#result + 1] = copy
    end
  end
  table.sort(result, function(left, right) return tostring(left.name or "") < tostring(right.name or "") end)
  return result
end

local function normalizedName(value)
  return lower(value):gsub("^%$", ""):gsub("[^%w]", "")
end

local function variableCandidates(variables)
  local result = {}
  for name, raw in pairs(type(variables) == "table" and variables or {}) do
    local variable = util.deepCopy(type(raw) == "table" and raw or {})
    variable.name = variable.name or name
    variable.classification, variable.classificationEvidence = classifyVariable(variable)
    result[#result + 1] = variable
  end
  table.sort(result, function(left, right) return tostring(left.name) < tostring(right.name) end)
  return result
end

local function resolveVariable(storage, candidates)
  local reference = type(storage.startingFuelCapacity) == "string" and storage.startingFuelCapacity
    or type(storage.startingCapacity) == "string" and storage.startingCapacity or nil
  local normalizedReference = normalizedName(reference)
  local storageName = normalizedName(storage.name)
  local storageSource = normalizedName(storage.sourcePart or storage.partOrigin)
  local capacity = tonumber(storage.fuelCapacity or storage.capacity)
  local best, bestScore, bestEvidence
  for _, variable in ipairs(candidates) do
    if variable.classification == "fuel" or variable.classification == "normal_tuning" then
      local score, evidence = 0, {}
      local variableName = normalizedName(variable.name)
      if normalizedReference ~= "" and variableName == normalizedReference then score = score + 100; evidence[#evidence + 1] = "storage_reference" end
      local source = normalizedName(variable.sourcePart)
      if storageSource ~= "" and source == storageSource then score = score + 20; evidence[#evidence + 1] = "source_part" end
      if storageName ~= "" and (variableName:find(storageName, 1, true) or storageName:find(variableName, 1, true)) then
        score = score + 8; evidence[#evidence + 1] = "storage_name"
      end
      local maximum = tonumber(variable.max)
      if util.isFinite(capacity) and capacity > 0 and util.isFinite(maximum)
        and math.abs(maximum - capacity) <= math.max(0.01, capacity * 0.01)
      then score = score + 6; evidence[#evidence + 1] = "capacity_match" end
      if variableName == "fuel" or variableName == "fuelvolume" then score = score + 4; evidence[#evidence + 1] = "canonical_variable" end
      if best == nil or score > bestScore then best, bestScore, bestEvidence = variable, score, evidence end
    end
  end
  local threshold = best and best.classification == "fuel" and 4 or 10
  if best and bestScore >= threshold then return best, bestEvidence, bestScore end
  return nil, {}, bestScore or 0
end

local function analyze(snapshot, ratio)
  snapshot = type(snapshot) == "table" and snapshot or {}
  ratio = util.clamp(tonumber(ratio) or MINIMUM_FUEL_RATIO, MINIMUM_FUEL_RATIO, 1)
  local candidates = variableCandidates(snapshot.variables)
  local report = {ratio = ratio, storages = {}, fuelStorageCount = 0, unresolved = 0, belowFloor = 0}
  local requiredByVariable = {}
  for _, storage in ipairs(storageList(snapshot.energyStorages)) do
    local classification, storageEvidence = classifyStorage(storage)
    local capacity = tonumber(storage.fuelCapacity or (classification == "fuel" and storage.capacity or nil))
    local entry = {
      name = storage.name, type = storage.type, energyType = storage.energyType,
      classification = classification, classificationEvidence = storageEvidence,
      capacity = capacity, status = classification == "fuel" and "pending" or "excluded_non_fuel",
    }
    if classification == "fuel" then
      report.fuelStorageCount = report.fuelStorageCount + 1
      if not util.isFinite(capacity) or capacity <= 0 then
        entry.status = "invalid_capacity"
        report.unresolved = report.unresolved + 1
      else
        entry.minimum = capacity * ratio
        local variable, evidence, score = resolveVariable(storage, candidates)
        entry.variable = variable and variable.name or nil
        entry.correlationEvidence = evidence
        entry.correlationScore = score
        local current = variable and tonumber(snapshot.values and snapshot.values[variable.name])
          or tonumber(storage.startingFuelCapacity or storage.startingCapacity)
        entry.current = current
        if not variable then
          entry.status = util.isFinite(current) and current + 1e-9 >= entry.minimum
            and "confirmed_static" or "variable_unresolved"
          if entry.status == "variable_unresolved" then report.unresolved = report.unresolved + 1 end
        elseif not util.isFinite(current) then
          entry.status = "readback_unavailable"
          report.unresolved = report.unresolved + 1
        elseif current + 1e-9 < entry.minimum then
          entry.status = "below_floor"
          report.belowFloor = report.belowFloor + 1
          local required = requiredByVariable[variable.name]
          requiredByVariable[variable.name] = math.max(required or -math.huge, entry.minimum)
        else
          entry.status = "confirmed"
        end
      end
    end
    report.storages[#report.storages + 1] = entry
  end
  report.notApplicable = report.fuelStorageCount == 0
  report.compliant = report.belowFloor == 0 and report.unresolved == 0
  return report, requiredByVariable
end

local function plan(snapshot, ratio)
  local report, requiredByVariable = analyze(snapshot, ratio)
  local values = util.deepCopy(type(snapshot) == "table" and snapshot.values or {})
  local changes = {}
  for _, name in ipairs(util.sortedKeys(requiredByVariable)) do
    local before = tonumber(values[name])
    local requested = requiredByVariable[name]
    if not util.isFinite(before) or before < requested then
      values[name] = requested
      changes[#changes + 1] = {name = name, before = before, requested = requested, reason = "minimum_combustion_fuel"}
    end
  end
  report.correctionCount = #changes
  return {values = values, changes = changes, report = report}
end

M.MINIMUM_FUEL_RATIO = MINIMUM_FUEL_RATIO
M.classifyStorage = classifyStorage
M.classifyVariable = classifyVariable
M.analyze = analyze
M.plan = plan

return M
