return {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      -- stylua: ignore
      opts = {},
      config = function(_, opts)
        local dap = require("dap")
        local dapui = require("dapui")
        dapui.setup(opts)
        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open({})
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close({})
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close({})
        end
      end,
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {},
    },
    {
      "folke/which-key.nvim",
      optional = true,
      opts = {
        defaults = {
          ["<leader>d"] = { name = "+debug" },
        },
      },
    },
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = "mason.nvim",
      cmd = { "DapInstall", "DapUninstall" },
      opts = {
        automatic_installation = true,
        handlers = {},
        ensure_installed = {},
      },
    },
  },

  keys = {
    {
      "<F9>",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Breakpoint",
    },
    {
      "<F5>",
      function()
        require("dap").continue()
      end,
      desc = "Continue",
    },
    --    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    --    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
    {
      "<F3>",
      function()
        require("dap").step_into()
      end,
      desc = "Step Into",
    },
    --    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
    --    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
    --    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    {
      "<F12>",
      function()
        require("dap").step_out()
      end,
      desc = "Step Out",
    },
    {
      "<F2>",
      function()
        require("dap").step_over()
      end,
      desc = "Step Over",
    },
    --    { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
    --    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    --    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    {
      "<F6>",
      function()
        require("dap").terminate()
      end,
      desc = "Terminate",
    },
    --    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
  },

  config = function()
    local Config = require("lazyvim.config")
    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

    for name, sign in pairs(Config.icons.dap) do
      sign = type(sign) == "table" and sign or { sign }
      vim.fn.sign_define(
        "Dap" .. name,
        { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
      )
    end
  end,
}
