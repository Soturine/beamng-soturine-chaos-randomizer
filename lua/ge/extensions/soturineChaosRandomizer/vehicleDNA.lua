local util = require("ge/extensions/soturineChaosRandomizer/util")
local schema = require("ge/extensions/soturineChaosRandomizer/vehicleDNASchema")
local normalizer = require("ge/extensions/soturineChaosRandomizer/vehicleDNANormalizer")
local fingerprint = require("ge/extensions/soturineChaosRandomizer/vehicleDNAFingerprint")
local configVerification = require("ge/extensions/soturineChaosRandomizer/configVerification")

local M = {}

local function safeName(value, fallback)
  local name = type(value) == "string" and value:gsub("[%z\1-\31]", " "):gsub("^%s+", ""):gsub("%s+$", "") or ""
  if name == "" then name = fallback or "Vehicle DNA" end
  return string.sub(name, 1, schema.MAX_NAME_LENGTH)
end

local function create(options)
  options = type(options) == "table" and options or {}
  local capture = type(options.capture) == "table" and options.capture or {}
  local snapshot = type(options.snapshot) == "table" and options.snapshot or {}
  local result = type(options.result) == "table" and options.result or {}
  local settings = normalizer.normalizeSettings(options.settings)
  local slots = normalizer.normalizeSlots(options.scan)
  local tuning = normalizer.normalizeTuning(snapshot.variables, capture.tuning or snapshot.currentTuning)
  local paints = normalizer.normalizePaints(capture.paints or snapshot.paints)
  local seed = tostring(options.seed or result.seed or "")
  local base = type(options.base) == "table" and options.base or {}
  local basePayload = {
    modelKey = tostring(base.modelKey or capture.modelKey or ""),
    configKey = base.configKey,
    configName = base.configName,
    configPath = configVerification.normalizePath(base.configPath or capture.selectedConfiguration),
    registryIdentity = base.registryIdentity == true,
    sourceKind = base.sourceKind or "unknown",
    sourceLabel = base.sourceLabel,
    sourceStrategy = base.sourceStrategy,
    modID = base.modID,
    identityStrategy = base.identityStrategy,
    stateSignature = base.stateSignature,
  }
  local startingFingerprint = fingerprint.fingerprint(options.startingState or {})
  local finalPayload = {
    modelKey = tostring(capture.modelKey or ""),
    configIdentity = configVerification.normalizePath(capture.selectedConfiguration),
    slots = slots,
    tuning = tuning,
    paints = paints,
  }
  local finalFingerprint = fingerprint.fingerprint(finalPayload)
  local settingsFingerprint = fingerprint.fingerprint(settings)
  local environment = {
    beamNGVersion = tostring(options.gameVersion or "unknown"),
    extensionVersion = tostring(options.extensionVersion or "unknown"),
    targetBeamNG = tostring(options.targetBeamNG or "0.38.6.0.19963"),
    schemaVersion = schema.SCHEMA_VERSION,
    generatorVersion = schema.GENERATOR_VERSION,
  }
  local environmentFingerprint = fingerprint.fingerprint(environment)
  local baseFingerprint = fingerprint.fingerprint(basePayload)
  local dependencyPayload = type(options.dependencies) == "table" and util.deepCopy(options.dependencies) or {}
  local dependencyFingerprint = fingerprint.fingerprint(dependencyPayload)
  local idSource = table.concat({seed, tostring(capture.modelKey), tostring(finalFingerprint), tostring(options.timestamp or os.time())}, ":")
  local idFingerprint = fingerprint.digest(idSource):gsub("^scrfp1%-", "")

  local entry = {
    format = "SoturineVehicleDNA",
    kind = "soturineVehicleDNA",
    schemaVersion = schema.SCHEMA_VERSION,
    generatorVersion = schema.GENERATOR_VERSION,
    id = "dna-" .. idFingerprint,
    name = safeName(options.name, tostring(capture.modelKey or "Vehicle") .. " DNA"),
    description = "",
    createdAt = math.floor(tonumber(options.timestamp) or os.time()),
    updatedAt = math.floor(tonumber(options.timestamp) or os.time()),
    favorite = options.favorite == true,
    pinned = options.pinned == true,
    rating = options.rating,
    notes = "",
    collection = "",
    sortOrder = 0,
    tags = util.deepCopy(options.tags or {}),
    environment = environment,
    generation = {
      generatorVersion = schema.GENERATOR_VERSION,
      operation = tostring(options.operation or capture.operationType or "unknown"),
      seed = seed,
      settings = settings,
      selectionContext = util.deepCopy(options.selectionContext or {}),
      recentPolicy = tostring(options.recentPolicy or "manual_seed_ignores_recent"),
      blacklistPolicy = tostring(options.blacklistPolicy or "session_state_recorded_not_replayed"),
      suspectPolicy = tostring(options.suspectPolicy or "session_state_recorded_not_replayed"),
      startingStateFingerprint = startingFingerprint,
    },
    operation = tostring(options.operation or capture.operationType or "unknown"),
    seed = {display = seed, legacy = not seed:match("^SCR[45]%-")},
    base = basePayload,
    final = finalPayload,
    safety = util.deepCopy(options.safety or result.safety or {}),
    warnings = util.deepCopy(options.warnings or result.warnings or {}),
    metrics = util.deepCopy(options.metrics or {}),
    dependencies = dependencyPayload,
    fingerprints = {
      settings = settingsFingerprint,
      environment = environmentFingerprint,
      base = baseFingerprint,
      final = finalFingerprint,
      dependencies = dependencyFingerprint,
    },
    validation = {
      status = "captured",
      source = "fresh_post_operation_readback",
      interactive = false,
    },
    lineage = util.deepCopy(options.lineage or {}),
    lockProfile = options.lockProfile and util.deepCopy(options.lockProfile) or nil,
    thumbnail = options.thumbnail and util.deepCopy(options.thumbnail) or nil,
  }
  local valid, reason = schema.validateEntry(entry)
  if not valid then return nil, reason end
  return entry
end

M.create = create
M.safeName = safeName

return M
