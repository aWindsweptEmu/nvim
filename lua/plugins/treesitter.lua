return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = { "c", "cpp", "lua", "vim", "bash", "go", "html", "yaml", "json", "terraform" },
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
