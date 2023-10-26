return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      context_commentstring = {
        enable = true,
      },
      ensure_installed = {
        "lua",
        "javascript",
        "typescript",
        "jsdoc",
        "json",
      },
    },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter-context",
    },
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSUpdate" },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
