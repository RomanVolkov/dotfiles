return {
  {
    "catppuccin/nvim",
    name = "catppuccin",

    priority = 1000,
    opts = {
      integrations = { blink_cmp = true },
      flavour = "mocha",
      background = { -- :h background
        dark = "mocha",
      },
      transparent_background = true,
      compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
    },
  },
}
