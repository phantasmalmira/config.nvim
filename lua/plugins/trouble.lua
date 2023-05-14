return {
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble", "TroubleClose", "TroubleRefresh" },
    keys = {
      { "<leader>xx", ":TroubleToggle document_diagnostics<CR>", desc = "Trouble: Document", silent = true },
      { "<leader>xX", ":TroubleToggle workspace_diagnostics<CR>", desc = "Trouble: Workspace", silent = true },
      {
        "]x",
        function()
          require("trouble").next({ skip_groups = true, jump = true })
        end,
        desc = "Next trouble",
      },
      {
        "[x",
        function()
          require("trouble").previous({ skip_groups = true, jump = true })
        end,
        desc = "Previous trouble",
      },
    },
    opts = {},
  },
}
