return function()
  local dap = require('dap')
  vim.keymap.set('n', '<leader>dbt', dap.toggle_breakpoint,
    { noremap = true, silent = true, desc = '[D]ebug [B]reakpoint [T]oggle' })
  vim.keymap.set('n', '<leader>dso', dap.step_over,
    { noremap = true, silent = true, desc = '[D]ebug [S]tep [O]ver' })
  vim.keymap.set('n', '<leader>dsi', dap.step_into,
    { noremap = true, silent = true, desc = '[D]ebug [S]tep [I]nto' })
  vim.keymap.set('n', '<leader>dsx', dap.step_out,
    { noremap = true, silent = true, desc = '[D]ebug [S]tep Out' })
  vim.keymap.set('n', '<F5>', dap.continue,
    { noremap = true, silent = true, desc = 'Debug Continue / Run' })
  vim.api.nvim_set_hl(0, 'DapBreakpoint', { link = 'DiagnosticSignError' })
  vim.api.nvim_set_hl(0, 'DapLogPoint', { link = 'DiagnosticSignInfo' })
  vim.api.nvim_set_hl(0, 'DapStopped', { link = 'DiagnosticSignInfo' })

  vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
  vim.fn.sign_define('DapBreakpointCondition', { text = 'ﳁ', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
  vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
  vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', numhl = 'DapLogPoint' })
  vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', numhl = 'DapStopped' })
  require('telescope').load_extension('dap')
  local dapui = require('dapui')
  dapui.setup()
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open({})
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close({})
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close({})
  end
end
