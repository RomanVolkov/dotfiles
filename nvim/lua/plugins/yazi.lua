return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    { "-", "<cmd>Yazi<cr>", desc = "File Explorer (Yazi at file)" },
    { "_", "<cmd>Yazi cwd<cr>", desc = "File Explorer (Yazi at cwd)" },
    { "<leader>fe", "<cmd>Yazi<cr>", desc = "File Explorer (at file)" },
    { "<leader>fE", "<cmd>Yazi cwd<cr>", desc = "File Explorer (at cwd)" },
  },
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = true,
    keymaps = {
      show_help = "<f1>",
    },
    yazi_floating_window_border = "rounded",
  },
}
