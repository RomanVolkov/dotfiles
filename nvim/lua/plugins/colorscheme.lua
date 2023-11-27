return {
  {
    "catppuccin/nvim",
    name = "catppuccin",

    priority = 1000,
    opts = {
      compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
    },
  },
}
