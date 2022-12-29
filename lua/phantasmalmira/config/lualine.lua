return {
  options = {
    icons_enabled = true,
    globalstatus = true,
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    disabled_filetypes = { 'NvimTree', 'alpha' },
  },
  sections = {
    lualine_a = {
      {
        'mode',
        fmt = function(str)
          return str:sub(1, 1)
        end,
        separator = { left = ' ', right = '' },
      },
    },
    lualine_b = {
      {
        'filename',
      },
      {
        'branch',
      },
      {
        'diagnostics',
        source = { 'nvim_diagnostic' },
        symbols = { error = ' ', warn = ' ', info = ' ' },
      },
    },
    lualine_c = { 'fileformat' },
    lualine_x = {
      {
        require('lazy.status').updates,
        cond = require('lazy.status').has_updates,
        fmt = function(str)
          return str .. ' Updates'
        end
      },
    },
    lualine_y = {
      'filetype',
      'progress',
    },
    lualine_z = {
      {
        'location',
        separator = { left = ' ', right = ' ' }
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
