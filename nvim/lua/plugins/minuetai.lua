-- https://github.com/milanglacier/minuet-ai.nvim
return {
  "milanglacier/minuet-ai.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
  },
  enabled = false,
  config = function()
    require("minuet").setup({
      virtualtext = {
        auto_trigger_ft = {},
        keymap = {
          -- accept whole completion
          accept = "<A-A>",
          -- accept one line
          accept_line = "<A-a>",
          -- accept n lines (prompts for number)
          -- e.g. "A-z 2 CR" will accept 2 lines
          accept_n_lines = "<A-z>",
          -- Cycle to prev completion item, or manually invoke completion
          prev = "<A-[>",
          -- Cycle to next completion item, or manually invoke completion
          next = "<A-]>",
          dismiss = "<A-e>",
        },
      },
    })
  end,
}
