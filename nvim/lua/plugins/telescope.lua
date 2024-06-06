return {
  "nvim-telescope/telescope.nvim",
  -- replace all Telescope keymaps with only one mapping
  keys = function()
    return {
      { "<leader>/", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>\\", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>[", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Live Grep" },
      { "<leader>]", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Live Grep" },
    }
  end,
}
