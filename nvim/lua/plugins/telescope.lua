return {
  "nvim-telescope/telescope.nvim",
  -- replace all Telescope keymaps with only one mapping
  keys = function()
    return {
      { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Search Files" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>sd", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Search Document Symbols" },
      { "<leader>oo", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Search Symbols" },
    }
  end,
}
