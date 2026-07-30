local util = require("ge/extensions/soturineChaosRandomizer/util")

local M = {}

local function store(options)
  options = type(options) == "table" and options or {}
  if type(options.read) ~= "function" or type(options.write) ~= "function"
    or type(options.path) ~= "string" or type(options.value) ~= "table"
  then return false, {code = "transaction_arguments_invalid"} end

  local previous = util.deepCopy(options.previous)
  if previous == nil then
    local readable, value = options.read(options.path)
    if not readable then return false, {code = "transaction_previous_read_failed", path = options.path} end
    if type(value) == "table" then previous = util.deepCopy(value) end
  end

  local function verifiedWrite(path, value)
    local written = options.write(path, util.deepCopy(value))
    if not written then return false, "write_failed" end
    local readable, readback = options.read(path)
    if not readable or type(readback) ~= "table" or not util.deepEqual(readback, value, 1e-10) then
      return false, "readback_failed"
    end
    return true
  end

  if previous and type(options.backupPath) == "string" then
    local backupOk, backupReason = verifiedWrite(options.backupPath, previous)
    if not backupOk then
      return false, {code = "transaction_backup_failed", cause = backupReason, path = options.backupPath}
    end
  end

  local primaryOk, primaryReason = verifiedWrite(options.path, options.value)
  if primaryOk then
    return true, {
      path = options.path, backupPath = options.backupPath,
      verified = true, previousPreserved = previous ~= nil,
    }
  end

  if previous then
    local rollbackOk, rollbackReason = verifiedWrite(options.path, previous)
    if rollbackOk then
      return false, {
        code = "transaction_rolled_back", cause = primaryReason,
        recovered = true, path = options.path,
      }
    end
    return false, {
      code = "transaction_rollback_failed", cause = primaryReason,
      rollbackCause = rollbackReason, recovered = false, path = options.path,
    }
  end
  return false, {code = "transaction_write_failed", cause = primaryReason, recovered = false, path = options.path}
end

M.store = store

return M
