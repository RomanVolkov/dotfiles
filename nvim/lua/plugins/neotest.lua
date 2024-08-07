return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-go",
  },
  opts = {},
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-go")({
          recursive_run = true,
        }),
      },
    })
  end,

  keys = function()
    return {
      { "<leader>tt", "<cmd>:lua require('neotest').run.run()<cr>", desc = "Run all tests" },
      { "<leader>ta", "<cmd>:lua require('neotest').run.run(vim.fn.getcwd())<cr>", desc = "Run all tests" },
    }
  end,
}
