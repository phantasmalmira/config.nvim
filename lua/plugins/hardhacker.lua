return {
  {
    "hardhackerlabs/theme-vim",
    name = "hardhacker",
    priority = 100,
    lazy = true,
    init = function()
      vim.g.hardhacker_darker = 1
      vim.g.hardhacker_hide_tilde = 1
      vim.g.hardhacker_keyword_italic = 1
    end,
  },
}
