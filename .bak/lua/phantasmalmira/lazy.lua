-- Install lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

local lazy_config = {
  checker = {
    enabled = true,
  }
}

require('lazy').setup({
  -- Themes
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = require('phantasmalmira.config.catppuccin'),
  },
  {
    'nyoom-engineering/oxocarbon.nvim',
    lazy = true,
  },
  -- which-key
  {
    'folke/which-key.nvim',
    config = true,
    event = { 'VeryLazy' },
  },
  -- dressing.nvim
  {
    'stevearc/dressing.nvim',
    event = { 'VeryLazy' },
  },
  -- LSP neovim/nvim-lspconfig
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'j-hui/fidget.nvim',
      'folke/neodev.nvim',
    },
    event = { 'BufReadPre' },
    config = require('phantasmalmira.config.lspconfig'),
  },
  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'onsails/lspkind.nvim',
      'windwp/nvim-autopairs',
    },
    event = { 'InsertEnter' },
    config = require('phantasmalmira.config.nvim-cmp'),
  },
  -- tree-sitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
    config = require('phantasmalmira.config.treesitter'),
    event = { 'BufReadPre' },
  },
  -- Additional text objects via treesitter
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter' },
    event = { 'BufReadPre' },
  },
  -- Git related plugins
  {
    'tpope/vim-fugitive',
    event = { 'BufReadPre' },
  },
  {
    'tpope/vim-rhubarb',
    event = { 'BufReadPre' },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre' },
    config = require('phantasmalmira.config.gitsigns'),
  },
  -- lualine
  {
    'nvim-lualine/lualine.nvim',
    config = require('phantasmalmira.config.lualine'),
  },
  -- indentation guides
  {
    'lukas-reineke/indent-blankline.nvim',
    config = require('phantasmalmira.config.indent-blankline'),
  },
  -- commenting keys
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPre' },
    config = require('phantasmalmira.config.comment'),
  },
  -- tabstops auto-detection
  {
    'tpope/vim-sleuth',
    event = { 'BufReadPre' },
  },
  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    lazy = true,
    cmd = { 'Telescope' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = require('phantasmalmira.config.telescope'),
  },
  -- Telescope fuzzy file finder
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    build = function(_)
      local win32 = vim.fn.has('win32') == 1
      if win32 then
        vim.cmd('!cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build')
      else
        vim.cmd('!make')
      end
    end,
    lazy = true,
    config = require('phantasmalmira.config.telescope-fzf-native'),
  },
  -- Flutter tools
  {
    'akinsho/flutter-tools.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'mfussenegger/nvim-dap',
    },
    ft = { 'dart' },
    config = require('phantasmalmira.config.flutter-tools'),
  },
  -- nvim-telescope/telescope-file-browser.nvim
  {
    'nvim-telescope/telescope-file-browser.nvim',
    lazy = true,
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = require('phantasmalmira.config.telescope-file-browser'),
  },
  -- markdown-prview.nvim
  {
    'iamcco/markdown-preview.nvim',
    build = function() vim.fn['mkdp#util#install']() end,
    ft = { 'markdown' },
  },
  -- leap.nvim
  {
    'ggandor/leap.nvim',
    config = require('phantasmalmira.config.leap'),
  },
  -- barbar.nvim
  {
    'romgrk/barbar.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  -- alpha.nvim
  {
    'goolord/alpha-nvim',
    config = require('phantasmalmira.config.alpha'),
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  -- toggleterm.nvim
  {
    'akinsho/toggleterm.nvim',
    cmd = { 'ToggleTerm' },
    config = require('phantasmalmira.config.toggleterm'),
  },
  -- workspaces.nvim
  {
    'natecraddock/workspaces.nvim',
    lazy = true,
    config = require('phantasmalmira.config.workspaces'),
  },
  -- persistence.nvim
  {
    'folke/persistence.nvim',
    lazy = true,
    event = { 'BufReadPre' },
    config = function()
      require('persistence').setup()
    end,
  },
  -- nvim-tree.lua
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = { 'NvimTreeToggle' },
    config = require('phantasmalmira.config.nvim-tree'),
  },
  {
    'rcarriga/nvim-notify',
    config = require('phantasmalmira.config.nvim-notify'),
    lazy = true,
  },
  -- noice.nvim
  {
    'folke/noice.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    lazy = true,
    config = require('phantasmalmira.config.noice'),
  },
  -- nvim-autopairs
  {
    'windwp/nvim-autopairs',
    lazy = true,
    config = true,
  },
  -- nvim-dap
  {
    'mfussenegger/nvim-dap',
    dependencies = { 'nvim-telescope/telescope-dap.nvim', 'rcarriga/nvim-dap-ui' },
    lazy = true,
    config = require('phantasmalmira.config.nvim-dap'),
  },
  -- better-escape
  {
    'max397574/better-escape.nvim',
    config = require('phantasmalmira.config.better-escape'),
  },
  -- copilot
  {
    'zbirenbaum/copilot.lua',
    config = require('phantasmalmira.config.copilot'),
  }
}, lazy_config)