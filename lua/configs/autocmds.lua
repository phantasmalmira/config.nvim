-- Restore cursor position
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = "*",
  callback = function()
    local last_pos = vim.fn.line("'\"")
    local last_line = vim.fn.line("$")
    if last_pos > 1 and last_pos <= last_line then
      vim.cmd('normal! g`"')
    end
  end,
})
vim.api.nvim_create_user_command("Redir", function(ctx)
  local lines = vim.split(vim.api.nvim_exec(ctx.args, true), "\n", { plain = true })
  vim.cmd("new")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.opt_local.modified = false
end, { nargs = "+", complete = "command" })
