-- ============================================================================
-- Keymap mental model
-- ============================================================================
-- Three layers, no exceptions:
--
-- 1) DIRECT KEYS (no leader) — muscle memory, things you do constantly
--    <C-h/j/k/l>          panes / tmux (vim-tmux-navigator)
--    <C-Up/Down/L/R>      resize pane
--    gd / gr / gi / gD / gy   LSP go-to (definition / refs / impl / decl / type)
--    K / gK / <C-k>(i)        hover / signature
--    ]d [d  ]e [e  ]w [w      next/prev diagnostic / error / warning
--    ]q [q                    next/prev quickfix or Trouble item
--    ]t [t                    next/prev todo
--    n N                      search nav
--    <F5/F7/F2-4/F8/F12>      DAP (continue / breakpoint / step* / terminate / step-out)
--    <F10/F11>                Overseer run / toggle
--    -  _                     Yazi at file / cwd
--
-- 2) <leader>{NOUN}{VERB} — first letter is what you operate on
--    f*  Files            ff find · fg grep · fN new · fe/fE yazi
--    b*  Buffers          bb alt · bd close · bo close-others · bn next · bp prev · bf find
--    s*  Search / symbols sd doc-symbols · ss workspace-symbols · sw diagnostics · sr replace (grug-far when present)
--    w*  Windows          w- split-below · w| split-right · wd close · wo only
--    g*  Git              gg/gG lazygit (root/cwd) · gl/gL/gb/gf log family · gB/gY browse · gu open URL
--    c*  Code             cf format · cF format-injected · ca action · cr rename · cc/cC codelens · cD diag-float
--    x*  Lists / Trouble  xq/xl vim quickfix/loclist · xQ/xL Trouble qf/loc · xx/xX Trouble diag · xe→loclist · xt/xT todo
--    q*  Quit / Sessions  qq quit · qs/qS/ql/qd persistence
--    d*  Debug            dl run-last · dps profiler scratch (DAP itself is on F-keys)
--    L                    :Lazy
--    n / un               notification history / dismiss
--    .  / S               scratch / select scratch
--    K(leader+...)        — none; gone
--    Xcodebuild → x*      xa actions · xb build · xr run · xs logs · xu test · xc test-class · xd device · xp test-plan
--
-- 3) FUNCTION KEYS — sticky modal flows (debug, run task)
--    F2..F12 + F10/F11 listed above.
--
-- Lowercase / uppercase convention under <leader>x*: lowercase = vim native
-- (xq, xl), uppercase = Trouble enhanced (xQ, xL, xx, xX).
--
-- Discovery / "what was that key again?":
--   <leader>?            fuzzy-search all keymaps (Snacks.picker.keymaps)
--   press <leader> & wait  which-key popup (300 ms delay) shows next options
--   :verbose nmap <key>  show *where* a key was defined (file:line)
--   :nmap <leader>b      list all keymaps starting with <leader>b
-- ============================================================================

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

-- Buffers (all under <leader>b*)
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Alternate Buffer" })
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous Buffer" })

-- Windows (all under <leader>w*; native <C-w> chords still work)
map("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
map("n", "<leader>wo", "<C-W>o", { desc = "Only Window (close others)", remap = true })

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

-- Indent
map("x", "<", "<gv")
map("x", ">", ">gv")

-- Comments
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- Lazy
map("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- New file
map("n", "<leader>fN", "<cmd>enew<cr>", { desc = "New File" })

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
map("n", "<leader>cD", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- stylua: ignore start

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

-- Quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- Inspect
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map("n", "<leader>uI", function() vim.treesitter.inspect_tree() vim.api.nvim_input("I") end, { desc = "Inspect Tree" })

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

vim.keymap.del({ "i" }, "<Esc>")

vim.api.nvim_set_keymap("n", "<leader><leader>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Space><Space>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader><Space>", "<Nop>", { noremap = true, silent = true })

-- Open URL or local file under cursor (macOS)
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
