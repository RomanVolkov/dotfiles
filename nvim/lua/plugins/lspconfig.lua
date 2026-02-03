return {
  "neovim/nvim-lspconfig",
  keys = {
    { "[g", vim.diagnostic.goto_prev },
    { "]g", vim.diagnostic.goto_next },
    { "gd", vim.lsp.buf.definition },
    { "ge", vim.lsp.buf.rename },
    { "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "Search LSP Implementations" },
    { "gr", "<cmd>Telescope lsp_references<cr>", desc = "Search LSP References" },
  },
  event = "LazyFile",
  dependencies = {
    --{ "folke/neodev.nvim", opts = {} },
    { "antosha417/nvim-lsp-file-operations", config = true },
    {
      "gfanto/fzf-lsp.nvim",
      opts = {},
    },
  },
  ---@class PluginLspOpts
  opts = {
    -- options for vim.diagnostic.config()
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      },
      severity_sort = true,
    },
    inlay_hints = {
      enabled = false,
    },
    capabilities = {},
    format = {
      formatting_options = nil,
      timeout_ms = nil,
    },
    -- LSP Server Settings
    servers = {
      roslyn = {},
      -- omnisharp = {},
      pylsp = {},
      sourcekit = {},
      tsserver = {},
      clangd = {},
      lua_ls = {
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false,
            },
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      },
    },
  },
}
