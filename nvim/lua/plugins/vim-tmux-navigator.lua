return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", mode = { "n", "v", "t" } },
    { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", mode = { "n", "v", "t" } },
    { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", mode = { "n", "v", "t" } },
    { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", mode = { "n", "v", "t" } },
    { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", mode = { "n", "v", "t" } },
  },
}
