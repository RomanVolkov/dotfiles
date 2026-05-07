return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  opts = {
    flavour = "macchiato",
    background = { dark = "macchiato" },
    transparent_background = true,
    float = { transparent = true, solid = false },
    integrations = {
      blink_cmp = true,
      snacks = true,
    },
    compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
  },
}
