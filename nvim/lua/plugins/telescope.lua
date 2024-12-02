return {
  "nvim-telescope/telescope.nvim",
  -- replace all Telescope keymaps with only one mapping
  keys = function()
    return {
      { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "[S]earch [F]iles" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "[S]earch [G]rep" },
      { "<leader>sd", "<cmd>Telescope lsp_document_symbols<cr>", desc = "[S]earch [D]ocument Symbols" },
      { "<leader>oo", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Search Symbols" },
      { "<leader>sw", "<cmd>Telescope diagnostics<cr>", desc = "[S]earch Diagnostics/[W]arnings" },
      { "<leader>se", vim.diagnostic.setloclist, desc = "[S]earch Diagnostics/[E]rrors" },
      { "<leader>sb", "<cmd>Telescope buffers<cr>", desc = "[S]earch Buffers" },
    }
  end,
}
