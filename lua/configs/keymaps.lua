-- Keymaps

vim.keymap.set("n", "k", "gk", { silent = true, noremap = true })
vim.keymap.set("n", "j", "gj", { silent = true, noremap = true })
local function open_gitui()
  require("lazy.util").float_term("gitui", { height = 0.9, width = 0.9 })
end

vim.keymap.set("n", "<leader>gg", open_gitui, { desc = "GitUI", silent = true })

-- Resizing splits
local smart_splits = require("smart-splits")
vim.keymap.set("n", "<A-h>", smart_splits.resize_left, { desc = "Resize pane: Left" })
vim.keymap.set("n", "<A-j>", smart_splits.resize_down, { desc = "Resize pane: Down" })
vim.keymap.set("n", "<A-k>", smart_splits.resize_up, { desc = "Resize pane: Up" })
vim.keymap.set("n", "<A-l>", smart_splits.resize_right, { desc = "Resize pane: Right" })
-- moving between splits
vim.keymap.set("n", "<C-h>", smart_splits.move_cursor_left, { desc = "Navigate pane: Right" })
vim.keymap.set("n", "<C-j>", smart_splits.move_cursor_down, { desc = "Navigate pane: Right" })
vim.keymap.set("n", "<C-k>", smart_splits.move_cursor_up, { desc = "Navigate pane: Right" })
vim.keymap.set("n", "<C-l>", smart_splits.move_cursor_right, { desc = "Navigate pane: Right" })

vim.keymap.set("c", "<S-Enter>", function()
  require("noice").redirect(vim.fn.getcmdline())
end, { desc = "Redirect Cmdline" })

vim.keymap.set("n", "<leader>l", ":Lazy<CR>", { desc = "Lazy", silent = true })
vim.keymap.set("n", "<leader><leader>", ":Telescope find_files<CR>", { desc = "Find files", silent = true })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Grep files", silent = true })
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files", silent = true })
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find files", silent = true })
vim.keymap.set("n", "<leader>fp", ":Telescope projects<CR>", { desc = "Find projects", silent = true })
