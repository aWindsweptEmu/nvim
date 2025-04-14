return {
	{
		"Mofiqul/vscode.nvim",
		config = function()
			vim.opt.background = "dark"
			require("vscode").setup({})
			vim.cmd([[colorscheme vscode]])
		end,
	},
}
