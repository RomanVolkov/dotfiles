return {
  "mason-org/mason.nvim",
  cmd = "Mason",
  keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  build = ":MasonUpdate",
  opts_extend = { "ensure_installed" },
  opts = {
    registries = {
      "github:mason-org/mason-registry",
      "github:crashdummyy/mason-registry",
    },
    ensure_installed = {
      -- Formatters
      "stylua",
      "shfmt",
      "csharpier",
      "prettier",
      "goimports",
      "goimports-reviser",
      -- Linters / extras
      "trivy",
      "gotests",
      -- Rust helper
      "bacon",
      -- Debug adapters
      "codelldb",
      "delve",
      "go-debug-adapter",
      "js-debug-adapter",
      -- LSPs that mason-lspconfig won't auto-install for us
      -- roslyn.nvim looks for a binary named `roslyn-language-server`; the
      -- official mason-org package installs exactly that name.
      "roslyn-language-server",
      "netcoredbg",
      -- Treesitter CLI for parser builds
      "tree-sitter-cli",
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)
    local mr = require("mason-registry")
    mr:on("package:install:success", function()
      vim.defer_fn(function()
        require("lazy.core.handler.event").trigger({
          event = "FileType",
          buf = vim.api.nvim_get_current_buf(),
        })
      end, 100)
    end)

    mr.refresh(function()
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end)
  end,
}
