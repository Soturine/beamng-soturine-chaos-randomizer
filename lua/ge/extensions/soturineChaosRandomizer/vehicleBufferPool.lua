local M = {}

local DEFAULT_NAMES = {
  "vehicleIdsBuffer", "occupiedPositionsBuffer", "candidateIdsBuffer",
  "metricsBuffer", "sortedKeyBuffer", "uiDiffBuffer", "diagnosticBatchBuffer",
}

local function clear(values)
  if type(values) ~= "table" then return false end
  for key in pairs(values) do values[key] = nil end
  return true
end

local function create(names)
  local state = {buffers = {}, reuses = 0, acquisitions = 0}
  for _, name in ipairs(type(names) == "table" and names or DEFAULT_NAMES) do
    state.buffers[name] = {values = {}, borrowed = false, generation = 0}
  end
  return state
end

local function acquire(state, name)
  local entry = type(state) == "table" and state.buffers and state.buffers[name]
  if not entry then return nil, "buffer_unknown" end
  if entry.borrowed then return nil, "buffer_already_borrowed" end
  clear(entry.values)
  entry.borrowed = true
  entry.generation = entry.generation + 1
  state.acquisitions = state.acquisitions + 1
  if entry.generation > 1 then state.reuses = state.reuses + 1 end
  return entry.values, entry.generation
end

local function release(state, name, generation)
  local entry = type(state) == "table" and state.buffers and state.buffers[name]
  if not entry or not entry.borrowed then return false, "buffer_not_borrowed" end
  if generation ~= nil and generation ~= entry.generation then return false, "stale_buffer_generation" end
  clear(entry.values)
  entry.borrowed = false
  return true
end

local function copyOut(values)
  local result = {}
  for index = 1, #(values or {}) do result[index] = values[index] end
  return result
end

local function snapshot(state)
  local borrowed = 0
  for _, entry in pairs(state.buffers or {}) do if entry.borrowed then borrowed = borrowed + 1 end end
  return {acquisitions = state.acquisitions or 0, reuses = state.reuses or 0, borrowed = borrowed}
end

M.DEFAULT_NAMES = DEFAULT_NAMES
M.create = create
M.clear = clear
M.acquire = acquire
M.release = release
M.copyOut = copyOut
M.snapshot = snapshot

return M
