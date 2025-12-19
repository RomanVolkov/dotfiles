-- Disable space key in normal mode
vim.api.nvim_set_keymap("n", "<Space>", "<NOP>", { noremap = true, silent = true })

-- Buffer management
vim.api.nvim_set_keymap("n", "<C-w>", ":bw<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-Right>", ":bn<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-Left>", ":bp<CR>", { noremap = true, silent = true })

-- Explore mode
vim.api.nvim_set_keymap("n", "<S-T>", ":Ex<CR>", { noremap = true, silent = true })

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
vim.keymap.set("n", "<Leader>sn", function()
  require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })

-- Disable weird Shift-j
vim.api.nvim_set_keymap("n", "<S-j>", "", {})
