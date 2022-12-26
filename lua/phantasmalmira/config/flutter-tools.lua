return function() 
  require('flutter-tools').setup({
    lsp = {
      color = {
        enabled = true,
      },
    },
    on_attach = require('phantasmalmira.helpers.lspconfig').on_attach,
  })
  require('telescope').load_extension('flutter')
end