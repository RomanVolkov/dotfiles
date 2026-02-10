return {
  "stevearc/overseer.nvim",
  ---@module 'overseer'
  ---@type overseer.SetupOpts
  opts = {},

  keys = {
    {
      "<leader>rt",
      "<cmd>OverseerRun<cr>",
      desc = "Run task (Overseer)",
    },
    {
      "<leader>ro",
      "<cmd>OverseerToggle<cr>",
      desc = "Toggle Overseer",
    },
  },
}
