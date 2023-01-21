return {
  {
    "akinsho/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap",
    },
    ft = { "dart" },
    opts = {
      lsp = {
        colors = {
          enabled = true,
        },
      },
      debugger = {
        enabled = true,
        run_via_dap = true,
        register_configurations = function(_)
          local dap = require("dap")
          dap.adapters.dart.command = vim.fn.exepath("flutter")
          dap.adapters.dart.args = { "debug_adapter" }
          local win32 = vim.fn.has("win32") == 1
          if win32 then
            -- Windows platform must not run dart DAP in detached
            dap.adapters.dart.options.detached = false
          end
          require("dap.ext.vscode").load_launchjs()
        end,
      },
      dev_log = {
        enabled = false,
      },
    },
    config = function(_, opts)
      require("flutter-tools").setup(opts)
      require("telescope").load_extension("flutter")
    end,
  },
}
