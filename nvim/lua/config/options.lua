-- Leader keys (was set by LazyVim)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Autoformat toggle (read by conform.nvim format_on_save)
vim.g.autoformat = true

-- Defaults inherited from LazyVim, now explicit
local opt = vim.opt

opt.autowrite = true
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldlevel = 99
opt.formatoptions = "jcroqlnt"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.inccommand = "nosplit"
opt.jumpoptions = "view"
opt.laststatus = 3
opt.list = true
opt.mouse = "a"
opt.pumblend = 10
opt.pumheight = 10
opt.ruler = false
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true
opt.shiftwidth = 2
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.signcolumn = "yes"
opt.smartindent = true
opt.smoothscroll = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.undofile = true
opt.undolevels = 10000
opt.virtualedit = "block"
opt.wildmode = "longest:full,full"
opt.winminwidth = 5

vim.g.markdown_recommended_style = 0

-- ===== User-specific overrides below =====

-- Set tab options
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.smarttab = true
vim.o.softtabstop = 4
vim.o.autoindent = true

-- Display options
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = true
vim.o.linebreak = true
vim.o.termguicolors = true

-- Editing options
vim.o.backspace = "indent,eol,start"
vim.o.encoding = "utf-8"
-- vim.o.termencoding = "utf-8"

-- Backup and swap options
vim.o.backup = false
vim.o.swapfile = false

-- Searching and navigation options
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.smartcase = true

-- FZF integration
vim.o.runtimepath = vim.o.runtimepath .. ",/opt/homebrew/opt/fzf"

-- Shell integration
vim.o.shell = "zsh"

-- Miscellaneous options
vim.o.showmode = false
vim.o.showcmd = false
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.scrolloff = 10
vim.o.sidescrolloff = 5

vim.cmd("syntax on")
-- Enable true color in the terminal
vim.o.termguicolors = true

vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 50

vim.g.snacks_animate = false

vim.opt.spell = true
vim.opt.spelllang = { "ru", "en" }

vim.opt.listchars:append({ tab = "→ " })
