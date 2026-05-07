return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "mason.nvim",
    { "mason-org/mason-lspconfig.nvim", config = function() end },
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "gfanto/fzf-lsp.nvim", opts = {} },
  },
  opts_extend = { "servers.*.keys" },
  keys = {
    { "gd", vim.lsp.buf.definition },
    { "ge", vim.lsp.buf.rename },
    { "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "Search LSP Implementations" },
    { "gr", "<cmd>Telescope lsp_references<cr>", desc = "Search LSP References" },
  },
  ---@class PluginLspOpts
  opts = {
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      },
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = " ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
    },
    inlay_hints = {
      enabled = false,
      exclude = {},
    },
    folds = {
      enabled = true,
    },
    format = {
      formatting_options = nil,
      timeout_ms = nil,
    },
    ---@type table<string, table|boolean>
    servers = {
      ["*"] = {
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
      },
      roslyn = {
        capabilities = {
          workspace = {
            didChangeWatchedFiles = { dynamicRegistration = false },
          },
        },
      },
      pylsp = {},
      sourcekit = {},
      tsserver = {},
      clangd = {},
      lua_ls = {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            completion = { callSnippet = "Replace" },
          },
        },
      },
    },
  },
  config = function(_, opts)
    -- diagnostics
    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

    -- LSP keymaps on attach (subset of LazyVim defaults; user has gd/gr/gi/ge as plugin-level keys)
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
      callback = function(args)
        local buf = args.buf
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc, silent = true })
        end
        map("n", "gI", vim.lsp.buf.implementation, "Goto Implementation")
        map("n", "gy", vim.lsp.buf.type_definition, "Goto Type Definition")
        map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
        map("n", "K", vim.lsp.buf.hover, "Hover")
        map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
        map("i", "<c-k>", vim.lsp.buf.signature_help, "Signature Help")
        map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
        map({ "n", "x" }, "<leader>cc", vim.lsp.codelens.run, "Run Codelens")
        map("n", "<leader>cC", vim.lsp.codelens.refresh, "Refresh & Display Codelens")
        map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")

        -- inlay hints toggle (per-buffer)
        if opts.inlay_hints.enabled and vim.lsp.inlay_hint then
          if not vim.tbl_contains(opts.inlay_hints.exclude or {}, vim.bo[buf].filetype) then
            vim.lsp.inlay_hint.enable(true, { bufnr = buf })
          end
        end

        -- folds
        if opts.folds.enabled and vim.lsp.foldexpr then
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client:supports_method("textDocument/foldingRange") then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
            vim.wo[win][0].foldmethod = "expr"
          end
        end
      end,
    })

    -- per-server config via vim.lsp.config / vim.lsp.enable
    if opts.servers["*"] then
      vim.lsp.config("*", opts.servers["*"])
    end

    local have_mason, mason_lspconfig = pcall(require, "mason-lspconfig")
    local mason_all = {}
    if have_mason then
      local ok, mappings = pcall(require, "mason-lspconfig.mappings")
      if ok then
        mason_all = vim.tbl_keys(mappings.get_mason_map().lspconfig_to_package or {})
      end
    end

    local mason_exclude = {}
    local mason_install = {}

    for server, sopts in pairs(opts.servers) do
      if server ~= "*" then
        sopts = sopts == true and {} or (not sopts) and { enabled = false } or sopts
        if sopts.enabled == false then
          mason_exclude[#mason_exclude + 1] = server
        else
          local use_mason = sopts.mason ~= false and vim.tbl_contains(mason_all, server)
          vim.lsp.config(server, sopts)
          if use_mason then
            mason_install[#mason_install + 1] = server
          else
            vim.lsp.enable(server)
          end
        end
      end
    end

    if have_mason then
      mason_lspconfig.setup({
        ensure_installed = mason_install,
        automatic_enable = { exclude = mason_exclude },
      })
    end
  end,
}
