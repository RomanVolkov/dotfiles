-- All colorscheme plugins live here so theme management is in one place.
-- Default theme is set in lua/config/lazy.lua via vim.cmd.colorscheme().
-- Switch interactively with <leader>uc (Snacks.picker.colorschemes — live preview).
-- Toggle background transparency with <leader>ut. The colorschemes here ship
-- their natural backgrounds; transparency is layered on top by
-- lua/util/transparency.lua, which is what the toggle controls.

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      background = { dark = "mocha" },
      compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
      integrations = {
        blink_cmp = true,
        -- Disable bufferline integration so catppuccin doesn't paint
        -- BufferLine* with its own bg colors. The transparency util
        -- (lua/util/transparency.lua) owns those groups.
        bufferline = false,
      },
    },
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = {
      background = { dark = "dragon" },
    },
  },

  {
    "rmehri01/onenord.nvim",
    lazy = true,
    opts = {
      theme = "dark",
    },
  },

  {
    "vague-theme/vague.nvim",
    lazy = true,
  },

  -- nyoom-engineering's colorscheme is oxocarbon (nyoom.nvim itself is a
  -- distro framework, not a theme). dark by default.
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = true,
  },
}
