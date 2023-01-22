return {
  {
    "rcarriga/nvim-notify",
    opts = function(_, opts)
      opts.background_color = "#000000"
    end,
    config = function(_, opts)
      require("notify").setup(opts)
      vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#000000" })
    end,
  },
}
