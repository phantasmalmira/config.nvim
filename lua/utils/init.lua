local M = {}

M.condexpr_keymap_set = function(mode, cond, lhs, rhs, opts)
  local is_cond_func = type(cond) == "function"
  local mapped = function()
    local cond_res = cond
    if is_cond_func then
      cond_res = cond()
    end

    if cond_res then
      return rhs
    else
      return lhs
    end
  end
  local merge_opts = vim.tbl_extend("force", opts or {}, { expr = true })
  vim.keymap.set(mode, lhs, mapped, merge_opts)
end

return M
