return {
  {
    "folke/noice.nvim",
    cond = function()
      return not vim.g.neovide
    end,
  },
}
