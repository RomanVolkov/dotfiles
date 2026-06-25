return {
  "saghen/blink.cmp",
  version = "*",
  dependencies = {
    "L3MON4D3/LuaSnip",
  },

  config = function()
    require("blink-cmp").setup({
      -- Disable signature help: Noice already handles LSP signatures.
      -- Letting both run causes fights and lockups.
      signature = { enabled = false },

      -- Disable cmdline completion entirely.
      -- Cmdline mode in Neovim is synchronous; a slow LSP or path query
      -- here hard-locks the editor. Native cmdline completion is safer.
      cmdline = { enabled = false },

      snippets = { preset = "luasnip" },

      keymap = {
        -- Close popup on Enter, then fallback to normal <CR> behavior.
        ["<CR>"] = { "cancel", "fallback" },
        -- Accept selected completion.
        ["<C-y>"] = { "accept", "fallback" },
        -- Cancel / close popup.
        ["<C-e>"] = { "cancel", "fallback" },
        -- Trigger completion list.
        ["<C-Space>"] = { "show", "fallback" },
        -- Navigate list.
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        -- Focus the documentation popup so you can scroll it with j/k.
        ["<C-k>"] = { "show_documentation", "fallback" },
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = {
            -- Fail fast if the LSP is slow. A hanging LSP request inside
            -- the completion path is a common cause of insert-mode lockups.
            timeout_ms = 200,
          },
          buffer = {
            -- When an LSP client is attached, don't clutter the menu with
            -- buffer word completions — LSP suggestions are far more relevant.
            enabled = function()
              return #vim.lsp.get_clients({ bufnr = 0 }) == 0
            end,
            -- Don't index huge files or buffers. The buffer source walks
            -- all words in all listed buffers; on large files this blocks.
            opts = {
              max_size = 1024 * 1024, -- 1 MB
              get_bufnrs = function()
                return vim.tbl_filter(function(buf)
                  local ok, byte_size = pcall(function()
                    return vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
                  end)
                  return ok and byte_size and byte_size < 1024 * 1024
                end, vim.api.nvim_list_bufs())
              end,
            },
          },
        },
      },

      completion = {
        list = {
          -- Cap the menu size so a chatty LSP or huge buffer can't
          -- flood the UI and cause redraw stalls.
          max_items = 200,
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
        trigger = {
          prefetch_on_insert = false,
          -- Don't re-trigger the menu when backspacing. This avoids
          -- rapid query/response loops that can destabilise the UI.
          show_on_backspace = false,
        },
        accept = {
          create_undo_point = true,
          auto_brackets = { enabled = true },
        },
        ghost_text = {
          -- Explicitly disabled. Ghost text competes with LSP inlay
          -- hints and can leave orphaned virtual text on mode changes.
          enabled = false,
        },
        menu = {
          draw = {
            components = {
              kind_icon = {
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
              kind = {
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 50,
        },
      },

      fuzzy = {
        sorts = {
          "exact",
          "score",
          "sort_text",
        },
      },
    })
  end,
}
