-- Toggleable transparent background.
-- When ON, strips bg from Normal/NormalFloat/etc. so the terminal background
-- shines through. When OFF, the colorscheme's natural bg colors take over.

local M = {}

-- Editor groups whose bg gets cleared when transparency is on.
local groups = {
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

function M.apply()
  if not vim.g.transparent_bg then
    return
  end
  for _, g in ipairs(groups) do
    local hl = vim.api.nvim_get_hl(0, { name = g })
    hl.bg = "NONE"
    vim.api.nvim_set_hl(0, g, hl)
  end
end

function M.toggle()
  vim.g.transparent_bg = not vim.g.transparent_bg
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

return M
