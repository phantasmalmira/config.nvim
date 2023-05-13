return {
  {
    "folke/trouble.nvim",
    event = { "LspAttach" },
    opts = {},
    config = function(_, opts)
      require("trouble").setup(opts)
      vim.keymap.set(
        "n",
        "<leader>cx",
        ":TroubleToggle document_diagnostics<CR>",
        { desc = "Code diagnostics", silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>cX",
        ":TroubleToggle workspace_diagnostics<CR>",
        { desc = "Code diagnostics (workspace)", silent = true }
      )
    end,
  },
}
