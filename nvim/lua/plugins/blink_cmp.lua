-- https://cmp.saghen.dev/recipes.html
return {
  "saghen/blink.cmp",
  enabled = true,
  -- In case there are breaking changes and you want to go back to the last
  -- working release
  -- https://github.com/Saghen/blink.cmp/releases
  version = "1.4.1",
  dependencies = {
    "moyiz/blink-emoji.nvim",
    "Kaiser-Yang/blink-cmp-dictionary",
  },

  config = function()
    require("blink-cmp").setup({
      keymap = {
        ["<CR>"] = {
          function(cmp)
            cmp.accept()
          end,
        },
        -- Manually invoke minuet completion.
        -- ["<A-y>"] = require("minuet").make_blink_map(),
        ["<Tab>"] = {
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
      },
      sources = {
        -- Enable minuet for autocomplete
        default = { "lsp", "path", "buffer", "snippets" },
        -- default = { "lsp", "path", "buffer", "snippets", "minuet" },
        -- For manual completion only, remove 'minuet' from default
        -- providers = {
        --   minuet = {
        --     name = "minuet",
        --     module = "minuet.blink",
        --     async = true,
        --     -- Should match minuet.config.request_timeout * 1000,
        --     -- since minuet.config.request_timeout is in seconds
        --     timeout_ms = 3000,
        --     score_offset = 50, -- Gives minuet higher priority among suggestions
        --   },
        -- },
      },
      -- Recommended to avoid unnecessary request
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
                -- (optional) use highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
              kind = {
                -- (optional) use highlights from mini.icons
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
          -- defaults
          "score",
          "sort_text",
        },
      },
    })
  end,
}
