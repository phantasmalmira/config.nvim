local M = {}

M.format = function()
  local buf = vim.api.nvim_get_current_buf()
  local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
  local nls_formattable = package.loaded["null-ls"]
    and (#require("null-ls.sources").get_available(filetype, "NULL_LS_FORMATTING") > 0)
  vim.lsp.buf.format({
    bufnr = buf,
    filter = function(client)
      if nls_formattable then
        return client.name == "null-ls"
      end
      return client.name ~= "null-ls"
    end,
  })
end

M.diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

---@type (LazyKeys|{has?:string})[]
M.keymaps = {
  { "K", vim.lsp.buf.hover, desc = "LSP: Hover" },
  {
    "gd",
    function()
      require("definition-or-references").definition_or_references()
    end,
    desc = "LSP: Definition / References",
  },
  {
    "<leader>cr",
    function()
      require("inc_rename")
      return ":IncRename " .. vim.fn.expand("<cword>")
    end,
    desc = "LSP: Rename symbol",
    has = "rename",
    expr = true,
  },
  { "]d", M.diagnostic_goto(true), desc = "LSP: Next Diagnostic" },
  { "[d", M.diagnostic_goto(false), desc = "LSP: Prev Diagnostic" },
  { "]e", M.diagnostic_goto(true, "ERROR"), desc = "LSP: Next Error" },
  { "[e", M.diagnostic_goto(false, "ERROR"), desc = "LSP: Prev Error" },
  { "]w", M.diagnostic_goto(true, "WARN"), desc = "LSP: Next Warning" },
  { "[w", M.diagnostic_goto(false, "WARN"), desc = "LSP: Prev Warning" },
  { "<leader>cf", M.format, desc = "LSP: Format Document" },
}

M.on_attach = function(client, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = {} ---@type table<string,LazyKeys|{has?:string}>

  for _, value in ipairs(M.keymaps) do
    local keys = Keys.parse(value)
    if keys[2] == vim.NIL or keys[2] == false then
      keymaps[keys.id] = nil
    else
      keymaps[keys.id] = keys
    end
  end

  for _, keys in pairs(keymaps) do
    if not keys.has or client.server_capabilities[keys.has .. "Provider"] then
      local opts = Keys.opts(keys)
      ---@diagnostic disable-next-line: no-unknown
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys[1], keys[2], opts)
    end
  end

  if client.supports_method("textDocument/formatting") then
    local format_group = vim.api.nvim_create_augroup("LspFormat." .. buffer, {})
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = format_group,
      buffer = buffer,
      callback = function()
        M.format()
      end,
    })
  end
end

return M
