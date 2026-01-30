local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local util = require("lspconfig/util")

lspconfig.gopls.setup({
  on_attach = function()
    on_attach()
    vim.api.nvim_set_keymap("n", "<leader><leader>", "<Nop>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<Space><Space>", "<Nop>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader><Space>", "<Nop>", { noremap = true, silent = true })
  end,
  capabilities = capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      gofumpt = true,
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      analyses = {
        fieldalignment = true,
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      usePlaceholders = false,
      completeUnimported = true,
      staticcheck = true,
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
      -- semanticTokens = true,
    },
  },
})

lspconfig.pylsp.setup({
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
})

lspconfig.sourcekit.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {
    "/Applications/Xcode-26.2.0.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp",
  },
  filetypes = { "swift" },
  root_dir = function(filename, _)
    return util.root_pattern("buildServer.json")(filename)
      or util.root_pattern("*.xcodeproj", "*.xcworkspace")(filename)
      -- seems it breaks telescope root dir
      --or util.find_git_ancestor(filename)
      or util.root_pattern("Package.swift")(filename)
  end,
})
