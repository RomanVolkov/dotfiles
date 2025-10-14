return {
  "akinsho/bufferline.nvim",
  -- -- temp fix until https://github.com/LazyVim/LazyVim/pull/6354 is merged
  -- init = function()
  --   local bufline = require("catppuccin.groups.integrations.bufferline")
  --   function bufline.get()
  --     return bufline.get_theme()
  --   end
  -- end,
  event = "VeryLazy",
  opts = {
    options = {
      close_command = function(n)
        Snacks.bufdelete(n)
      end,
      buffer_close_icon = "",
      right_mouse_command = function(n)
        Snacks.bufdelete(n)
      end,
      diagnostics = "nvim_lsp",
      always_show_bufferline = true,
      diagnostics_indicator = function(_, _, diag)
        local icons = LazyVim.config.icons.diagnostics
        local ret = (diag.error and icons.Error .. diag.error .. " " or "")
          .. (diag.warning and icons.Warn .. diag.warning or "")
        return vim.trim(ret)
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Neo-tree",
          highlight = "Directory",
          text_align = "left",
        },
      },
      ---@param opts bufferline.IconFetcherOpts
      get_element_icon = function(opts)
        return LazyVim.config.icons.ft[opts.filetype]
      end,
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)
    -- Fix bufferline when restoring a session
    vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
      callback = function()
        vim.schedule(function()
          pcall(nvim_bufferline)
        end)
      end,
    })
  end,
}
