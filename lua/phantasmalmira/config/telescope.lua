return function()
  local telescope = require('telescope')
  telescope.setup({
    defaults = {
      mappings = {
        i = {
          ['<C-u>'] = false,
          ['<C-d>'] = false,
        },
      },
    },
  })
  require('lazy').load({
    plugins = { 'telescope-fzf-native.nvim', 'telescope-file-browser.nvim', 'workspaces.nvim' }
  })
end
