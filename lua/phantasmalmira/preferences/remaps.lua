-- Helper function to create command abbreviations
local function abbr(from, to)
  vim.cmd('cnoreabbrev ' .. from .. ' ' .. to)
end

-- Map <Space> as leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
vim.api.nvim_set_keymap('n', '<Space>', '<Nop>', { silent = true })
vim.api.nvim_set_keymap('v', '<Space>', '<Nop>', { silent = true })

-- Quick open settings
vim.api.nvim_set_keymap('n', '<leader>.', '<Cmd>exe "e" stdpath("config") . "/init.lua"<CR>',
  { noremap = true, silent = true, desc = 'Open [.] init.lua' })

-- Package manager
vim.keymap.set('n', '<leader>pm', '<Cmd>Lazy<CR>', { desc = '[P]ackage [M]anager' })

-- Telescope built-ins
vim.keymap.set('n', '<leader>t', function() require('telescope.builtin').builtin({ include_extensions = true }) end,
  { silent = true, desc = '[T]elescope' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').oldfiles, { silent = true, desc = '[F]ile [H]istory' })
vim.keymap.set(
  'n',
  '<leader>/',
  function()
    require('telescope.builtin').current_buffer_fuzzy_find(
      require('telescope.themes').get_dropdown({
        previewer = false,
      })
    )
  end,
  { desc = '[/] Fuzzily search in current buffer]' }
)
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>cp', require('telescope.builtin').commands, { desc = '[C]ommand [P]alette' })

-- barbar.nvim
vim.keymap.set('n', '<A-b>', '<Cmd>exe "BufferGoto" . v:count1<CR>', { noremap = true, silent = true, desc = '[B]uffer' })
vim.keymap.set('n', '<leader>bl', '<Cmd>BufferLast<CR>', { noremap = true, silent = true, desc = '[B]uffer Last' })
vim.keymap.set('n', '<leader>bh', '<Cmd>BufferPrevious<CR>',
  { noremap = true, silent = true, desc = '[B]uffer Previous' })
vim.keymap.set('n', '<leader>bl', '<Cmd>BufferNext<CR>', { noremap = true, silent = true, desc = '[B]uffer Next' })
vim.keymap.set('n', '<leader>b,', '<Cmd>BufferMovePrevious<CR>',
  { noremap = true, silent = true, desc = '[B]uffer Move Previous' })
vim.keymap.set('n', '<leader>b.', '<Cmd>BufferMoveNext<CR>',
  { noremap = true, silent = true, desc = '[B]uffer Move Next' })
abbr('bq', 'BufferClose')
abbr('bqa', '%bd')
abbr('bqo', 'BufferCloseAllButCurrentOrPinned')

-- workspace.nvim
vim.keymap.set('n', '<leader>ww', require('telescope').extensions.workspaces.workspaces,
  { noremap = true, silent = true, desc = '[W]orkspaces' })

-- persistence.nvim
vim.keymap.set(
  'n',
  '<leader>ls',
  function()
    require('persistence').load({ last = true })
  end,
  { noremap = true, silent = true, desc = '[L]ast [S]ession' }
)

-- toggleterm.nvim
vim.keymap.set('n', '<leader>`', '<Cmd>exe v:count1 . "ToggleTerm"<CR>',
  { noremap = true, silent = true, desc = '[T]oggle [T]erminal' })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { silent = true })

-- alpha.nvim
vim.keymap.set('n', '<leader>nf', '<Cmd>ene<CR>', { noremap = true, silent = true, desc = '[N]ew [F]ile' })
vim.keymap.set('n', '<leader>db', '<Cmd>Alpha<CR>', { noremap = true, silent = true, desc = '[D]ashboard' })

-- telescope-file-browser.nvim
vim.keymap.set('n', '<leader>fb', require('telescope').extensions.file_browser.file_browser,
  { noremap = true, silent = true, desc = '[F]ile [B]rowser' })

-- diagnostics
vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev,
  { noremap = true, silent = true, desc = '[D]iagnostic [P]revious' })
vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next,
  { noremap = true, silent = true, desc = '[D]iagnostic [N]ext' })

-- nvim-tree
vim.keymap.set('n', '<leader>ft', '<Cmd>NvimTreeToggle<CR>', { noremap = true, silent = true, desc = '[F]ile [T]ree' })
