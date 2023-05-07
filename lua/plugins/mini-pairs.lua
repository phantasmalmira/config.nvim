return {
  {
    "echasnovski/mini.pairs",
    opts = {},
    event = { "InsertEnter" },
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
  },
}
