local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function create(version)
  return {
    schemaVersion = 1,
    modVersion = tostring(version or "unknown"),
    status = "not_required",
    records = {},
    warnings = {},
  }
end

local function record(report, kind, sourceVersion, targetVersion, status, details)
  local entry = {
    kind = tostring(kind), sourceVersion = tonumber(sourceVersion), targetVersion = tonumber(targetVersion),
    status = tostring(status), details = util.deepCopy(details or {}),
  }
  report.records[#report.records + 1] = entry
  if status == "migrated" then report.status = "migrated"
  elseif status == "failed" then report.status = "partial_failure" end
  return entry
end

local function warning(report, code, details)
  report.warnings[#report.warnings + 1] = {code = tostring(code), details = util.deepCopy(details or {})}
end

M.create = create
M.record = record
M.warning = warning

return M
