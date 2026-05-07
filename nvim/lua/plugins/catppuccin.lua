-- Catppuccin (macchiato) is the only theme.
-- transparent_background reads vim.g.transparent_bg, which is loaded from
-- ~/.local/state/nvim/transparency.txt by util.transparency.init() in
-- config/lazy.lua before plugins load. Toggle with <leader>ut
-- (lua/util/transparency.lua reconfigures + reloads catppuccin live).

return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  opts = function()
    return {
      flavour = "macchiato",
      background = { dark = "macchiato" },
      transparent_background = vim.g.transparent_bg ~= false,
      integrations = { blink_cmp = true },
      compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
    }
  end,
}
