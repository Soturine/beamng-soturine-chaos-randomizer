local M = {}

local RUNTIME_NAMES = {
  AUTO_BEST_FIT = "Automatic Best Fit",
  SPLIT_LEFT_RIGHT = "Split Left and Right",
  SINGLE_FILE_BEHIND = "Single File Behind",
  SINGLE_FILE_AHEAD = "Single File Ahead",
  STAGGERED_GRID = "Staggered Grid",
  SIDE_BY_SIDE_GRID = "Side-by-side Grid",
  RADIAL = "Circular / Radial",
  GRID = "Grid",
  LINE = "Line",
}

local LEGACY = {}
for code, name in pairs(RUNTIME_NAMES) do
  LEGACY[code] = code
  LEGACY[name] = code
end
LEGACY.Circle = "RADIAL"
LEGACY["Automatic best fit"] = "AUTO_BEST_FIT"
LEGACY["Staggered grid"] = "STAGGERED_GRID"
LEGACY["Side-by-side grid"] = "SIDE_BY_SIDE_GRID"

local function normalize(value)
  return LEGACY[tostring(value or "")] or "AUTO_BEST_FIT"
end

local function runtimeName(value)
  return RUNTIME_NAMES[normalize(value)]
end

M.RUNTIME_NAMES = RUNTIME_NAMES
M.normalize = normalize
M.runtimeName = runtimeName

return M
