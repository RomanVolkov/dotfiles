-- All colorscheme plugins live here so theme management is in one place.
-- Default theme is set in lua/config/lazy.lua via vim.cmd.colorscheme().
-- Switch interactively with <leader>uc (Snacks.picker.colorschemes — live preview).

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      integrations = { blink_cmp = true },
      flavour = "mocha",
      background = { dark = "mocha" },
      transparent_background = true,
      compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
    },
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = {
      background = { dark = "dragon" },
      transparent = true,
    },
  },

  {
    "rmehri01/onenord.nvim",
    lazy = true,
    opts = {
      theme = "dark",
      disable = { background = true },
    },
  },

  {
    "vague-theme/vague.nvim",
    lazy = true,
    opts = {
      transparent = true,
    },
  },

  -- nyoom-engineering's colorscheme is oxocarbon (nyoom.nvim itself is a
  -- distro framework, not a theme). dark by default.
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = true,
  },
}
