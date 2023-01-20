return function()
  require('flutter-tools').setup({
    lsp = {
      color = {
        enabled = true,
      },
      on_attach = require('phantasmalmira.helpers.lspconfig').on_attach,
    },
    debugger = {
      enabled = true,
      run_via_dap = true,
      register_configurations = function(_)
        local dap = require('dap')
        dap.adapters.dart.command = vim.fn.exepath('flutter')
        dap.adapters.dart.args = { 'debug_adapter' }
        local win32 = vim.fn.has('win32') == 1
        if win32 then
          -- Windows platform must not run dart DAP in detached
          dap.adapters.dart.options.detached = false
        end
        dap.configurations.dart = {
          {
            type = 'dart',
            request = 'launch',
            name = 'Flutter Launch',
          },
        }
        require('dap.ext.vscode').load_launchjs()
      end,
    },
    dev_log = {
      enabled = false,
    },
  })
  require('telescope').load_extension('flutter')
end
