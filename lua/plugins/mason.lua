return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      opts.ensure_installed[#opts.ensure_installed + 1] = "markdownlint"
      opts.ensure_installed[#opts.ensure_installed + 1] = "prettierd"
    end,
  },
}
