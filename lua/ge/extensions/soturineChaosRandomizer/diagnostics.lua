local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function sanitized(value, seen, depth)
  if type(value) == "string" then
    if value:match("%a:[/\\][Uu]sers[/\\][^/\\]+") then return "<redacted-user-path>" end
    if #value > 4096 then return value:sub(1, 4096) .. "<truncated>" end
    return value
  end
  if type(value) ~= "table" then return value end
  seen, depth = seen or {}, depth or 0
  if seen[value] or depth > 16 then return "<cycle>" end
  seen[value] = true
  local result, count = {}, 0
  for key, item in pairs(value) do
    count = count + 1
    if count > 512 then result.truncated = true; break end
    result[sanitized(key, seen, depth + 1)] = sanitized(item, seen, depth + 1)
  end
  seen[value] = nil
  return result
end

local function canonical(value, depth)
  depth = depth or 0
  if depth > 8 then return "..." end
  if type(value) ~= "table" then return tostring(value) end
  local parts = {}
  for _, key in ipairs(util.sortedKeys(value)) do
    parts[#parts + 1] = tostring(key) .. "=" .. canonical(value[key], depth + 1)
  end
  return "{" .. table.concat(parts, ",") .. "}"
end

local function create(logSink, options)
  options = type(options) == "table" and options or {}
  return {
    enabled = false,
    logSink = logSink or function() end,
    clock = type(options.clock) == "function" and options.clock or os.clock,
    records = {}, byFingerprint = {},
    limit = math.max(16, math.min(1000, math.floor(tonumber(options.limit) or 200))),
    rateLimitSeconds = util.clamp(tonumber(options.rateLimitSeconds) or 2, 0, 60),
    totalWrites = 0, deduplicated = 0, emitted = 0,
  }
end

local function setEnabled(diagnostics, enabled)
  diagnostics.enabled = enabled == true
end

local function removeAt(diagnostics, index)
  local old = diagnostics.records[index]
  if old then diagnostics.byFingerprint[old.fingerprint] = nil end
  table.remove(diagnostics.records, index)
end

local function makeRoom(diagnostics, incomingLevel)
  if #diagnostics.records < diagnostics.limit then return true end
  local removable = nil
  for index, record in ipairs(diagnostics.records) do
    if record.severity ~= "E" then removable = index; break end
  end
  -- Reserve a full critical-only buffer from lower-severity churn. A newer
  -- critical event may replace the oldest critical record to remain bounded.
  if not removable and incomingLevel ~= "E" then return false end
  removable = removable or 1
  removeAt(diagnostics, removable)
  return true
end

local function write(diagnostics, level, event, details, always)
  if not always and not diagnostics.enabled then return false end
  level, event = tostring(level or "D"), tostring(event or "event")
  local safeDetails = sanitized(details or {})
  local fingerprint = level .. ":" .. event .. ":" .. canonical(safeDetails)
  local now = diagnostics.clock()
  diagnostics.totalWrites = diagnostics.totalWrites + 1
  local record = diagnostics.byFingerprint[fingerprint]
  if record then
    record.lastAt, record.repetitions = now, record.repetitions + 1
    diagnostics.deduplicated = diagnostics.deduplicated + 1
  else
    if not makeRoom(diagnostics, level) then return false, "diagnostic_capacity_reserved", false end
    record = {
      level = level, severity = level, event = event, details = safeDetails,
      fingerprint = fingerprint, firstAt = now, lastAt = now, repetitions = 1,
      lastEmittedAt = nil,
    }
    diagnostics.records[#diagnostics.records + 1] = record
    diagnostics.byFingerprint[fingerprint] = record
  end
  local emit = record.lastEmittedAt == nil or level == "E"
    or now - record.lastEmittedAt >= diagnostics.rateLimitSeconds
  if emit then
    record.lastEmittedAt = now
    diagnostics.emitted = diagnostics.emitted + 1
    diagnostics.logSink(record.level, record.event, record.details)
  end
  return true, record, emit
end

local function snapshot(diagnostics, options)
  options = type(options) == "table" and options or {}
  local result = {}
  local start = math.max(1, #diagnostics.records - math.max(1, math.floor(tonumber(options.limit) or diagnostics.limit)) + 1)
  for index = start, #diagnostics.records do
    local record = diagnostics.records[index]
    local item = {
      level = record.level, severity = record.severity, event = record.event,
      fingerprint = record.fingerprint, firstAt = record.firstAt, lastAt = record.lastAt,
      repetitions = record.repetitions,
    }
    if options.compact ~= true then item.details = sanitized(record.details) end
    result[#result + 1] = item
  end
  return result
end

local function summary(diagnostics)
  local severity = {D = 0, I = 0, W = 0, E = 0}
  for _, record in ipairs(diagnostics.records) do
    severity[record.level] = (severity[record.level] or 0) + 1
  end
  return {
    unique = #diagnostics.records, totalWrites = diagnostics.totalWrites,
    deduplicated = diagnostics.deduplicated, emitted = diagnostics.emitted,
    severity = severity, limit = diagnostics.limit,
  }
end

M.create = create
M.setEnabled = setEnabled
M.write = write
M.snapshot = snapshot
M.export = snapshot
M.summary = summary
M.sanitized = sanitized

return M
