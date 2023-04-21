return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    cmd = {
      "NvimTreeToggle",
      "NvimTreeFindFile",
      "NvimTreeFocus",
      "NvimTreeCollapse",
    },
    keys = {
      {
        "<leader>fo",
        "<cmd>NvimTreeToggle<cr>",
        mode = "n",
        desc = "File browser (Working Directory)",
      },
      {
        "<leader>fO",
        "<cmd>NvimTreeFindFile<cr>",
        mode = "n",
        desc = "File browser (Buffer Directory)",
      },
    },
  },
}
