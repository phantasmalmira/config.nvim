return {
  {
    "anuvyklack/windows.nvim",
    dependencies = {
      "anuvyklack/middleclass",
    },
    event = { "VeryLazy" },
    opts = {
      ignore = {
        buftype = { "quickfix" },
        filetype = { "NvimTree", "neo-tree", "undotree", "gundo", "dap*" },
      },
    },
  },
}
