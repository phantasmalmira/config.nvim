return {
  {
    "zbirenbaum/copilot.lua",
    lazy = true,
    opts = {
      panel = {
        enabled = false,
      },
      suggestion = {
        enabled = false,
      },
    },
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = {
      "zbirenbaum/copilot.lua",
    },
    lazy = true,
    opts = function()
      return {
        formatters = {
          insert_text = require("copilot_cmp.format").remove_existing,
        },
      }
    end,
  },
}
