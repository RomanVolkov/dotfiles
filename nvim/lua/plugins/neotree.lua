return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  keys = function()
    return {
      {
        "<leader>e",
        "<cmd>:Neotree reveal=true position=float toggle=true source=filesystem<CR>",
        desc = "Open NeoTree in floating window",
      },
    }
  end,
}
