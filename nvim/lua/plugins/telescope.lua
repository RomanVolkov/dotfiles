return {
  "nvim-telescope/telescope.nvim",
  keys = function()
    return {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Search [2F]iles" },
      { "<leader>gg", "<cmd>Telescope live_grep<cr>", desc = "Search [2G]rep" },
      { "<leader>dd", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Search [2D]ocument Symbols" },
      { "<leader>oo", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Search Symbols [2O]" },
      { "<leader>sw", "<cmd>Telescope diagnostics<cr>", desc = "[S]earch Diagnostics/[W]arnings" },
      { "<leader>se", vim.diagnostic.setloclist, desc = "[S]earch Diagnostics/[E]rrors" },
      { "<leader>bb", "<cmd>Telescope buffers<cr>", desc = "Search [2B]uffers" },
    }
  end,
}
