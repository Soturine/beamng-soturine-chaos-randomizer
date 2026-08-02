local M = {}

local FLAG_NAMES = {
  "operationDirty", "progressDirty", "raceDirty", "garageDirty",
  "settingsDirty", "diagnosticsDirty", "compatibilityDirty", "performanceDirty",
}

local function freshFlags(value)
  local result = {}
  for _, name in ipairs(FLAG_NAMES) do result[name] = value == true end
  return result
end

local function create(options)
  options = type(options) == "table" and options or {}
  return {
    flags = freshFlags(true), initialPending = true, fullRequested = false,
    debounceSeconds = math.max(0, tonumber(options.debounceSeconds) or 0.05),
    nextPublishAt = 0, fullStateCount = 0, partialStateCount = 0,
    suppressedPublishes = 0, guihooksCount = 0, bytesPublished = 0,
    rateWindowStartedAt = tonumber(options.now) or 0, rateWindowHooks = 0, rateWindowBytes = 0,
  }
end

local function mark(state, name)
  if state.flags[name] == nil then return false, "ui_dirty_flag_invalid" end
  state.flags[name] = true
  return true
end

local function markMany(state, names)
  for _, name in ipairs(names or {}) do mark(state, name) end
  return true
end

local function requestFull(state)
  state.fullRequested = true
  state.flags = freshFlags(true)
  return true
end

local function due(state, now, urgent)
  if urgent == true then return true end
  return (tonumber(now) or 0) >= state.nextPublishAt
end

local function note(state, kind, bytes, now)
  bytes, now = math.max(0, math.floor(tonumber(bytes) or 0)), tonumber(now) or 0
  state.guihooksCount = state.guihooksCount + 1
  state.bytesPublished = state.bytesPublished + bytes
  state.rateWindowHooks = state.rateWindowHooks + 1
  state.rateWindowBytes = state.rateWindowBytes + bytes
  if kind == "full" then state.fullStateCount = state.fullStateCount + 1
  else state.partialStateCount = state.partialStateCount + 1 end
  state.nextPublishAt = now + state.debounceSeconds
end

local function consume(state, kind)
  if kind == "full" then
    state.initialPending, state.fullRequested, state.flags = false, false, freshFlags(false)
  elseif kind == "partial" then
    state.flags.progressDirty = false
  end
end

local function suppress(state)
  state.suppressedPublishes = state.suppressedPublishes + 1
  return false
end

local function snapshot(state, now)
  now = tonumber(now) or 0
  local elapsed = math.max(0.001, now - state.rateWindowStartedAt)
  local flags = freshFlags(false)
  for _, name in ipairs(FLAG_NAMES) do flags[name] = state.flags[name] == true end
  return {
    guihooksPerSecond = state.rateWindowHooks / elapsed,
    bytesPerSecond = state.rateWindowBytes / elapsed,
    fullStateCount = state.fullStateCount,
    partialStateCount = state.partialStateCount,
    suppressedPublishes = state.suppressedPublishes,
    guihooksCount = state.guihooksCount,
    bytesPublished = state.bytesPublished,
    flags = flags,
  }
end

M.FLAG_NAMES = FLAG_NAMES
M.create = create
M.mark = mark
M.markMany = markMany
M.requestFull = requestFull
M.due = due
M.note = note
M.consume = consume
M.suppress = suppress
M.snapshot = snapshot

return M
