return {
  "wojciech-kulik/xcodebuild.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = function()
    require("xcodebuild").setup({
      integrations = {
        snacks_nvim = { enabled = true },
      },
    })

    -- All xcodebuild keys live under <leader>x*. Keys conflicting with
    -- core/Trouble (xl, xt, xT, xq, xx, xX, xL, xQ) yield to those; xcodebuild
    -- uses neighboring free letters instead.
    vim.keymap.set("n", "<leader>xa", "<cmd>XcodebuildPicker<cr>", { desc = "Xcodebuild: All Actions" })
    vim.keymap.set("n", "<leader>xb", "<cmd>XcodebuildBuild<cr>", { desc = "Xcodebuild: Build" })
    vim.keymap.set("n", "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Xcodebuild: Build & Run" })
    vim.keymap.set("n", "<leader>xs", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Xcodebuild: Show Logs" })
    vim.keymap.set("n", "<leader>xu", "<cmd>XcodebuildTest<cr>", { desc = "Xcodebuild: Run Tests" })
    vim.keymap.set("n", "<leader>xc", "<cmd>XcodebuildTestClass<cr>", { desc = "Xcodebuild: Run Test Class" })
    vim.keymap.set("n", "<leader>xd", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Xcodebuild: Select Device" })
    vim.keymap.set("n", "<leader>xp", "<cmd>XcodebuildSelectTestPlan<cr>", { desc = "Xcodebuild: Select Test Plan" })
  end,
}
