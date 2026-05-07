return {
  "saghen/blink.cmp",
  version = "*",
  dependencies = {
    "moyiz/blink-emoji.nvim",
    "Kaiser-Yang/blink-cmp-dictionary",
    "L3MON4D3/LuaSnip",
  },

  config = function()
    require("blink-cmp").setup({
      snippets = { preset = "luasnip" },
      keymap = {
        ["<CR>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "snippet_forward",
          "fallback",
        },
        ["<Tab>"] = {
          function(cmp)
            return cmp.select_next()
          end,
          "fallback",
        },
        ["<S-Tab>"] = {
          function(cmp)
            return cmp.select_prev()
          end,
          "fallback",
        },
      },
      sources = {
        -- Drop the buffer (plain-text) source whenever an LSP client is
        -- attached, so suggestions come from the language server only.
        default = function()
          if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
            return { "lsp", "path", "snippets" }
          end
          return { "path", "buffer", "snippets" }
        end,
      },
      completion = {
        list = {
          selection = {
            preselect = true,
            auto_insert = true,
          },
        },
        trigger = { prefetch_on_insert = false },
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
