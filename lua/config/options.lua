--- Neovide settings
if vim.g.neovide then
  vim.opt.guifont = { "FiraCode NF Retina", ":h12" }
  vim.g.neovide_transparency = 0.97
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_cursor_animation_length = 0.15
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_refresh_rate = 144
end

-- Spelling language
vim.opt.spelllang = "en,cjk"
