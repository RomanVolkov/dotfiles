return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    preset = "obsidian",
    file_types = { "markdown", "Avante" },
    heading = {
      enabled = false,
      width = "block",
    },
    ft = { "markdown" },
  },
  config = function(_, opts)
    require("render-markdown").setup(opts)

    -- Make code blocks ~30%-opacity-feeling: barely brighter than Normal bg.
    -- Terminals don't support alpha; we approximate by picking a color a few
    -- shades above the colorscheme's Normal background.
    local function soft_code_bg()
      local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
      local bg = normal.bg
      local subtle
      if bg then
        -- bump each channel by ~8/255 (~3%) for a faint highlight
        local r = math.min(255, bit.band(bit.rshift(bg, 16), 0xff) + 12)
        local g = math.min(255, bit.band(bit.rshift(bg, 8), 0xff) + 12)
        local b = math.min(255, bit.band(bg, 0xff) + 12)
        subtle = string.format("#%02x%02x%02x", r, g, b)
      else
        subtle = "#252535"
      end
      vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = subtle })
      vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", { bg = subtle })
    end
    soft_code_bg()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = vim.schedule_wrap(soft_code_bg),
    })
  end,
}
