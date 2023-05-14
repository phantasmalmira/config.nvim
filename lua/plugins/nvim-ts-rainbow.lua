return {
  {
    "mrjones2014/nvim-ts-rainbow",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    config = function(_, opts)
      require("nvim-treesitter.configs").setup({
        rainbow = opts,
      })
    end,
  },
}
