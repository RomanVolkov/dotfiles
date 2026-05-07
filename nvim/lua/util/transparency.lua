-- Toggleable transparent background. Catppuccin owns transparency natively
-- via opts.transparent_background; the toggle re-runs catppuccin.setup with
-- the new value and reloads the colorscheme. State persists to disk.

local M = {}

local state_file = vim.fn.stdpath("state") .. "/transparency.txt"

local function load_state()
  local f = io.open(state_file, "r")
  if not f then
    return true -- default ON
  end
  local content = f:read("*a")
  f:close()
  return content:match("^0") == nil
end

local function save_state()
  vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
  local f = io.open(state_file, "w")
  if f then
    f:write(vim.g.transparent_bg and "1" or "0")
    f:close()
  end
end

function M.toggle()
  vim.g.transparent_bg = not vim.g.transparent_bg
  save_state()
  local spec = require("lazy.core.config").plugins["catppuccin"]
  if spec and spec._ and spec._.opts then
    require("catppuccin").setup(vim.tbl_deep_extend("force", spec._.opts, {
      transparent_background = vim.g.transparent_bg,
    }))
  end
  vim.cmd.colorscheme("catppuccin-macchiato")
  vim.notify("Transparent background: " .. (vim.g.transparent_bg and "ON" or "OFF"))
end

-- Initialize toggle state from disk (call once at startup).
function M.init()
  vim.g.transparent_bg = load_state()
end

return M
