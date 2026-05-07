return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  opts = {
    flavour = "macchiato",
    background = { dark = "macchiato" },
    transparent_background = true,
    integrations = { blink_cmp = true },
    compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
  },
}
