return {
  {
    "zbirenbaum/copilot.lua",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "zbirenbaum/copilot-cmp",
    },
    opts = {
      suggestion = {
        enabled = false,
      },
      panel = {
        enabled = false,
      },
    },
    event = "InsertEnter",
    config = function(_, opts)
      vim.schedule(function()
        require("lazyvim.config").icons.kinds.Copilot = " "
        require("copilot").setup(opts)
        vim.api.nvim_command("Copilot auth")
        require("copilot_cmp").setup()
      end)
    end,
  },
}
