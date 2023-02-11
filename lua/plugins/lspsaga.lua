return {
  {
    "glepnir/lspsaga.nvim",
    event = "BufReadPre",
    opts = {
      symbol_in_winbar = {
        enable = false,
      },
    },
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-tree/nvim-web-devicons",
    },
    init = function()
      local function prev_diagnostic(severity)
        return function()
          require("lspsaga.diagnostic"):goto_prev({ severity = severity })
        end
      end

      local function next_diagnostic(severity)
        return function()
          require("lspsaga.diagnostic"):goto_next({ severity = severity })
        end
      end

      local format = require("lazyvim.plugins.lsp.format").format

      require("lazyvim.plugins.lsp.keymaps")._keys = {
        { "<leader>cd", "<Cmd>Lspsaga show_cursor_diagnostics<CR>", desc = "Lspsaga: Cursor Diagnostics" },
        { "<leader>cl", "<Cmd>Lspsaga show_line_diagnostics<CR>", desc = "Lspsaga: Line Diagnostics" },
        { "gd", "<Cmd>Lspsaga goto_definition<CR>", desc = "Lspsaga: Goto Definition" },
        { "<leader>gd", "<Cmd>Lspsaga peek_definition<CR>", desc = "Lspsaga: Peek Definition" },
        { "<leader>cs", "<Cmd>Lspsaga lsp_finder<CR>", desc = "Lspsaga: Find Symbol" },
        {
          "<leader>ca",
          "<Cmd>Lspsaga code_action<CR>",
          desc = "Lspsaga: Code Actions",
          has = "codeAction",
          mode = { "n", "v" },
        },
        { "K", "<Cmd>Lspsaga hover_doc<CR>", desc = "Lspsaga: Hover Documentation" },
        { "[d", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "Lspsaga: Previous Diagnostic" },
        { "]d", "<Cmd>Lspsaga diagnostic_jump_next<CR>", desc = "Lspsaga: Next Diagnostic" },
        { "[e", prev_diagnostic(vim.diagnostic.severity.ERROR), desc = "Lspsaga: Previous Error" },
        { "]e", next_diagnostic(vim.diagnostic.severity.ERROR), desc = "Lspsaga: Next Error" },
        { "[w", prev_diagnostic(vim.diagnostic.severity.WARN), desc = "Lspsaga: Previous Warning" },
        { "]w", next_diagnostic(vim.diagnostic.severity.WARN), desc = "Lspsaga: Next Warning" },
        { "<leader>cr", "<Cmd>Lspsaga rename<CR>", desc = "Lspsaga: Rename Symbol" },
        { "<leader>co", "<Cmd>Lspsaga outline<CR>", desc = "Lspsaga: Code Outline" },
        { "<leader>co", "<Cmd>Lspsaga outline<CR>", desc = "Lspsaga: Code Outline" },
        { "<leader>cf", format, desc = "Format Document", has = "documentFormatting" },
        { "<leader>cf", format, desc = "Format Range", mode = "v", has = "documentRangeFormatting" },
      }
    end,
  },
}
