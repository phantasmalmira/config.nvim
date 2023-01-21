-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>fw", function()
  require("workspaces")
  require("telescope").extensions.workspaces.workspaces()
end, { silent = true, desc = "Workspaces" })

vim.api.nvim_set_keymap(
  "n",
  "<A-t>",
  '<Cmd>exe v:count1 . "ToggleTerm"<CR>',
  { silent = true, desc = "Toggle Terminal" }
)
