return {
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      char = "│",
      filetype_exclude = {
        "help",
        "alpha",
        "neo-tree",
        "Trouble",
        "lazy",
        "mason",
      },
      show_current_context = true,
    },
    event = { "BufReadPost", "BufNewFile" },
  },
}
