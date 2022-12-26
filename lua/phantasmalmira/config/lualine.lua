return {
  options = {
    icons_enabled = true,
    globalstatus = true,
    theme = 'catppuccin',
    section_separators = { left = '', right = '' },
    component_separators = '|',
  },
  sections = {
    lualine_a = {
      {
        'mode',
        separator = { left = '' },
      },
    },
    lualine_b = {
      'filename',
      'branch',
      {
        'diagnostics',
        source = { 'nvim_diagnostic' },
        symbols = { error = ' ', warn = ' ', info = ' ' },
      },
    },
    lualine_c = { 'fileformat' },
    lualine_x = {},
    lualine_y = { 'filetype', 'progress' },
    lualine_z = {
      { 'location', separator = { right = '' }, left_padding = 2 },
    },
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  tabline = {},
}