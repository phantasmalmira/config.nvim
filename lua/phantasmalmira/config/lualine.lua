return {
  options = {
    icons_enabled = true,
    globalstatus = true,
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    disabled_filetypes = { 'NvimTree' },
  },
  sections = {
    lualine_a = {
      {
        'mode',
        fmt = function (str)
          return str:sub(1,1)
        end
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
      {
        'location',
      },
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
