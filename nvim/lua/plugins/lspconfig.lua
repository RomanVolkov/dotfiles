return {
  {
    "folke/neoconf.nvim",
    enabled = false,
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    keys = {
      { "[g", vim.diagnostic.goto_prev },
      { "]g", vim.diagnostic.goto_next },
      { "gd", vim.lsp.buf.definition },
      { "gi", vim.lsp.buf.implementation },
      { "gr", vim.lsp.buf.references },
    },
    event = "LazyFile",
    dependencies = {
      { "folke/neodev.nvim", opts = {} },
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
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
        lua_ls = {
          ---@type LazyKeysSpec[]
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
    setup = {
      require("lspconfig").pylsp.setup({
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = {
                ignore = { "E501" },
                maxLineLength = 200,
              },
            },
          },
        },
      }),

      require("lspconfig").sourcekit.setup({
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        cmd = {
          "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp",
        },
        root_dir = function(filename, _)
          return require("lspconfig.util").root_pattern("buildServer.json")(filename)
            or require("lspconfig.util").root_pattern("*.xcodeproj", "*.xcworkspace")(filename)
            or require("lspconfig.util").find_git_ancestor(filename)
            or require("lspconfig.util").root_pattern("Package.swift")(filename)
        end,
      }),
    },
  },
}
