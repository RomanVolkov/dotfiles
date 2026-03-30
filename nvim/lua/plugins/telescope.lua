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
          ["<C-k>"] = "move_selection_previous",
          ["<C-j>"] = "move_selection_next",
        },
      },
    },
  },
  keys = function()
    return {
      { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>sb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>sd", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
      { "<leader>so", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
      { "<leader>sw", "<cmd>Telescope diagnostics<cr>", desc = "[S]earch Diagnostics/[W]arnings" },
      { "<leader>se", vim.diagnostic.setloclist, desc = "[S]earch Diagnostics/[E]rrors" },
    }
  end,
}
