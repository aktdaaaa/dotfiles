return {
  "lewis6991/gitsigns.nvim",
  event = { "BufNewFile", "BufRead" },
  opts = {},
  keys = {
    { "nh", "<cmd>Gitsigns next_hunk<cr>", desc = "next hunk" },
    { "ph", "<cmd>Gitsigns prev_hunk<cr>", desc = "prev hunk" },
  },
}
