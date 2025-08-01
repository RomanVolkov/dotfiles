-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "python", "swift" },
  callback = function()
    vim.b.autoformat = false
  end,
})

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
