-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "python", "swift" },
  callback = function()
    vim.b.autoformat = false
  end,
})

----https://github.com/nvim-telescope/telescope.nvim/blob/b4da76be54691e854d3e0e02c36b0245f945c2c7/plugin/telescope.lua#L19
--vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
--vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "none" })
--vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "none" })
--vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "none" })
--vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
--vim.api.nvim_set_hl(0, "TelescopeTitle", { bg = "none" })

local function telescope_transparent()
  local groups = {
    "TelescopeNormal",
    "TelescopePromptNormal",
    "TelescopeResultsNormal",
    "TelescopePreviewNormal",

    "TelescopeBorder",
    "TelescopePromptBorder",
    "TelescopeResultsBorder",
    "TelescopePreviewBorder",

    "TelescopeTitle",
    "TelescopePromptTitle",
    "TelescopeResultsTitle",
    "TelescopePreviewTitle",
  }

  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none" })
  end
end

-- Re-apply after any colorscheme change (this is the important part)
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = telescope_transparent,
})

-- And apply once on startup as well
vim.api.nvim_create_autocmd("VimEnter", {
  callback = telescope_transparent,
})

vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

-- autoupdate
-- local function augroup(name)
--   return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
-- end
-- disable auto update of plugins
--vim.api.nvim_create_autocmd("VimEnter", {
--  group = augroup("autoupdate"),
--  callback = function()
--    require("lazy").update({
--      show = false,
--    })
--  end,
--})

-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     vim.lsp.start()
--   end,
-- })

-- Set up an autocommand to check for file changes when the cursor is idle
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  callback = function()
    vim.cmd("checktime")
  end,
})

-- Optionally, modify the 'updatetime' to make the CursorHold event trigger more frequently
vim.opt.updatetime = 2000 -- 2000 milliseconds or 2 seconds

--add another comment to check if it works
--
--try again
