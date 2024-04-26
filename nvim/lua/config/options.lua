-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

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
vim.o.termencoding = "utf-8"

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
vim.o.updatetime = 300
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.scrolloff = 5
vim.o.sidescrolloff = 5

vim.cmd("syntax on")
-- Enable true color in the terminal
vim.o.termguicolors = true

vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 50
