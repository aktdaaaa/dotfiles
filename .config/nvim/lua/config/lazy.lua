-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out =
      vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
-- タブを2文字幅に
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
-- 検索リセット
vim.keymap.set("n", "<Esc>", ":noh<CR><Esc>", { desc = "Clear search highlight" })

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- 行番号を表示する設定
vim.opt.number = true
vim.opt.clipboard:append({ "unnamedplus" })
vim.api.nvim_set_keymap(
  "n",
  "<c-h>",
  "<c-w>h",
  { desc = "Go to Left Window", noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<c-j>",
  "<c-w>j",
  { desc = "Go to Lower Window", noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<c-k>",
  "<c-w>k",
  { desc = "Go to Upper Window", noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<c-l>",
  "<c-w>l",
  { desc = "Go to Right Window", noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>qq",
  ":qa<cr>",
  { desc = "quit all", noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>bq",
  ":bdelete<cr>",
  { desc = "quit buffer", noremap = true, silent = true }
)
-- window
vim.api.nvim_set_keymap(
  "n",
  "<leader>wv",
  ":vsplit<cr>",
  { desc = "vertical split window", noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>wq",
  ":close<cr>",
  { desc = "close window", noremap = true, silent = true }
)
-- Yankした範囲をハイライトさせる
vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#553311" })
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "YankHighlight", timeout = 200 })
  end,
})

-- フォーマットコマンド
vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- install = { colorscheme = { "dracula" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- コマンドモードに入ったときだけignorecaseを有効化
vim.api.nvim_create_autocmd("CmdlineEnter", {
  callback = function()
    vim.opt.ignorecase = true
  end,
})

-- コマンドモードを抜けたらignorecaseを無効化
vim.api.nvim_create_autocmd("CmdlineLeave", {
  callback = function()
    vim.opt.ignorecase = false
  end,
})
