return {
  {
    "echasnovski/mini.comment",
    opts = {},
    keys = {
      { "gc", desc = "Comment", mode = { "n", "v" } },
      { "gc", desc = "Comment block", mode = { "o", "x" } },
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function(_, opts)
      require("mini.comment").setup(opts)
    end,
  },
}
