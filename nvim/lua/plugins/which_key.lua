return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    delay = 300,
    spec = {
      { "<leader>s", group = "search/symbols" },
      { "<leader>b", group = "buffers" },
      { "<leader>f", group = "files" },
      { "<leader>x", group = "lists/trouble" },
      { "<leader>c", group = "code" },
      { "<leader>w", group = "windows" },
      { "<leader>g", group = "git" },
      { "<leader>q", group = "quit/sessions" },
      { "<leader>d", group = "debug" },
      { "<leader>r", group = "run/overseer" },
      { "<leader>u", group = "UI" },
      { "<c-h>", desc = "Navigate left (pane)" },
      { "<c-j>", desc = "Navigate down (pane)" },
      { "<c-k>", desc = "Navigate up (pane)" },
      { "<c-l>", desc = "Navigate right (pane)" },
    },
  },
}
