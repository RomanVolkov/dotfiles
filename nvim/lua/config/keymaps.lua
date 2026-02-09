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
vim.keymap.set("n", "<leader>gu", function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col(".")
  local buf_dir = vim.fn.expand("%:p:h")

  -- aggressively clean junk around paths / urls
  local function clean(target)
    target = target:gsub("^%s+", ""):gsub("%s+$", "")
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
