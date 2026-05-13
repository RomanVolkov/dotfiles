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

-- Markdown: soft-wrap breaks tables — render-markdown draws cell separators
-- only on the first visual row, so a wrapped long cell turns the table into
-- loose prose. Override wrap_spell above and accept horizontal scroll for
-- long prose lines so tables stay aligned.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("markdown_nowrap"),
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.wrap = false
  end,
})

-- Spell inside comments/strings of code files. Treesitter's @spell capture
-- limits spell-checking to commented or string regions on parsers that
-- ship the capture; identifiers and keywords are NOT highlighted. Only
-- enable for filetypes whose treesitter parser has reliable @spell
-- coverage — adding a filetype that doesn't would spell-check everything.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("spell_in_comments"),
  pattern = {
    "lua", "python", "go", "rust",
    "javascript", "typescript", "tsx", "javascriptreact", "typescriptreact",
    "java", "c", "cpp", "cs",
    "ruby", "swift",
    "sh", "bash", "zsh",
    "vim", "vimdoc",
  },
  callback = function()
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

-- (Auto-restore session on VimEnter is registered earlier, in
-- config/lazy.lua, because this file loads on User VeryLazy which fires
-- *inside* VimEnter — too late for an own VimEnter autocmd.)


-- Check for file changes when the cursor is idle.
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  callback = function()
    vim.cmd("checktime")
  end,
})

-- Optionally, modify the 'updatetime' to make the CursorHold event trigger more frequently
vim.opt.updatetime = 2000 -- 2000 milliseconds or 2 seconds

-- nvim runs its built-in filetype detection BEFORE sourcing init.lua,
-- so FileType=markdown for the buffer passed on the command line fires
-- before any user FileType autocmds in this file are registered.
-- Replay FileType for every already-loaded buffer so e.g. wrap_spell
-- catches the initial buffer. Cheap (just runs the callbacks once per
-- existing buffer) and idempotent.
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= "" then
    vim.api.nvim_buf_call(buf, function()
      vim.cmd("doautocmd FileType")
    end)
  end
end

