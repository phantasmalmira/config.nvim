-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Appearance
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.conceallevel = 3

-- Set default shell
vim.opt.shell = "nu"
vim.opt.shellcmdflag = "-c"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""

vim.opt.autowrite = true
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.expandtab = true
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.ignorecase = true
vim.opt.inccommand = "nosplit"
vim.opt.laststatus = 3 -- global statusline
vim.opt.list = true
vim.opt.mouse = "a"
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.showmode = false
vim.opt.sidescrolloff = 16
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200
vim.opt.wildmode = "longest:full,full"
vim.opt.winminwidth = 5
vim.opt.splitkeep = "screen"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- Diagnostics
vim.diagnostic.config({
  float = {
    source = "if_many",
    border = "rounded",
    show_header = true,
  },
})
vim.fn.sign_define("DiagnosticSignError", {
  text = "",
  numhl = "DiagnosticSignError",
  texthl = "DiagnosticSignError",
})
vim.fn.sign_define("DiagnosticSignWarn", {
  text = "",
  numhl = "DiagnosticSignWarn",
  texthl = "DiagnosticSignWarn",
})
vim.fn.sign_define("DiagnosticSignInformation", {
  text = "",
  numhl = "DiagnosticSignInformation",
  texthl = "DiagnosticSignInformation",
})
vim.fn.sign_define("DiagnosticSignInfo", {
  text = "",
  numhl = "DiagnosticSignInfo",
  texthl = "DiagnosticSignInfo",
})
vim.fn.sign_define("DiagnosticSignHint", {
  text = "",
  numhl = "DiagnosticSignHint",
  texthl = "DiagnosticSignHint",
})

-- FIXME: this is a workaround for inconsistent file opening behavior on Windows
if vim.fn.has("win32") then
  local ori_fnameescape = vim.fn.fnameescape
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.fn.fnameescape = function(...)
    local result = ori_fnameescape(...)
    return result:gsub("\\", "/")
  end
end
