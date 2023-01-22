return {
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      opts.signs = opts.signs or {}
      opts.signs.add = { text = "┃" }
      opts.signs.change = { text = "┃" }
      opts.signs.changedelete = { text = "┃" }
      opts.signs.untracked = { text = "┃" }
    end,
  },
}
