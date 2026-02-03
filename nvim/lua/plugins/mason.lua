return {
  "mason-org/mason.nvim",
  opts = {
    registries = {
      "github:mason-org/mason-registry",
      "github:crashdummyy/mason-registry",
    },
    ensure_installed = {
      "lua-language-server",

      -- for some reason those have to be installed explicitely with MasonInstall
      "roslyn",
      "netcoredbg",
    },
  },
}
