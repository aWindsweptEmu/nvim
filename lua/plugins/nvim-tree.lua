return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{
			"<leader>t",
			"<cmd>NvimTreeOpen<cr>",
			desc = "Nvim Tree Open",
		},
		{
			"<leader>c",
			"<cmd>NvimTreeClose<cr>",
			desc = "Nvim Tree Close",
		},
	},
	config = function()
		require("nvim-tree").setup()
	end,
}
