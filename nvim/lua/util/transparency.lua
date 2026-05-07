-- Toggleable transparent background.
-- When ON, strips bg from Normal/NormalFloat/etc. so the terminal background
-- shines through. When OFF, the colorscheme's natural bg colors take over.
-- The toggle state is persisted to disk and restored across nvim restarts.

local M = {}

local state_file = vim.fn.stdpath("state") .. "/transparency.txt"

local function load_state()
  local f = io.open(state_file, "r")
  if not f then
    return true -- default: transparent on
  end
  local content = f:read("*a")
  f:close()
  return content:match("^0") == nil -- "0" = off, anything else = on
end

local function save_state()
  local dir = vim.fn.fnamemodify(state_file, ":h")
  vim.fn.mkdir(dir, "p")
  local f = io.open(state_file, "w")
  if f then
    f:write(vim.g.transparent_bg and "1" or "0")
    f:close()
  end
end

-- Editor groups whose bg gets cleared when transparency is on.
local explicit_groups = {
  "Normal",
  "NormalNC",
  "NormalFloat",
  "FloatBorder",
  "FloatTitle",
  "SignColumn",
  "EndOfBuffer",
  "MsgArea",
  "VertSplit",
  "WinSeparator",
  "StatusLine",
  "StatusLineNC",
}

-- Highlight-group prefixes whose bg gets cleared too — picks up every
-- BufferLine*, Noice*, etc. group the loaded plugins define.
local group_prefixes = { "BufferLine", "Noice" }

local function clear_bg(name)
  local hl = vim.api.nvim_get_hl(0, { name = name })
  hl.bg = "NONE"
  vim.api.nvim_set_hl(0, name, hl)
end

function M.apply()
  if not vim.g.transparent_bg then
    return
  end
  for _, g in ipairs(explicit_groups) do
    clear_bg(g)
  end
  for _, prefix in ipairs(group_prefixes) do
    for _, name in ipairs(vim.fn.getcompletion(prefix, "highlight")) do
      clear_bg(name)
    end
  end
end

function M.toggle()
  vim.g.transparent_bg = not vim.g.transparent_bg
  save_state()
  if vim.g.transparent_bg then
    M.apply()
  else
    -- re-apply the current colorscheme to restore its natural bg
    local cs = vim.g.colors_name
    if cs and cs ~= "" then
      vim.cmd.colorscheme(cs)
    end
  end
  vim.notify("Transparent background: " .. (vim.g.transparent_bg and "ON" or "OFF"))
end

-- Initialize toggle state from disk (call once at startup).
function M.init()
  vim.g.transparent_bg = load_state()
end

return M
