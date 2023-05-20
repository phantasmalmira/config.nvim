-- Keymaps

local set = vim.keymap.set
set("n", "k", "gk", { silent = true, noremap = true })
set("n", "j", "gj", { silent = true, noremap = true })
local function open_gitui()
  require("lazy.util").float_term("gitui", { height = 0.9, width = 0.9 })
end

set("n", "<leader>gg", open_gitui, { desc = "GitUI", silent = true })

-- Resizing splits
local smart_splits = require("smart-splits")
set("n", "<A-h>", smart_splits.resize_left, { desc = "Resize pane: Left" })
set("n", "<A-j>", smart_splits.resize_down, { desc = "Resize pane: Down" })
set("n", "<A-k>", smart_splits.resize_up, { desc = "Resize pane: Up" })
set("n", "<A-l>", smart_splits.resize_right, { desc = "Resize pane: Right" })
-- moving between splits
set("n", "<C-h>", smart_splits.move_cursor_left, { desc = "Navigate pane: Right" })
set("n", "<C-j>", smart_splits.move_cursor_down, { desc = "Navigate pane: Right" })
set("n", "<C-k>", smart_splits.move_cursor_up, { desc = "Navigate pane: Right" })
set("n", "<C-l>", smart_splits.move_cursor_right, { desc = "Navigate pane: Right" })

set("c", "<S-Enter>", function()
  require("noice").redirect(vim.fn.getcmdline())
end, { desc = "Redirect Cmdline" })

set("n", "<leader>l", ":Lazy<CR>", { desc = "Lazy", silent = true })

-- Buffers
set("n", "H", ":bprev<CR>", { desc = "Previous buffer", silent = true })
set("n", "L", ":bnext<CR>", { desc = "Next buffer", silent = true })
set("n", "<leader>bb", ":b#<CR>", { desc = "Last used buffer", silent = true })
set("n", "<leader>bd", ":bd<CR>", { desc = "Delete buffer", silent = true })
set("n", "<leader>bD", ":bd!<CR>", { desc = "Delete buffer (force)", silent = true })
set("n", "<leader>bw", ":bw<CR>", { desc = "Wipeout buffer", silent = true })
set("n", "<leader>bW", ":bw!<CR>", { desc = "Wipeout buffer (force)", silent = true })
set("n", "<leader>bo", ":%bd|e#|bd#<CR>", { desc = "Delete all other buffers", silent = true })

-- Diagnostics
set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Open diagnostics at cursor" })

-- Utilities
set("n", "<leader>ft", function()
  require("lazy.util").float_term()
end, { desc = "Float terminal" })

-- Clear search with ESC
set({ "n", "i" }, "<Esc>", "<Cmd>noh<CR><Esc>", { desc = "Escape and clear search", silent = true })

-- Sane search
set({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { desc = "Next search match", silent = true, expr = true })
set({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { desc = "Prev search match", silent = true, expr = true })

-- Better indent
set("v", "<", "<gv", { desc = "Indent left", silent = true })
set("v", ">", ">gv", { desc = "Indent left", silent = true })

-- Escape terminal
set("t", "<Esc>", "<C-\\><C-n>", { desc = "Escape terminal" })

-- Better visual pasting
set("v", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = "Paste over visual selection", silent = true })
