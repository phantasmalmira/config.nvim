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

require('lazy').setup({
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
    },
    event = { 'BufReadPre' },
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
  -- Themes
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = true,
    config = require('phantasmalmira.config.catppuccin'),
  },
  {
    'nyoom-engineering/oxocarbon.nvim',
    lazy = true,
  },
  -- lualine
  {
    'nvim-lualine/lualine.nvim',
    config = require('phantasmalmira.config.lualine'),
  },
  -- indentation guides
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'VeryLazy' },
    config = require('phantasmalmira.config.indent-blankline'),
  },
  -- commenting keys
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPre' },
    config = true,
  },
  -- tabstops auto-detection
  {
    'tpope/vim-sleuth',
    event = { 'VeryLazy' },
  },
  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = { 'VeryLazy' },
    config = require('phantasmalmira.config.telescope'),
  },
  -- Telescope fuzzy file finder
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    event = { 'VeryLazy' },
  },
  -- Flutter tools
  {
    'akinsho/flutter-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = require('phantasmalmira.config.flutter-tools'),
  },
  -- nvim-telescope/telescope-file-browser.nvim
  {
    'nvim-telescope/telescope-file-browser.nvim',
    event = { 'VeryLazy' },
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
    event = { 'BufEnter' },
    config = require('phantasmalmira.config.leap'),
  },
  -- barbar.nvim
  {
    'romgrk/barbar.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  -- dashboard.nvim
  {
    'glepnir/dashboard-nvim',
    config = require('phantasmalmira.config.dashboard'),
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
    event = { 'VeryLazy' },
    config = require('phantasmalmira.config.workspaces'),
  },
  -- persistence.nvim
  {
    'folke/persistence.nvim',
    event = { 'VeryLazy' },
    config = function()
      require('persistence').setup()
    end,
  },
  -- nvim-tree.lua
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = require('phantasmalmira.config.nvim-tree'),
  },
  {
    'rcarriga/nvim-notify',
    config = require('phantasmalmira.config.nvim-notify'),
  },
  -- noice.nvim
  {
    'folke/noice.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    config = require('phantasmalmira.config.noice'),
  },
})
