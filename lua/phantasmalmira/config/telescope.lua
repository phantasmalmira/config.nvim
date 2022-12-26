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
  telescope.load_extension('file_browser')
  telescope.load_extension('fzf')
end