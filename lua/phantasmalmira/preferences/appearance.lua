-- Color scheme
require('catppuccin').setup({
  transparent_background = true,
  integrations = {
    telescope = true,
  },
})

-- Set colorscheme
vim.o.termguicolors = true
vim.api.nvim_command('colorscheme catppuccin-frappe')

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Enable linebreak
vim.o.linebreak = true

-- Scroll off
vim.o.scrolloff = 5

-- Disable default showmode
vim.o.showmode = false

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'