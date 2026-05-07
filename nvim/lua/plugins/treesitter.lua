local ensure_installed = {
  "bash",
  "c",
  "cpp",
  "diff",
  "dtd",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "jsonc",
  "lua",
  "luadoc",
  "luap",
  "markdown",
  "markdown_inline",
  "printf",
  "python",
  "query",
  "regex",
  "ruby",
  "rust",
  "swift",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
}

local function have_parser(lang)
  if not lang then
    return false
  end
  local ok = pcall(vim.treesitter.query.get, lang, "highlights")
  return ok
end

local big_file_max = 100 * 1024
local function is_big(buf)
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  return ok and stats and stats.size > big_file_max
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = ensure_installed,
    },
    config = function(_, opts)
      local TS = require("nvim-treesitter")
      TS.setup(opts)

      -- install missing parsers
      local installed = {}
      for _, p in ipairs(TS.get_installed("parsers") or {}) do
        installed[p] = true
      end
      local missing = {}
      for _, lang in ipairs(opts.ensure_installed or {}) do
        if not installed[lang] then
          missing[#missing + 1] = lang
        end
      end
      if #missing > 0 then
        TS.install(missing)
      end

      -- enable highlight, indent, folds per-buffer on FileType
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        callback = function(ev)
          if is_big(ev.buf) then
            return
          end
          local lang = vim.treesitter.language.get_lang(ev.match)
          if not have_parser(lang) then
            return
          end

          pcall(vim.treesitter.start, ev.buf)

          -- defer indent + folds so we run after vim's builtin ftplugins
          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(ev.buf) then
              return
            end
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

            local win = vim.api.nvim_get_current_win()
            if vim.api.nvim_win_get_buf(win) == ev.buf then
              vim.wo[win][0].foldmethod = "expr"
              vim.wo[win][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
            end
          end)
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    config = function()
      local move = require("nvim-treesitter-textobjects.move")
      local function map(key, fn, desc)
        vim.keymap.set({ "n", "x", "o" }, key, fn, { desc = desc, silent = true })
      end
      -- Function motion
      map("]f", function() move.goto_next_start("@function.outer", "textobjects") end, "Next Function Start")
      map("]F", function() move.goto_next_end("@function.outer", "textobjects") end, "Next Function End")
      map("[f", function() move.goto_previous_start("@function.outer", "textobjects") end, "Prev Function Start")
      map("[F", function() move.goto_previous_end("@function.outer", "textobjects") end, "Prev Function End")
      -- Class motion
      map("]c", function() move.goto_next_start("@class.outer", "textobjects") end, "Next Class Start")
      map("]C", function() move.goto_next_end("@class.outer", "textobjects") end, "Next Class End")
      map("[c", function() move.goto_previous_start("@class.outer", "textobjects") end, "Prev Class Start")
      map("[C", function() move.goto_previous_end("@class.outer", "textobjects") end, "Prev Class End")
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPre", "BufNewFile" },
    enabled = true,
    opts = { mode = "cursor", max_lines = 3 },
  },
}
