local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- options must load before plugins so leader keys etc. take effect on plugin keymaps
require("config.options")

-- autocmds must load BEFORE lazy.setup so FileType-based autocmds (e.g.
-- wrap_spell which enables spell on markdown) are registered by the
-- time the initial buffer's FileType fires during VimEnter. Loading on
-- User VeryLazy is too late: VeryLazy fires inside VimEnter, AFTER the
-- first buffer's FileType has already run, so wrap_spell would miss it.
-- This file uses only the pure vim API — no plugin requires — so it's
-- safe to load before any plugin spec.
require("config.autocmds")

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

-- keymaps load after VeryLazy so snacks-referencing callbacks have
-- Snacks available by the time they bind. autocmds.lua is loaded
-- eagerly above (it has no plugin deps and FileType autocmds need to
-- exist before the first buffer's FileType fires during VimEnter).
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("config.keymaps")
  end,
})

-- colorscheme (was set via LazyVim opts)
vim.cmd.colorscheme("catppuccin-macchiato")
