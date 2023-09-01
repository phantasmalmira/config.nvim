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
      ensure_installed = { "lua_ls", "rust_analyzer@nightly", "tailwindcss", "svelte" },
      automatic_installation = true,
      handlers = {
        -- Default handler
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = require("configs.lsp").capabilities(),
            on_attach = require("configs.lsp").on_attach,
          })
        end,
        ["rust_analyzer"] = function()
          require("rust-tools").setup({
            server = {
              capabilities = require("configs.lsp").capabilities(),
              on_attach = require("configs.lsp").on_attach,
              standalone = false,
              settings = {
                ["rust-analyzer"] = {
                  cargo = {
                    features = "all",
                  },
                },
              },
            },
          })
        end,
        ["tailwindcss"] = function()
          require("lspconfig")["tailwindcss"].setup({
            capabilities = require("configs.lsp").capabilities(),
            on_attach = require("configs.lsp").on_attach,
            root_dir = require("lspconfig").util.root_pattern(
              "tailwind.config.js",
              "tailwind.config.ts",
              "tailwind.config.cjs"
            ),
            filetypes = {
              "css",
              "scss",
              "sass",
              "postcss",
              "html",
              "javascript",
              "javascriptreact",
              "typescript",
              "typescriptreact",
              "svelte",
              "vue",
              "rust",
            },
            init_options = {
              userLanguages = {
                svelte = "html",
                vue = "html",
              },
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
    init = function()
      require("configs.lsp").register_on_attach(function(client, bufnr)
        if vim.lsp.inlay_hint then
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint(bufnr, true)
          end
        end
      end)
    end,
  },
}
