return function()
  local alpha = require('alpha')
  local dashboard = require('alpha.themes.dashboard')

  dashboard.section.header.val = {
    ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
    ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
    ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
    ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
    ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
    ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
  }

  dashboard.section.buttons.val = {
    dashboard.button('SPC n f', '  New file'),
    dashboard.button('SPC l s', '  Continue last session'),
    dashboard.button('SPC w w', '  Workspaces'),
    dashboard.button('SPC s f', '  Search files'),
    dashboard.button('SPC f h', '  Recently opened files'),
    dashboard.button('SPC p m', '  Plugin manager'),
  }

  alpha.setup(dashboard.opts)
  vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
  ]])

  -- Update footer
  local function update_footer(_)
    local alpha_opened = vim.bo.filetype == 'alpha'
    if not alpha_opened then
      return
    end
    local stats = require('lazy').stats()
    local footer = string.format('ﮫ %.2fms │  %d/%d', stats.startuptime, stats.loaded, stats.count)
    if require('lazy.status').has_updates() then
      footer = footer .. string.format(' │ %s updates', require('lazy.status').updates())
    end
    dashboard.section.footer.val = footer
    alpha.redraw(dashboard.opts)
  end

  local augroup = vim.api.nvim_create_augroup('AlphaFooter', { clear = true })
  vim.api.nvim_create_autocmd(
    'User',
    {
      group = augroup,
      pattern = { 'LazyVimStarted', 'LazyRender', 'LazyCheck', 'LazyUpdate' },
      callback = update_footer,
    }
  )
  vim.api.nvim_create_autocmd(
    'FileType',
    {
      group = augroup,
      pattern = { 'alpha' },
      callback = update_footer,
    }
  )

end
