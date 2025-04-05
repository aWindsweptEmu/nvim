return {
  'nvim-telescope/telescope.nvim', tag = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    {
      "<leader>ff",
      function()
        require('telescope.builtin').find_files()
      end,
      desc = "Telescope find files",
    },
  },
}
