return {
  {
    "akinsho/flutter-tools.nvim",
    ft = { "dart" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
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
      }
    end,
  },
}
