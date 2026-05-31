return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "marilari88/neotest-vitest",
    "nvim-treesitter/nvim-treesitter",
    { "fredrikaverpil/neotest-golang", version = "*" },
    "nvim-neotest/neotest-jest",
    "nsidorenco/neotest-vstest", -- .NET / C# / F# via VSTest
    "rouge8/neotest-rust",
  },
  opts = {},
  config = function()
    -- neotest-vstest reads vim.g.neotest_vstest at require-time, so any
    -- settings (dap_settings, sdk_path, solution_selector, …) must be
    -- assigned BEFORE the require call below. Defaults work for most
    -- projects; uncomment + customize the table here if you hit a
    -- specific case.
    -- vim.g.neotest_vstest = {
    --   dap_settings = { type = "netcoredbg" },
    -- }

    local neotest_golang_opts = {} -- Specify custom configuration
    require("neotest").setup({
      adapters = {
        require("neotest-golang")(neotest_golang_opts), -- Registration
        require("neotest-vitest"),
        require("neotest-vstest"),
        require("neotest-rust")({
          args = { "--lib", "--bins" },
          dap = { adapter = "lldb" },
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
