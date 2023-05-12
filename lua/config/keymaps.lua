local Util = require("lazyvim.util")

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>fw", function()
  require("workspaces")
  require("telescope").extensions.workspaces.workspaces()
end, { silent = true, desc = "Workspaces" })

vim.api.nvim_set_keymap(
  "n",
  "<C-T>",
  '<Cmd>exe v:count1 . "ToggleTerm"<CR>',
  { silent = true, desc = "Toggle Terminal" }
)

vim.api.nvim_set_keymap("n", "<leader>bp", "<Cmd>BufferLinePick<CR>", { silent = true, desc = "Pick Buffer" })
vim.api.nvim_set_keymap(
  "n",
  "<leader>bo",
  "<Cmd>%bd|e#|bd#<CR>",
  { silent = true, desc = "Close All Buffer Except Current" }
)

vim.keymap.set("n", "<leader>gt", function()
  Util.float_term({ "gitui" }, { cwd = Util.get_root() })
end, { desc = "GitUI (root dir)" })

vim.keymap.set("n", "<leader>gT", function()
  Util.float_term({ "gitui" })
end, { desc = "GitUI (cwd)" })

vim.keymap.set("n", "<leader>b/", function()
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    previewer = false,
  }))
end, { desc = "[/] Fuzzily search in current buffer" })

local smart_splits = require("smart-splits")
vim.keymap.set("n", "<C-h>", smart_splits.move_cursor_left, { silent = true, desc = "Smart split: Move cursor left" })
vim.keymap.set("n", "<C-j>", smart_splits.move_cursor_down, { silent = true, desc = "Smart split: Move cursor down" })
vim.keymap.set("n", "<C-k>", smart_splits.move_cursor_up, { silent = true, desc = "Smart split: Move cursor up" })
vim.keymap.set("n", "<C-l>", smart_splits.move_cursor_right, { silent = true, desc = "Smart split: Move cursor right" })
vim.keymap.set("n", "<M-h>", smart_splits.resize_left, { silent = true, desc = "Smart split: Resize left" })
vim.keymap.set("n", "<M-j>", smart_splits.resize_down, { silent = true, desc = "Smart split: Resize down" })
vim.keymap.set("n", "<M-k>", smart_splits.resize_up, { silent = true, desc = "Smart split: Resize up" })
vim.keymap.set("n", "<M-l>", smart_splits.resize_right, { silent = true, desc = "Smart split: Resize right" })
