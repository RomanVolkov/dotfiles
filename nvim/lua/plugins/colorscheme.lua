return {
  {
    "catppuccin/nvim",
    name = "catppuccin",

    priority = 1000,
    opts = {
      flavour = "mocha",
      background = { -- :h background
        light = "latte",
        dark = "mocha",
      },
      compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
    },
  },
}
