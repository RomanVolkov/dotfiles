-- Spell-fix UX for markdown (en + ru). Vim's z= works natively; this
-- layers a snacks.picker-based replacement flow on top and exposes
-- "add to user dict" / "mark as wrong" as keymaps. All bindings are
-- buffer-local on markdown/text/gitcommit so <leader>c* stays free
-- in code buffers.
--
-- Spell itself is enabled elsewhere:
--   lua/config/options.lua   — spelllang = { "ru", "en" }
--   lua/config/autocmds.lua  — FileType autocmd that sets `spell` on
--                              markdown/text/plaintex/typst/gitcommit.

local M = {}

function M.fix()
  local word = vim.fn.expand("<cword>")
  if word == "" then return end
  local suggestions = vim.fn.spellsuggest(word, 12)
  if vim.tbl_isempty(suggestions) then
    vim.notify("No spell suggestions for '" .. word .. "'", vim.log.levels.INFO)
    return
  end
  Snacks.picker.select(
    suggestions,
    { prompt = "Replace '" .. word .. "' with:" },
    function(choice)
      if not choice then return end
      vim.cmd("normal! ciw" .. choice)
      vim.cmd("stopinsert")
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
