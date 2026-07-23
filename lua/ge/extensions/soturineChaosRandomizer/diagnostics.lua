local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

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
    details = util.deepCopy(details or {}),
  }
  diagnostics.records[#diagnostics.records + 1] = record
  while #diagnostics.records > diagnostics.limit do
    table.remove(diagnostics.records, 1)
  end
  diagnostics.logSink(record.level, record.event, record.details)
end

local function snapshot(diagnostics)
  return util.deepCopy(diagnostics.records)
end

M.create = create
M.setEnabled = setEnabled
M.write = write
M.snapshot = snapshot

return M
