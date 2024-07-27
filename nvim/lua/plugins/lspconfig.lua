return {
  "neovim/nvim-lspconfig",
  keys = {
    { "[g", vim.diagnostic.goto_prev },
    { "]g", vim.diagnostic.goto_next },
    { "gd", vim.lsp.buf.definition },
    { "gi", vim.lsp.buf.implementation },
    { "gf", vim.lsp.buf.references },
    { "ge", vim.lsp.buf.rename },
  },
  event = "LazyFile",
  dependencies = {
    --{ "folke/neodev.nvim", opts = {} },
    "hrsh7th/cmp-nvim-lsp",
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
      pylsp = {},
      gopls = {},
      sourcekit = {},
      tsserver = {},
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
