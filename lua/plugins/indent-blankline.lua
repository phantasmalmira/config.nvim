return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      scope = {
        enabled = true,
        char = "│",
      },
      indent = {
        char = "│",
      },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
        },
      },
    },
    event = { "BufReadPost", "BufNewFile" },
  },
}
