local M = {}

M.capabilities = function()
  return vim.tbl_extend("keep", require("cmp_nvim_lsp").default_capabilities(), require("lsp-status").capabilities)
end

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
    ":Glance definitions<CR>",
    desc = "LSP: Definition",
  },
  {
    "gr",
    ":Glance references<CR>",
    desc = "LSP: References",
  },
  {
    "gt",
    ":Glance type_definitions<CR>",
    desc = "LSP: Type definitions",
  },
  {
    "gi",
    ":Glance implementations<CR>",
    desc = "LSP: Implementations",
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
  { "<leader>ca", vim.lsp.buf.code_action, desc = "LSP: Code Actions" },
}

local custom_on_attach = {}

M.register_on_attach = function(on_attach)
  custom_on_attach[#custom_on_attach + 1] = on_attach
end

M.unregister_on_attach = function(on_attach)
  for i = #custom_on_attach, 1, -1 do
    if custom_on_attach[i] == on_attach then
      table.remove(custom_on_attach, i)
    end
  end
end

M.on_attach = function(client, buffer)
  require("lsp-status").on_attach(client, buffer)
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

  for _, on_attach in ipairs(custom_on_attach) do
    on_attach(client, buffer)
  end
end

return M
