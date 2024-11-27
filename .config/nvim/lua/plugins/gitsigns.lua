return {
	"lewis6991/gitsigns.nvim",
	event = { "BufNewFile", "BufRead" },
	opts = {},
	keys = {
		{ "hn", "<cmd>Gitsigns next_hunk<cr>", desc = "next hunk" },
		{ "hp", "<cmd>Gitsigns prev_hunk<cr>", desc = "prev hunk" },
	},
}
