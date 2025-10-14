return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "marilari88/neotest-vitest",
    "nvim-treesitter/nvim-treesitter",
    -- "mmllr/neotest-swift-testing",
    { "fredrikaverpil/neotest-golang", version = "*" }, -- Installation
  },
  opts = {},
  config = function()
    local neotest_golang_opts = {} -- Specify custom configuration
    require("neotest").setup({
      adapters = {
        require("neotest-golang")(neotest_golang_opts), -- Registration
        require("neotest-vitest"),
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
