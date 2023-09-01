return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 100,
    config = function(_, opts)
      require("catppuccin").setup(opts)
    end,
    opts = {
      custom_highlights = function()
        local colors = require("catppuccin.palettes").get_palette()
        if not colors then
          return {}
        end
        return {
          LspInlayHint = {
            bg = colors.surface1,
            fg = colors.flamingo,
            italic = true,
          },
          Folded = {
            bg = colors.crust,
          },
          HeirlineStatusNormal = {
            bg = colors.lavender,
            fg = colors.surface0,
          },
          HeirlineStatusInsert = {
            bg = colors.flamingo,
            fg = colors.surface0,
          },
          HeirlineStatusVisual = {
            bg = colors.mauve,
            fg = colors.surface0,
          },
          HeirlineStatusCommand = {
            bg = colors.peach,
            fg = colors.surface0,
          },
          HeirlineStatusSelect = {
            bg = colors.pink,
            fg = colors.surface0,
          },
          HeirlineStatusReplace = {
            bg = colors.red,
            fg = colors.surface0,
          },
          HeirlineStatusShell = {
            bg = colors.green,
            fg = colors.surface0,
          },
          HeirlineStatusTerminal = {
            bg = colors.teal,
            fg = colors.surface0,
          },
          HeirlineStatusGit = {
            bg = colors.yellow,
            fg = colors.surface0,
          },
          HeirlineStatusLsp = {
            bg = colors.maroon,
            fg = colors.surface0,
          },
        }
      end,
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
