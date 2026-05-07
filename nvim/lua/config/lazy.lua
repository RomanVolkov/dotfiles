local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- options must load before plugins so leader keys etc. take effect on plugin keymaps
require("config.options")

-- restore persisted transparency state before plugins/colorscheme load,
-- so the ColorScheme autocmd applies the right state on first paint.
require("util.transparency").init()

-- Auto-restore the last session for cwd if nvim was launched with no args.
-- Registered here (not in config/autocmds.lua) because that file loads on
-- User VeryLazy which fires from inside VimEnter — too late for a VimEnter
-- handler. Persistence.load() is a no-op when no session exists, so the
-- fallback is just the empty buffer.
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("user_auto_restore_session", { clear = true }),
  nested = true,
  callback = function()
    if vim.fn.argc(-1) ~= 0 then
      return
    end
    -- Defer one tick so plugins (persistence) finish setup before load.
    vim.schedule(function()
      pcall(function()
        require("persistence").load()
      end)
    end)
  end,
})

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "catppuccin-macchiato", "habamax" } },
  checker = { enabled = true },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- autocmds and keymaps load after VeryLazy so Snacks et al. are available
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("config.autocmds")
    require("config.keymaps")
  end,
})

-- colorscheme (was set via LazyVim opts)
vim.cmd.colorscheme("catppuccin-macchiato")
