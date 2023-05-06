-- Keymaps
local function open_gitui()
	require("lazy.util").float_term("gitui", { height = 0.9, width = 0.9 })
end

vim.keymap.set("n", "<leader>gg", open_gitui, { desc = "GitUI", silent = true })
