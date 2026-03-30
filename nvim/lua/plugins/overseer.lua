return {
  "stevearc/overseer.nvim",
  ---@module 'overseer'
  ---@type overseer.SetupOpts
  opts = {},

  keys = {
    {
      -- "<leader>rt",
      "<F10>",
      "<cmd>OverseerRun<cr>",
      desc = "Run task (Overseer)",
    },
    {
      -- "<leader>ro",
      "<F11>",
      "<cmd>OverseerToggle<cr>",
      desc = "Toggle Overseer",
    },
  },
}
