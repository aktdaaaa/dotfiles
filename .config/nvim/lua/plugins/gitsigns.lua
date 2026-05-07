return {
  "lewis6991/gitsigns.nvim",
  event = { "BufNewFile", "BufReadPre" },
  opts = {},
  keys = {
    { "<leader>nh", "<cmd>Gitsigns next_hunk<cr>", desc = "next hunk" },
    { "<leader>ph", "<cmd>Gitsigns prev_hunk<cr>", desc = "prev hunk" },
    { "<leader>gb", "<cmd>Gitsigns blame<cr>",     desc = "show blame" },
  },
}
