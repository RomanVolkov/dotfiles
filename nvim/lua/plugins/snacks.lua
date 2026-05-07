local function term_nav(dir)
  ---@param self snacks.terminal
  return function(self)
    return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
      vim.cmd.wincmd(dir)
    end)
  end
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    picker = {
      enabled = true,
      layout = { preset = "vertical" },
      win = {
        input = {
          keys = {
            ["<C-j>"] = { "list_down", mode = { "i", "n" } },
            ["<C-k>"] = { "list_up", mode = { "i", "n" } },
          },
        },
      },
    },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = false },
    words = { enabled = true },
    terminal = {
      enabled = false,
      win = {
        keys = {
          nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
          nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
          nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
          nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
          hide_slash = { "<C-/>", "hide", desc = "Hide Terminal", mode = "t" },
          hide_underscore = { "<c-_>", "hide", desc = "which_key_ignore", mode = "t" },
        },
      },
    },
    dashboard = { enabled = false },
  },
  -- stylua: ignore
  keys = {
    { "<leader>n", function()
      if Snacks.config.picker and Snacks.config.picker.enabled then
        Snacks.picker.notifications()
      else
        Snacks.notifier.show_history()
      end
    end, desc = "Notification History" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>dps", function() Snacks.profiler.scratch() end, desc = "Profiler Scratch Buffer" },
    -- Files
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Find in Files (Grep)" },
    -- Buffers
    { "<leader>bf", function() Snacks.picker.buffers() end, desc = "Find Buffer" },
    -- Search / symbols
    { "<leader>sd", function() Snacks.picker.lsp_symbols() end, desc = "Document Symbols" },
    { "<leader>ss", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace Symbols" },
    { "<leader>sw", function() Snacks.picker.diagnostics() end, desc = "Search Diagnostics (Warnings/Errors)" },
    -- Diagnostics list
    { "<leader>xe", vim.diagnostic.setloclist, desc = "Diagnostics → Loclist" },
    -- Help / discovery
    { "<leader>?", function() Snacks.picker.keymaps() end, desc = "Search Keymaps" },
    -- UI
    { "<leader>uc", function() Snacks.picker.colorschemes() end, desc = "Pick Colorscheme" },
  },
  config = function(_, opts)
    local notify = vim.notify
    require("snacks").setup(opts)
    if package.loaded["noice"] or pcall(require, "noice") then
      vim.notify = notify
    end
    -- route vim.ui.select through snacks.picker so plugins like overseer
    -- get a proper fuzzy picker instead of vim's default list prompt.
    vim.ui.select = function(items, select_opts, on_choice)
      return Snacks.picker.select(items, select_opts, on_choice)
    end
  end,
}
