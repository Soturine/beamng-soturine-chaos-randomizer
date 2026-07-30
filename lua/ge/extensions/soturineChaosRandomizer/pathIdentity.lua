local M = {}

local function trim(value)
  return value:gsub("^%s+", ""):gsub("%s+$", "")
end

local function physical(value)
  if type(value) ~= "string" then return nil, "path_not_string" end
  if trim(value):match("^[A-Za-z][A-Za-z0-9+.-]*://") then return nil, "path_external_absolute" end
  local result = trim(value):gsub("\\", "/"):gsub("/+", "/")
  if result == "" then return nil, "path_empty" end
  if result:find("%z") or result:find("[%c]") then return nil, "path_control_character" end
  if result:match("^[A-Za-z][A-Za-z0-9+.-]*://") or result:match("^[A-Za-z]:")
    or result:sub(1, 2) == "//"
  then return nil, "path_external_absolute" end
  for segment in result:gmatch("[^/]+") do
    if segment == ".." then return nil, "path_traversal" end
  end
  if result == "." or result:find("/./", 1, true) or result:sub(-2) == "/." then
    return nil, "path_dot_segment"
  end
  if not result:lower():match("%.pc$") then result = result .. ".pc" end
  if result:sub(1, 1) ~= "/" and result:find("/", 1, true) then result = "/" .. result end
  return result
end

local function comparison(value)
  local exact, reason = physical(value)
  if not exact then return nil, reason end
  return exact:lower()
end

local function basename(value)
  local normalized = comparison(value)
  if not normalized then return nil end
  return normalized:match("([^/]+)%.pc$")
end

local function create(value)
  local exact, reason = physical(value)
  if not exact then return nil, reason end
  return {
    physicalPathExact = exact,
    comparisonPathNormalized = exact:lower(),
    basenameKey = exact:lower():match("([^/]+)%.pc$"),
  }
end

M.physical = physical
M.comparison = comparison
M.basename = basename
M.create = create

return M
