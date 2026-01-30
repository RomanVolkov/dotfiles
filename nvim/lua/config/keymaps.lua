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

vim.keymap.set("n", "<leader>gu", function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col(".")

  for start_idx, text, url in line:gmatch("()(%b[])%((.-)%)") do
    local end_idx = start_idx + #text + #url + 2 -- +2 for "()"
    if col >= start_idx and col <= end_idx then
      vim.fn.system({ "open", url })
      return
    end
  end

  -- fallback: raw URL under cursor
  local fallback = vim.fn.expand("<cWORD>")
  if fallback:match("^https?://") then
    vim.fn.system({ "open", fallback })
  else
    vim.notify("No URL found under cursor", vim.log.levels.INFO)
  end
end, { desc = "Open Markdown URL under cursor" })
