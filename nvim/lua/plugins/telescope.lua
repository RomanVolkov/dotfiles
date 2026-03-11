return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      layout_strategy = "vertical", -- change horizontal -> vertical
      layout_config = {
        vertical = {
          prompt_position = "top",
          preview_height = 0.4, -- preview takes 40% at bottom
          results_height = 0.6,
        },
        width = 0.87,
        height = 0.90,
        preview_cutoff = 40,
      },
      sorting_strategy = "ascending",
      mappings = {
        i = {
          ["<C-k"] = "move_selection_previous",
          ["<C-j>"] = "move_selection_next",
        },
      },
    },
  },
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
