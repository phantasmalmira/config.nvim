return {
  {
    "folke/neodev.nvim",
    lazy = true,
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "folke/neodev.nvim",
    },
    lazy = true,
    opts = {
      ensure_installed = { "lua_ls", "rust_analyzer@nightly" },
      automatic_installation = true,
      handlers = {
        -- Default handler
        function(server_name)
          local capabilities =
            vim.tbl_extend("keep", require("cmp_nvim_lsp").default_capabilities(), require("lsp-status").capabilities)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            on_attach = require("configs.lsp").on_attach,
          })
        end,
        ["rust_analyzer"] = function()
          local capabilities =
            vim.tbl_extend("keep", require("cmp_nvim_lsp").default_capabilities(), require("lsp-status").capabilities)
          require("rust-tools").setup({
            server = {
              capabilities = capabilities,
              on_attach = require("configs.lsp").on_attach,
            },
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
      "folke/neoconf.nvim",
    },
  },
}
