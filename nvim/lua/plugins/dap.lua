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
        require("dap-go").setup({
          dap_configurations = {
            {
              type = "go",
              name = "Attach remote",
              mode = "remote",
              request = "attach",
              host = "127.0.0.1",
              port = "38697",
            },
          },
        })
      end,
    },
    {
      "rcarriga/nvim-dap-ui",
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
        ensure_installed = { "neocmake", "clangd", "gopls", "pylsp", "ruby_ls", "tsserver", "codelldb" },
      },
    },
    {
      "wojciech-kulik/xcodebuild.nvim",
    },
  },

  -- stylua: ignore
  keys = {
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP: Toggle Breakpoint" },
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "DAP: Conditional Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "DAP: Continue / Start" },
    { "<leader>di", function() require("dap").step_into() end, desc = "DAP: Step Into" },
    { "<leader>dn", function() require("dap").step_over() end, desc = "DAP: Step Over (Next)" },
    { "<leader>du", function() require("dap").step_out() end, desc = "DAP: Step Out (Up)" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "DAP: Run Last" },
    { "<leader>dt", function() require("dap").terminate(); require("dapui").close() end, desc = "DAP: Terminate" },
    { "<leader>de", function() require("dapui").eval(nil, { enter = true }) end, desc = "DAP: Eval" },
  },

  config = function()
    local dap_icons = {
      Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
      Breakpoint = " ",
      BreakpointCondition = " ",
      BreakpointRejected = { " ", "DiagnosticError" },
      LogPoint = ".>",
    }
    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

    for name, sign in pairs(dap_icons) do
      sign = type(sign) == "table" and sign or { sign }
      vim.fn.sign_define(
        "Dap" .. name,
        { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
      )
    end

    -- Python debugging via debugpy. Setup is gated on the venv existing
    -- so a missing virtualenv doesn't error out the whole DAP config.
    -- Create with:
    --   python3 -m venv ~/.virtualenvs/debugpy && \
    --   ~/.virtualenvs/debugpy/bin/pip install debugpy
    local debugpy_python = vim.env.HOME .. "/.virtualenvs/debugpy/bin/python"
    if vim.fn.executable(debugpy_python) == 1 then
      require("dap-python").setup(debugpy_python)
    end

    -- swift
    local dap = require("dap")
    local xcodebuild = require("xcodebuild.dap")

    if not dap.adapters.lldb then
      local xcode_path = vim.fn.trim(vim.fn.system("xcode-select -p"))
      dap.adapters.lldb = {
        type = "executable",
        command = xcode_path .. "/usr/bin/lldb-dap",
        name = "lldb",
      }
    end

    dap.configurations.swift = {
      {
        name = "Launch file",
        type = "lldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }

    dap.adapters.codelldb = {
      type = "server",
      port = "13000",
      executable = {
        command = os.getenv("HOME") .. "/.codelldb-darwin-arm64/extension/adapter/codelldb",
        args = {
          "--port",
          "13000",
          "--liblldb",
          "/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/LLDB",
        },
      },
    }
    dap.configurations.rust = {
      {
        name = "Launch Tauri App (Rust)",
        type = "codelldb",
        request = "launch",
        -- Point to your compiled Tauri binary
        program = function()
          return vim.fn.getcwd() .. "/src-tauri/target/debug/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") -- assumes binary = project name
        end,
        cwd = "${workspaceFolder}/src-tauri",
        stopOnEntry = false,
        args = {},
        -- Tauri needs this env to find WebView assets in dev
        env = {
          WEBKIT_DISABLE_COMPOSITING_MODE = "1",
        },
      },
    }
  end,
}
