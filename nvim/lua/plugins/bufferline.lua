return {
  "akinsho/bufferline.nvim",
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
      show_tab_indicators = false,
      show_close_icon = false,
      diagnostics_indicator = function(_, _, diag)
        local icons = {
          Error = " ",
          Warn = " ",
          Hint = " ",
          Info = " ",
        }
        local ret = (diag.error and icons.Error .. diag.error .. " " or "")
          .. (diag.warning and icons.Warn .. diag.warning or "")
        return vim.trim(ret)
      end,
      ---@param opts bufferline.IconFetcherOpts
      get_element_icon = function(opts)
        local ft_icons = { octo = " ", gh = " ", ["markdown.gh"] = " " }
        return ft_icons[opts.filetype]
      end,
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)

    -- Transparency for BufferLine* highlights is owned by util.transparency
    -- (toggleable with <leader>ut, applied on ColorScheme).

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
