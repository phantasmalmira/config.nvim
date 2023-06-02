return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-frappe")
      vim.cmd.highlight("Folded", "guibg=#3b3f52")
    end,
    opts = {
      integrations = {
        cmp = true,
        gitsigns = true,
        neotree = true,
        telescope = true,
        notify = true,
        mini = true,
        alpha = true,
        leap = true,
        noice = true,
        lsp_trouble = true,
        which_key = true,
        indent_blankline = {
          enabled = true,
          colored_indent_levels = false,
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
        navic = {
          enabled = true,
          active = true,
        },
        dap = {
          enabled = true,
          enable_ui = true,
        },
      },
    },
  },
}
