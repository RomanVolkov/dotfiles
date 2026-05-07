return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {},
  init = function()
    -- Right before persistence writes the session, drop any listed buffers
    -- that aren't currently shown in a window. Without this, files you
    -- opened earlier and switched away from (still loaded, just hidden)
    -- get baked into the session and reappear on restore.
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceSavePre",
      callback = function()
        local visible = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          visible[vim.api.nvim_win_get_buf(win)] = true
        end
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if
            not visible[buf]
            and vim.api.nvim_buf_is_loaded(buf)
            and vim.bo[buf].buflisted
            and vim.bo[buf].buftype == ""
          then
            pcall(vim.api.nvim_buf_delete, buf, { force = false })
          end
        end
      end,
    })
  end,
  -- stylua: ignore
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
    { "<leader>qS", function() require("persistence").select() end, desc = "Select Session" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    { "<leader>qw", function()
      vim.api.nvim_exec_autocmds("User", { pattern = "PersistenceSavePre" })
      require("persistence").save()
      vim.notify("Session saved")
    end, desc = "Save Session Now" },
  },
}
