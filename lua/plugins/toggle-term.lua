return {
  {
    "akinsho/toggleterm.nvim",
    opts = {},
    event = { "VeryLazy" },
    keys = {
      { "<A-w>s", ":ToggleTerm direction=horizontal<CR>", desc = "ToggleTerm: Open below", silent = true },
      { "<A-w>v", ":ToggleTerm direction=vertical<CR>", desc = "ToggleTerm: Open right", silent = true },
      { "<A-w>z", ":ToggleTermToggleAll<CR>", desc = "ToggleTerm: Toggle all", silent = true },
    },
    cond = function()
      return vim.env["WEZTERM_PANE"] == nil
    end,
  },
}
