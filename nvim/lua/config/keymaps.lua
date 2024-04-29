-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Disable space key in normal mode
vim.api.nvim_set_keymap("n", "<Space>", "<NOP>", { noremap = true, silent = true })

-- Buffer management
vim.api.nvim_set_keymap("n", "<C-w>", ":bw<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-Right>", ":bn<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-Left>", ":bp<CR>", { noremap = true, silent = true })

-- Explore mode
vim.api.nvim_set_keymap("n", "<S-T>", ":Ex<CR>", { noremap = true, silent = true })

vim.keymap.del({ "i" }, "<Esc>")

-- Always use find in files
-- vim.api.nvim_set_keymap("n", "<leader><space>", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })

-- Set macro record for <Leader>q instead of q
vim.api.nvim_set_keymap("n", "<Leader>q", "q", { noremap = true })
vim.api.nvim_set_keymap("n", "q", "<Nop>", { noremap = true })
