return {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "mfussenegger/nvim-dap-python",
    },
    {
      "nvim-neotest/nvim-nio",
    },
    {
      "leoluz/nvim-dap-go",
      opts = {},
      config = function(_, _)
        require("dap-go").setup()
      end,
    },
    {
      "rcarriga/nvim-dap-ui",
      -- stylua: ignore
      opts = {},
      config = function(_, opts)
        local dap = require("dap")
        local dapui = require("dapui")
        dapui.setup(opts)
        dap.listeners.before.attach.dapui_config = function()
          dapui.open({})
        end
        dap.listeners.before.launch.dapui_config = function()
          dapui.open({})
        end
        dap.listeners.before.event_terminated.dapui_config = function()
          dapui.close({})
        end
        dap.listeners.before.event_exited.dapui_config = function()
          dapui.close({})
        end
      end,
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {},
    },
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = "mason.nvim",
      cmd = { "DapInstall", "DapUninstall" },
      opts = {
        automatic_installation = true,
        handlers = {},
        ensure_installed = { "neocmake", "clangd", "gopls", "pylsp", "ruby_ls", "tsserver" },
      },
    },
    {
      "wojciech-kulik/xcodebuild.nvim",
    },
  },

  keys = {
    {
      "<F7>",
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
      "<F8>",
      function()
        require("dap").terminate()
      end,
      desc = "Terminate",
    },
    --    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    {
      "<F4>",
      function()
        require("dapui").eval(nil, { enter = true })
      end,
      desc = "Eval",
    },
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

    local path = "/Users/romanvolkov/.virtualenvs/debugpy/"
    require("dap-python").setup(path .. "bin/python")

    -- swift
    local dap = require("dap")
    local xcodebuild = require("xcodebuild.dap")

    dap.configurations.swift = {
      {
        name = "iOS App Debugger",
        type = "codelldb",
        request = "launch",
        -- what to use for spm?
        --program = ".build/debug/image_processing",
        program = xcodebuild.get_program_path,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        waitFor = true,
      },
    }

    dap.adapters.codelldb = {
      type = "server",
      port = "13000",
      executable = {
        command = os.getenv("HOME") .. "/.codelldb-aarch64-darwin.vsix/extension/adapter/codelldb",
        args = {
          "--port",
          "13000",
          "--liblldb",
          "/Applications/Xcode-15.4.0.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/LLDB",
        },
      },
    }
  end,
}
