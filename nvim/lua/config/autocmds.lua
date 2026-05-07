-- ===== Defaults inherited from LazyVim, now explicit =====
local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].user_last_loc then
      return
    end
    vim.b[buf].user_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dap-float",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("man_unlisted"),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- ===== User-specific autocmds below =====

vim.lsp.log.set_level(vim.lsp.log.levels.OFF)

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

-- close netrw with q (leader + T)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.keymap.set("n", "q", ":bd<CR>", { buffer = true, silent = true })
  end,
})

vim.cmd("let g:netrw_banner = 0")
vim.cmd("let g:netrw_liststyle = 1")
vim.cmd("let g:netrw_winsize = 25")
