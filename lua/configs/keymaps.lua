-- Keymaps

vim.keymap.set("n", "<leader>l", ":Lazy<CR>", { desc = "Lazy", silent = true })

local function open_gitui()
	require("lazy.util").float_term("gitui", { height = 0.9, width = 0.9 })
end

vim.keymap.set("n", "<leader>gg", open_gitui, { desc = "GitUI", silent = true })

-- Resizing splits
local smart_splits = require("smart-splits")
vim.keymap.set("n", "<A-h>", smart_splits.resize_left)
vim.keymap.set("n", "<A-j>", smart_splits.resize_down)
vim.keymap.set("n", "<A-k>", smart_splits.resize_up)
vim.keymap.set("n", "<A-l>", smart_splits.resize_right)
-- moving between splits
vim.keymap.set("n", "<C-h>", smart_splits.move_cursor_left)
vim.keymap.set("n", "<C-j>", smart_splits.move_cursor_down)
vim.keymap.set("n", "<C-k>", smart_splits.move_cursor_up)
vim.keymap.set("n", "<C-l>", smart_splits.move_cursor_right)

vim.keymap.set("c", "<S-Enter>", function()
	require("noice").redirect(vim.fn.getcmdline())
end, { desc = "Redirect Cmdline" })
