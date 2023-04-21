return {
  {
    "anuvyklack/windows.nvim",
    dependencies = {
      "anuvyklack/middleclass",
    },
    opts = {
      ignore = {
        filetype = {
          "neo-tree",
          "NvimTree",
          "undotree",
          "gundo",
          "lspsagaoutline",
        },
      },
    },
    event = "BufWinEnter",
  },
}
