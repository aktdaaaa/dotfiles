return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  lazy = false,
  config = function()
    -- You can also use below = true here to to change the position of the printf
    -- statement (or set two remaps for either one). This remap must be made in normal mode.
    vim.keymap.set(
      "n",
      "<leader>rp",
      function() require('refactoring').debug.printf({ below = false }) end, { desc = "insert debug print" }
    )
    -- Print var
    vim.keymap.set({ "x", "n" }, "<leader>rv", function() require('refactoring').debug.print_var() end,
      { desc = "insert var debug print" })
    -- Supports both visual and normal mode
    vim.keymap.set("n", "<leader>rc", function() require('refactoring').debug.cleanup({}) end,
      { desc = "clear debug print" })
    -- Supports only normal mode
  end,
}
