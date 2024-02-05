return {
  {
    "catppuccin/nvim",
    name = "catppuccin",

    priority = 1000,
    opts = {
      flavour = "frappe",
      background = { -- :h background
        light = "latte",
        dark = "frappe",
      },
      compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
    },
  },
}
