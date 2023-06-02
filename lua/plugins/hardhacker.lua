return {
  {
    "hardhackerlabs/theme-vim",
    name = "hardhacker",
    cond = false,
    init = function()
      vim.g.hardhacker_darker = 1
      vim.g.hardhacker_hide_tilde = 1
      vim.g.hardhacker_keyword_italic = 1
    end,
    config = function()
      vim.cmd.colorscheme("hardhacker")
      vim.cmd.highlight("DiffAdd", "guibg=NONE guifg=LightGreen")
      vim.cmd.highlight("DiffChange", "guibg=NONE guifg=Gold")
      vim.cmd.highlight("DiffRemove", "guibg=NONE guifg=LightCoral")
      vim.cmd("highlight! link FoldColumn Comment")
    end,
  },
}
