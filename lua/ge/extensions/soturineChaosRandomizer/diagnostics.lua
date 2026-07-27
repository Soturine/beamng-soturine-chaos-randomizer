local M = {}

local function sanitized(value, seen, depth)
  if type(value) == "string" then
    if value:match("%a:[/\\][Uu]sers[/\\][^/\\]+") then return "<redacted-user-path>" end
    return value
  end
  if type(value) ~= "table" then return value end
  seen, depth = seen or {}, depth or 0
  if seen[value] or depth > 16 then return "<cycle>" end
  seen[value] = true
  local result = {}
  for key, item in pairs(value) do result[key] = sanitized(item, seen, depth + 1) end
  seen[value] = nil
  return result
end

local function create(logSink)
  return {
    enabled = false,
    logSink = logSink or function() end,
    records = {},
    limit = 200,
  }
end

local function setEnabled(diagnostics, enabled)
  diagnostics.enabled = enabled == true
end

local function write(diagnostics, level, event, details, always)
  if not always and not diagnostics.enabled then return end
  local record = {
    level = level or "D",
    event = tostring(event or "event"),
    details = sanitized(details or {}),
  }
  diagnostics.records[#diagnostics.records + 1] = record
  while #diagnostics.records > diagnostics.limit do
    table.remove(diagnostics.records, 1)
  end
  diagnostics.logSink(record.level, record.event, record.details)
end

local function snapshot(diagnostics)
  return sanitized(diagnostics.records)
end

M.create = create
M.setEnabled = setEnabled
M.write = write
M.snapshot = snapshot
M.sanitized = sanitized

return M
