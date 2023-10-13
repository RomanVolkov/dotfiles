local dap, dapui =require("dap"),require("dapui")
dap.adapters.go = function(callback, config)
    -- Wait for delve to start
    vim.defer_fn(function()
            callback({ type = "server", host = "127.0.0.1", port = "port" })
        end,
        100)
end

local M = {
    last_testname = "",
    last_testpath = "",
    test_buildflags = "",
}

local default_config = {
    delve = {
        path = "dlv",
        initialize_timeout_sec = 20,
        port = "${port}",
        args = {},
        build_flags = "",
    },
}

local function load_module(module_name)
    local ok, module = pcall(require, module_name)
    assert(ok, string.format("dap-go dependency error: %s not installed", module_name))
    return module
end

local function get_arguments()
    return coroutine.create(function(dap_run_co)
        local args = {}
        vim.ui.input({ prompt = "Args: " }, function(input)
            args = vim.split(input or "", " ")
            coroutine.resume(dap_run_co, args)
        end)
    end)
end

local function filtered_pick_process()
    local opts = {}
    vim.ui.input(
        { prompt = "Search by process name (lua pattern), or hit enter to select from the process list: " },
        function(input)
            opts["filter"] = input or ""
        end
    )
    return require("dap.utils").pick_process(opts)
end

local function setup_delve_adapter(dap, config)
    local args = { "dap", "-l", "127.0.0.1:" .. config.delve.port }
    vim.list_extend(args, config.delve.args)

    dap.adapters.go = {
        type = "server",
        port = config.delve.port,
        executable = {
            command = config.delve.path,
            args = args,
        },
        options = {
            initialize_timeout_sec = config.delve.initialize_timeout_sec,
        },
    }
end

local function setup_go_configuration(dap, configs)
    dap.configurations.go = {
        {
            type = "go",
            name = "Debug",
            request = "launch",
            program = "${file}",
            buildFlags = configs.delve.build_flags,
        },
        {
            type = "go",
            name = "Debug (Arguments)",
            request = "launch",
            program = "${file}",
            args = get_arguments,
            buildFlags = configs.delve.build_flags,
        },
        {
            type = "go",
            name = "Debug Package",
            request = "launch",
            program = "${fileDirname}",
            buildFlags = configs.delve.build_flags,
        },
        {
            type = "go",
            name = "Attach",
            mode = "local",
            request = "attach",
            processId = filtered_pick_process,
            buildFlags = configs.delve.build_flags,
        },
        {
            type = "go",
            name = "Debug test",
            request = "launch",
            mode = "test",
            program = "${file}",
            buildFlags = configs.delve.build_flags,
        },
        {
            type = "go",
            name = "Debug test (go.mod)",
            request = "launch",
            mode = "test",
            program = "./${relativeFileDirname}",
            buildFlags = configs.delve.build_flags,
        },
    }

    if configs == nil or configs.dap_configurations == nil then
        return
    end

    for _, config in ipairs(configs.dap_configurations) do
        if config.type == "go" then
            table.insert(dap.configurations.go, config)
        end
    end
end

function M.setup(opts)
    local config = vim.tbl_deep_extend("force", default_config, opts or {})
    M.test_buildflags = config.delve.build_flags
    local dap = load_module("dap")
    setup_delve_adapter(dap, config)
    setup_go_configuration(dap, config)
end

local function debug_test(testname, testpath, build_flags)
    local dap = load_module("dap")
    dap.run({
        type = "go",
        name = testname,
        request = "launch",
        mode = "test",
        program = testpath,
        args = { "-test.run", "^" .. testname .. "$" },
        buildFlags = build_flags,
    })
end

function M.debug_last_test()
    local testname = M.last_testname
    local testpath = M.last_testpath

    if testname == "" then
        vim.notify("no last run test found")
        return false
    end

    local msg = string.format("starting debug session '%s : %s'...", testpath, testname)
    vim.notify(msg)
    debug_test(testname, testpath, M.test_buildflags)

    return true
end






require('dap.ext.vscode').load_launchjs(nil, {})


dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end


vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })


vim.keymap.set('n', '<F5>', require 'dap'.continue)
vim.keymap.set('n', '<F10>', require 'dap'.step_over)
vim.keymap.set('n', '<F11>', require 'dap'.step_into)
vim.keymap.set('n', '<F12>', require 'dap'.step_out)
vim.keymap.set('n', '<leader>b', require 'dap'.toggle_breakpoint)

return M

