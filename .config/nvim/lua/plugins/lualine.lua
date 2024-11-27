return {
	"nvim-lualine/lualine.nvim",

	dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
	event = { "VeryLazy", "BufNewFile", "BufRead" },
	options = { theme = "dracula" },
	opts = {
		sections = {
			lualine_c = {
				{ "filename", path = 1 }, -- 相対パスを表示 (絶対パスにしたい場合は path = 2)
			},
		},
	},
}
