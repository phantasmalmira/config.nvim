return function()
  local cp = require('catppuccin')
  local function borderless_telescope(flavor)
    local cpp = require("catppuccin.palettes").get_palette(flavor)

    return {
      TelescopeBorder = { fg = cpp.surface0, bg = cpp.surface0 },
      TelescopeSelectionCaret = { fg = cpp.flamingo, bg = cpp.surface1 },
      TelescopeMatching = { fg = cpp.peach },
      TelescopeNormal = { bg = cpp.surface0 },
      TelescopeSelection = { fg = cpp.text, bg = cpp.surface1 },
      TelescopeMultiSelection = { fg = cpp.text, bg = cpp.surface2 },

      TelescopeTitle = { fg = cpp.crust, bg = cpp.green },
      TelescopePreviewTitle = { fg = cpp.crust, bg = cpp.red },
      TelescopePromptTitle = { fg = cpp.crust, bg = cpp.mauve },

      TelescopePromptNormal = { fg = cpp.flamingo, bg = cpp.crust },
      TelescopePromptBorder = { fg = cpp.crust, bg = cpp.crust },
    }
  end
  cp.setup({
    transparent_background = true,
    integrations = {
      telescope = true,
    },
    highlight_overrides = {
      latte = borderless_telescope('latte'),
      frappe = borderless_telescope('frappe'),
      mocha = borderless_telescope('mocha'),
      macchiato = borderless_telescope('macchiato'),
    }
  })
  vim.api.nvim_command('colorscheme catppuccin-frappe')
end
