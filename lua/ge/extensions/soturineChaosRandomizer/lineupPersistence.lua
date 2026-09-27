local util = require("ge/extensions/soturineChaosRandomizer/util")
local schema = require("ge/extensions/soturineChaosRandomizer/lineupSchema")

local M = {}

-- Saved lineup library: bounded, schema-validated, newest first.
local function create(limit)
  return {kind = "soturineChaosLineupLibrary", lineupSchemaVersion = schema.SCHEMA_VERSION, limit = math.max(1, math.min(50, tonumber(limit) or 20)), entries = {}, revision = 0}
end

local function add(library, lineup)
  local valid, reason = schema.validate(lineup, {allowOne = true})
  if not valid then return false, reason end
  local copy = util.deepCopy(lineup)
  copy.active, copy.nextIndex = nil, nil
  for index = #library.entries, 1, -1 do if library.entries[index].id == copy.id then table.remove(library.entries, index) end end
  table.insert(library.entries, 1, copy)
  while #library.entries > library.limit do table.remove(library.entries) end
  library.revision = library.revision + 1
  return true, copy
end

local function load(value, limit)
  if type(value) ~= "table" or value.kind ~= "soturineChaosLineupLibrary" or type(value.entries) ~= "table" then return create(limit), "empty" end
  local library = create(limit or value.limit)
  for _, lineup in ipairs(value.entries) do if schema.validate(lineup, {allowOne = true}) then library.entries[#library.entries + 1] = util.deepCopy(lineup) end end
  library.revision = math.max(0, math.floor(tonumber(value.revision) or 0))
  return library, "loaded"
end

local function classify(reason, stage)
  local cause = tostring(type(reason) == "table" and (reason.code or reason.message) or reason or "lineup_storage_unknown")
  local normalized = cause:lower()
  local category = "storage"
  if stage == "schema" or normalized:find("schema", 1, true) or normalized:find("valid", 1, true) then
    category = "schema_validation"
  elseif normalized:find("dna", 1, true) then
    category = "dna_reference"
  elseif stage == "serialization" or normalized:find("serial", 1, true)
    or normalized:find("json", 1, true) or normalized:find("encode", 1, true)
  then
    category = "serialization"
  elseif normalized:find("atomic", 1, true) or normalized:find("rename", 1, true)
    or normalized:find("backup", 1, true) or normalized:find("replace", 1, true)
  then
    category = "atomic_commit"
  elseif stage == "write" or normalized:find("write", 1, true)
    or normalized:find("save", 1, true) or normalized:find("io", 1, true)
  then
    category = "write"
  end
  return {
    code = "lineup_storage_" .. category,
    category = category,
    cause = cause,
    stage = tostring(stage or "storage"),
    recoverable = category ~= "schema_validation" and category ~= "dna_reference",
  }
end

local function recordFailure(lineup, reason, stage, now)
  local failure = classify(reason, stage)
  lineup.persistence = lineup.persistence or {}
  local persistence = lineup.persistence
  persistence.status = "warning"
  persistence.errorCode = failure.code
  persistence.errorCategory = failure.category
  persistence.lastError = failure.code
  persistence.lastCause = failure.cause
  persistence.lastStage = failure.stage
  persistence.recoverable = failure.recoverable
  persistence.retryAction = failure.recoverable and "retryLineupPersistence" or nil
  persistence.retryCount = (persistence.retryCount or 0) + 1
  persistence.nextRetryAt = failure.recoverable and (tonumber(now) or 0)
    + math.min(30, math.max(2, persistence.retryCount * 2)) or nil
  return failure
end

local function recordSuccess(lineup, now)
  lineup.persistence = lineup.persistence or {}
  local persistence = lineup.persistence
  persistence.status = "saved"
  persistence.errorCode = nil
  persistence.errorCategory = nil
  persistence.lastError = nil
  persistence.lastCause = nil
  persistence.lastStage = nil
  persistence.recoverable = false
  persistence.retryAction = nil
  persistence.nextRetryAt = nil
  persistence.lastSavedAt = tonumber(now) or 0
  return persistence
end

-- Adds the lineup to a copy of the library; the caller swaps it in only after
-- the copy is written, so a failed write never corrupts the in-memory library.
local function checkpoint(library, lineup)
  if type(library) ~= "table" or type(lineup) ~= "table" then
    return false, "lineup_persistence_contract_invalid", library
  end
  local candidateLibrary = util.deepCopy(library)
  local added, result = add(candidateLibrary, lineup)
  if not added then return false, result, library end
  return true, result, candidateLibrary
end

M.create = create
M.add = add
M.load = load
M.checkpoint = checkpoint
M.classify = classify
M.recordFailure = recordFailure
M.recordSuccess = recordSuccess

return M
