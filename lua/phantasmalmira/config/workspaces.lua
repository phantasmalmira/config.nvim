return function()
  require('workspaces').setup({
    hooks = {
      open = function()
        require('persistence').load()
      end,
    },
  })
  require('telescope').load_extension('workspaces')
end