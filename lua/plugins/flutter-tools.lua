return {
  {
    "akinsho/flutter-tools.nvim",
    ft = { "dart" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = function()
      return {
        lsp = {
          color = {
            enabled = true,
          },
          on_attach = require("configs.lsp").on_attach,
          capabilities = require("configs.lsp").capabilities(),
        },
        debugger = {
          enabled = true,
          run_via_dap = true,
          register_configurations = function(paths)
            local dap = require("dap")
            local win32 = vim.fn.has("win32") == 1
            if win32 then
              dap.adapters.dart.options = dap.adapters.dart.options or {}
              -- Windows platform must not run dart DAP in detached
              dap.adapters.dart.options.detached = false
            end
            if next(dap.configurations.dart or {}) == nil then
              dap.configurations.dart = {
                {
                  type = "dart",
                  request = "launch",
                  name = "Flutter: Launch Debug",
                },
                {
                  type = "dart",
                  request = "launch",
                  name = "Flutter: Launch Profile",
                  flutterMode = "profile",
                },
                {
                  type = "dart",
                  request = "launch",
                  name = "Flutter: Launch Release",
                  flutterMode = "release",
                },
              }
            end
          end,
        },
      }
    end,
  },
}
