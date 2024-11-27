return {
	lazy = true,
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	keys = {
		{ "<leader>e", "<cmd>Neotree toggle reveal<cr>", desc = "NeoTree" },
	},
	opts = {
		filesystem = {
			bind_to_cwd = false,
			follow_current_file = { enabled = true },
			use_libuv_file_watcher = true,
		},
	},
}
