local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local util = require("lspconfig/util")

lspconfig.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = false,
      analyses = {
        unusedparams = true,
      },
      -- buildFlags = { "-tags=component" },
    },
  },
  -- init_options = {
  --   buildFlags = { "-tags=tests" },
  -- },
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
    "/Applications/Xcode-15.4.0.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp",
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
