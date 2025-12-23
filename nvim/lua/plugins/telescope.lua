return {
  "nvim-telescope/telescope.nvim",
  keys = function()
    return {
      { "<leader><S-f>", "<cmd>Telescope find_files<cr>", desc = "Search Files" },
      { "<leader><S-g>", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader><S-d>", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Search Document Symbols" },
      { "<leader><S-o>", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Search Workspace Symbols" },
      { "<leader>sw", "<cmd>Telescope diagnostics<cr>", desc = "[S]earch Diagnostics/[W]arnings" },
      { "<leader>se", vim.diagnostic.setloclist, desc = "[S]earch Diagnostics/[E]rrors" },
      { "<leader><S-b>", "<cmd>Telescope buffers<cr>", desc = "Search Buffers" },
    }
  end,
}
