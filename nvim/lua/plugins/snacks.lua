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
    dashboard = {
      preset = {
        header = "",
        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = "\u{f07c} ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = "\u{f15b} ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = "\u{f002} ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = "\u{f1da} ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = "\u{f013} ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = "\u{f7d9} ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "\u{f0cb2} ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = "\u{f011} ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },
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
    -- Picker
    { "<leader>sf", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Live Grep" },
    { "<leader>sb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>sd", function() Snacks.picker.lsp_symbols() end, desc = "Document Symbols" },
    { "<leader>so", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace Symbols" },
    { "<leader>sw", function() Snacks.picker.diagnostics() end, desc = "Search Diagnostics" },
    { "<leader>se", vim.diagnostic.setloclist, desc = "Diagnostics Loclist" },
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
