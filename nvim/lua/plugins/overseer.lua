return {
  "stevearc/overseer.nvim",
  ---@module 'overseer'
  ---@type overseer.SetupOpts
  opts = {},

  keys = {
    { "<F10>", "<cmd>OverseerRun<cr>", desc = "Run task (Overseer)" },
    { "<F11>", "<cmd>OverseerToggle<cr>", desc = "Toggle Overseer" },
  },
}
