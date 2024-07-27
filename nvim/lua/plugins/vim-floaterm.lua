return {
  "voldikss/vim-floaterm",
  config = function()
    vim.keymap.set("n", "§", ":FloatermToggle<CR>", { noremap = true })
    vim.keymap.set("i", "§", "<Esc>:FloatermToggle<CR>", { noremap = true })
    vim.keymap.set("t", "§", "<C-\\><C-n>:FloatermToggle<CR>", { noremap = true })
    vim.g.floaterm_width = 150
    vim.g.floaterm_height = 50
    vim.g.floaterm_winblend = 0
  end,
}
