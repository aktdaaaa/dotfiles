return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = true,
  keys = {
    { "<leader><leader>", "<cmd>Telescope git_files<cr>",                 desc = "Telescope find files" },
    { "<leader>ff",       "<cmd>Telescope find_files<cr>",                desc = "Telescope find files" },
    { "<leader>fg",       "<cmd>Telescope live_grep<cr>",                 desc = "Telescope live grep" },
    { "<leader>fb",       "<cmd>Telescope buffers<cr>",                   desc = "Telescope buffers" },
    { "<leader>fh",       "<cmd>Telescope help_tags<cr>",                 desc = "Telescope help tags" },
    { "<leader>fo",       "<cmd>Telescope oldfiles<cr>",                  desc = "Telescope recent files" },
    { "<leader>fx",       "<cmd>Telescope diagnostics<cr>",               desc = "Telescope diagnostics" },
    { "<leader>fs",       "<cmd>Telescope git_status<cr>",                desc = "Telescope changed files (git)" },
    { "<leader>fq",       "<cmd>Telescope quickfix<cr>",                  desc = "Telescope quickfix" },
    { "<leader>/",        "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Telescope current buffer fuzzy find" },
  },
}
