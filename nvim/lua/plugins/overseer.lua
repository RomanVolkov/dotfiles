-- Floating task list for overseer. Overseer.nvim only ships side-split
-- task lists; this wraps :OverseerOpen so the task list buffer is shown
-- in a centered float (lazygit-style) and toggles open/closed.
local float_win = nil

local function toggle_float()
  -- Already open? Close it.
  if float_win and vim.api.nvim_win_is_valid(float_win) then
    vim.api.nvim_win_close(float_win, true)
    float_win = nil
    return
  end

  -- Make sure overseer's task list buffer exists. :OverseerOpen creates it
  -- in a side split; we immediately close that split and reuse the buffer.
  vim.cmd.OverseerOpen()
  local task_buf
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "OverseerList" then
      task_buf = buf
      vim.api.nvim_win_close(win, true)
      break
    end
  end
  if not task_buf then
    vim.notify("Could not locate OverseerList buffer", vim.log.levels.ERROR)
    return
  end

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  float_win = vim.api.nvim_open_win(task_buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    border = "rounded",
    title = " Overseer ",
    title_pos = "center",
    style = "minimal",
  })
  -- q closes the float for symmetry with help/qf etc.
  vim.keymap.set("n", "q", function()
    if float_win and vim.api.nvim_win_is_valid(float_win) then
      vim.api.nvim_win_close(float_win, true)
      float_win = nil
    end
  end, { buffer = task_buf, nowait = true })
end

return {
  "stevearc/overseer.nvim",
  ---@module 'overseer'
  ---@type overseer.SetupOpts
  opts = {},
  -- stylua: ignore
  keys = {
    { "<leader>rr", "<cmd>OverseerRun<cr>", desc = "Overseer: Run Task" },
    { "<leader>rt", toggle_float, desc = "Overseer: Toggle Tasks (Float)" },
  },
}
