return {
  {
    "lukas-reineke/lsp-format.nvim",
    lazy = true,
    opts = {},
  },
  {
    "folke/neodev.nvim",
    lazy = true,
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "lukas-reineke/lsp-format.nvim",
      "folke/neodev.nvim",
    },
    lazy = true,
    opts = {
      ensure_installed = { "lua_ls", "rust_analyzer@nightly" },
      automatic_installation = true,
      handlers = {
        -- Default handler
        function(server_name)
          require("lspconfig")[server_name].setup({
            on_attach = require("lsp-format").on_attach,
          })
        end,
        ["rust_analyzer"] = function()
          require("rust-tools").setup({
            on_attach = require("lsp-format").on_attach,
          })
        end,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
  },
}
