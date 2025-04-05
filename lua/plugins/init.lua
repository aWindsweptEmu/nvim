return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup{}
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    config = function()
      vim.cmd([[colorscheme carbonfox]])
    end,
  },
}
