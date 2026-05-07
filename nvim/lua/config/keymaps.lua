-- ===== Defaults inherited from LazyVim, now explicit =====
local map = vim.keymap.set

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- (Window/tmux navigation is owned by vim-tmux-navigator via <C-h/j/k/l>.)

-- Resize window using <ctrl> arrows
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- Buffers (<S-h>/<S-l> and [b/]b are also set by bufferline.lua)
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- Clear search on <esc>
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- Saner n / N
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Undo break points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- Save
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- Indent
map("x", "<", "<gv")
map("x", ">", ">gv")

-- Comments
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- Lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- New file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- Location list
map("n", "<leader>xl", function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Location List" })

-- Quickfix list
map("n", "<leader>xq", function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Quickfix List" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- Format
map({ "n", "x" }, "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format" })

-- Diagnostics
local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- stylua: ignore start

-- Toggles (Snacks-backed)
Snacks.toggle({
  name = "Auto Format (Global)",
  get = function() return vim.g.autoformat == nil or vim.g.autoformat end,
  set = function(state) vim.g.autoformat = state end,
}):map("<leader>uf")
Snacks.toggle({
  name = "Auto Format (Buffer)",
  get = function() return vim.b.autoformat == nil or vim.b.autoformat end,
  set = function(state) vim.b.autoformat = state end,
}):map("<leader>uF")
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.dim():map("<leader>uD")
Snacks.toggle.animate():map("<leader>ua")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.scroll():map("<leader>uS")
Snacks.toggle.profiler():map("<leader>dpp")
Snacks.toggle.profiler_highlights():map("<leader>dph")

if vim.lsp.inlay_hint then
  Snacks.toggle.inlay_hints():map("<leader>uh")
end

-- Lazygit
local root = require("util.root")
if vim.fn.executable("lazygit") == 1 then
  map("n", "<leader>gg", function() Snacks.lazygit({ cwd = root.git() }) end, { desc = "Lazygit (Root Dir)" })
  map("n", "<leader>gG", function() Snacks.lazygit() end, { desc = "Lazygit (cwd)" })
end

map("n", "<leader>gL", function() Snacks.picker.git_log() end, { desc = "Git Log (cwd)" })
map("n", "<leader>gb", function() Snacks.picker.git_log_line() end, { desc = "Git Blame Line" })
map("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Current File History" })
map("n", "<leader>gl", function() Snacks.picker.git_log({ cwd = root.git() }) end, { desc = "Git Log (Root Dir)" })
map({ "n", "x" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse (open)" })
map({ "n", "x" }, "<leader>gY", function()
  Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false })
end, { desc = "Git Browse (copy)" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- Inspect
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map("n", "<leader>uI", function() vim.treesitter.inspect_tree() vim.api.nvim_input("I") end, { desc = "Inspect Tree" })

-- Floating terminal
map("n", "<leader>fT", function() Snacks.terminal() end, { desc = "Terminal (cwd)" })
map("n", "<leader>ft", function() Snacks.terminal(nil, { cwd = root.project() }) end, { desc = "Terminal (Root Dir)" })

-- Windows
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
Snacks.toggle.zen():map("<leader>uz")

-- Tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Lua scratch
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function(ev)
    vim.keymap.set({ "n", "x" }, "<localleader>r", function() Snacks.debug.run() end, { buffer = ev.buf, desc = "Run Lua" })
  end,
})

-- ===== User keymaps below =====

-- Disable space key in normal mode
vim.api.nvim_set_keymap("n", "<Space>", "<NOP>", { noremap = true, silent = true })

-- Buffer management
vim.api.nvim_set_keymap("n", "<C-w>", ":bw<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-m>", ":bn<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-n>", ":bp<CR>", { noremap = true, silent = true })

-- Explore mode
-- vim.api.nvim_set_keymap("n", "<C-T>", ":Ex<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>e", ":Ex<CR>", { noremap = true, silent = true })

vim.keymap.del({ "i" }, "<Esc>")

-- Map Q to q in normal mode
vim.api.nvim_set_keymap("n", "Q", "q", { noremap = true, silent = true })
-- Disable the q key in normal mode
vim.api.nvim_set_keymap("n", "q", "<Nop>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader><leader>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Space><Space>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader><Space>", "<Nop>", { noremap = true, silent = true })

-- vim.keymap.set("n", "<C-Space>", "<Nop>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<C-@>", "<Nop>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<Nul>", "<Nop>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<C-0>", "<Nop>", { noremap = true, silent = true })
--
-- Telescope additional
vim.keymap.set("n", "<leader>gu", function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col(".")
  local buf_dir = vim.fn.expand("%:p:h")

  -- aggressively clean junk around paths / urls
  local function clean(target)
    target = target:gsub("^%s+", ""):gsub("%s+$", "")

    -- strip common comment prefixes
    target = target:gsub("^%-%-+", "")
    target = target:gsub("^//+", "")
    target = target:gsub("^#+", "")

    -- strip surrounding junk
    target = target:gsub("^[%\"%'%(%[%{]+", "")
    target = target:gsub("[%\"%'%,%)%]%}]+$", "")

    return target
  end

  local function open_target(target)
    target = clean(target)

    -- URLs and file://
    if target:match("^https?://") or target:match("^file://") then
      vim.fn.system({ "open", target })
      return true
    end

    -- local file path (absolute or relative)
    local path = target
    if not path:match("^/") then
      path = buf_dir .. "/" .. path
    end
    path = vim.fn.fnamemodify(path, ":p")

    if vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1 then
      vim.fn.system({ "open", path })
      return true
    end

    return false
  end

  -- Markdown-style [text](target)
  for start_idx, text, target in line:gmatch("()(%b[])%((.-)%)") do
    local end_idx = start_idx + #text + #target + 2
    if col >= start_idx and col <= end_idx then
      if open_target(target) then
        return
      end
    end
  end

  -- Fallback: whatever is under cursor (quoted, comma-terminated, etc.)
  local fallback = vim.fn.expand("<cWORD>")
  if open_target(fallback) then
    return
  end

  vim.notify("No URL or local file found under cursor", vim.log.levels.INFO)
end, { desc = "Open URL or local file under cursor (macOS)" })
