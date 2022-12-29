return function()
  local dashboard = require('dashboard')
  dashboard.custom_header = {
    ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
    ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
    ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
    ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
    ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
    ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
  }
  dashboard.hide_statusline = false
  dashboard.hide_tabline = false
  dashboard.hide_winbar = false
  dashboard.custom_center = {
    { icon = '  ',
      desc = 'Continue last session                   ',
      shortcut = 'SPC l s',
      action = function()
        require('persistence').load({ last = true })
      end },
    { icon = '  ',
      desc = 'New file                                ',
      action = 'DashboardNewFile',
      shortcut = 'SPC n f' },
    { icon = '  ',
      desc = 'Recently opened files                   ',
      action = 'Telescope oldfiles',
      shortcut = 'SPC f h' },
    { icon = '  ',
      desc = 'Workspaces                              ',
      action = 'Telescope workspaces',
      shortcut = 'SPC w w' },
    { icon = '  ',
      desc = 'Search File                             ',
      action = function() require('telescope.builtin').fd() end,
      shortcut = 'SPC s f' },
  }
end
