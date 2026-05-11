-- Spell-fix UX for markdown / text / gitcommit (en + ru). Vim's z=
-- works natively; this layers a snacks.picker-based replacement flow
-- on top and exposes "add to user dict" / "mark as wrong" as keymaps.
--
-- Bindings are buffer-local on prose filetypes only — they don't
-- extend to code buffers where spell-in-comments is also active,
-- because the LSP setup binds <leader>c* on LspAttach (code action,
-- rename, codelens) and we don't want spell to shadow those.
--
-- Spell itself is enabled elsewhere:
--   lua/config/options.lua   — spelllang = { "ru", "en" }
--   lua/config/autocmds.lua  — FileType autocmd that sets `spell` on
--                              markdown/text/plaintex/typst/gitcommit,
--                              plus spell_in_comments for code files.
-- Native z= / zg / zw still work in code buffers if you want spell-fix
-- inside a code comment.

local M = {}

function M.fix()
  local word = vim.fn.expand("<cword>")
  if word == "" then return end
  local suggestions = vim.fn.spellsuggest(word, 12)
  if vim.tbl_isempty(suggestions) then
    vim.notify("No spell suggestions for '" .. word .. "'", vim.log.levels.INFO)
    return
  end

  -- Resolve the word's exact byte range under the cursor NOW, before
  -- the picker opens. `:normal! ciw` from inside the picker callback
  -- is unreliable (focus is on the picker buffer when the callback
  -- fires) and corrupts multi-word replacements like "signup" → "sign
  -- up". With a concrete byte range we can do a precise
  -- buf_set_text without depending on cursor or insert-mode mechanics.
  local buf = vim.api.nvim_get_current_buf()
  local row = vim.fn.line(".") - 1
  local col = vim.fn.col(".") - 1
  local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ""

  local s, e = nil, nil
  local search_from = 1
  while true do
    local fs, fe = line:find(word, search_from, true) -- literal match (handles utf-8 bytes)
    if not fs then break end
    if col + 1 >= fs and col + 1 <= fe then
      s, e = fs - 1, fe -- 0-based, end-exclusive
      break
    end
    search_from = fe + 1
  end
  if not s then return end

  Snacks.picker.select(
    suggestions,
    { prompt = "Replace '" .. word .. "' with:" },
    function(choice)
      if not choice then return end
      vim.api.nvim_buf_set_text(buf, row, s, row, e, { choice })
    end
  )
end

function M.add() vim.cmd("normal! zg") end -- add word to user dict
function M.bad() vim.cmd("normal! zw") end -- mark word as wrong

return {
  -- No actual plugin to load — this spec just gives lazy.nvim a hook
  -- to register the FileType autocmd after snacks has loaded
  -- (Snacks.picker.select needs to exist by the time M.fix runs).
  {
    "folke/snacks.nvim",
    optional = true,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "text", "gitcommit" },
        callback = function(ev)
          local function map(lhs, fn, desc)
            vim.keymap.set("n", lhs, fn,
              { buffer = ev.buf, silent = true, desc = desc })
          end
          map("<leader>cs", M.fix, "Spell: fix word (picker)")
          map("<leader>ca", M.add, "Spell: add to user dict")
          map("<leader>cw", M.bad, "Spell: mark as wrong")
        end,
      })
    end,
  },
}
