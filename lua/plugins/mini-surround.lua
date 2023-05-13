return {
  {
    "echasnovski/mini.surround",
    keys = {
      { "gza", desc = "Add surround", mode = { "n", "v" } },
      { "gzd", desc = "Delete surround" },
      { "gzf", desc = "Find surround (right)" },
      { "gzF", desc = "Find surround (left)" },
      { "gzh", desc = "Highlight surround" },
      { "gzr", desc = "Replace surround" },
      { "gzn", desc = "Update n_lines" },
    },
    opts = {
      mappings = {
        add = "gza",
        delete = "gzd",
        find = "gzf",
        find_left = "gzF",
        highlight = "gzh",
        replace = "gzr",
        update_n_lines = "gzn",
      },
    },
    config = function(_, opts)
      require("mini.surround").setup(opts)
    end,
  },
}
