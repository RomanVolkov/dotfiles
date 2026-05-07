return {
  "stevearc/overseer.nvim",
  ---@module 'overseer'
  ---@type overseer.SetupOpts
  opts = {
    task_list = {
      direction = "bottom",
      min_height = 12,
      max_height = 25,
    },
  },
  -- stylua: ignore
  keys = {
    { "<leader>rr", "<cmd>OverseerRun<cr>", desc = "Overseer: Run Task" },
    { "<leader>rt", "<cmd>OverseerToggle<cr>", desc = "Overseer: Toggle Tasks" },
  },
}
