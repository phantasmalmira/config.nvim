return function()
  -- LSP settings.
  local on_attach = require('phantasmalmira.helpers.lspconfig').on_attach

  -- Enable the following language servers
  --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --
  --  Add any additional override configuration in the following tables. They will be passed to
  --  the `settings` field of the server config. You must look up that documentation yourself.
  local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    -- tsserver = {},

    sumneko_lua = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  }

  -- Setup neovim lua configuration
  require('neodev').setup()
  --
  -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

  -- Setup mason so it can manage external tooling
  require('mason').setup()

  -- Ensure the servers above are installed
  local mason_lspconfig = require 'mason-lspconfig'

  mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
  }

  mason_lspconfig.setup_handlers {
    function(server_name)
      require('lspconfig')[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
      }
    end,
  }

  -- Turn on lsp status information
  local progress_tasks = {}
  local notify = require('notify')

  local function notify_lsp(_, msg, info)
    local task = msg.token
    local val = msg.value

    local client_key = info.client_id
    local client = vim.lsp.get_client_by_id(info.client_id)
    if not client then
      return
    end
    local client_name = client.name
    local progress = {
      message = '',
    }

    local notify_record = nil
    if not (progress_tasks[client_key] == nil) then
      notify_record = progress_tasks[client_key].notify
    else
      progress_tasks[client_key] = {}
    end

    if val.kind == 'begin' then
      progress_tasks[client_key].title = client_name .. ': ' .. val.title
      progress.message = 'Indexing started...'
    elseif val.kind == 'report' then
      if val.percentage then
        progress_tasks[client_key].percentage = val.percentage
      end
      if val.message then
        progress.message = val.message
      end
    elseif val.kind == 'end' then
      if progress_tasks[client_key].percentage then
        progress_tasks[client_key].percentage = 100
      end
      progress.message = 'Indexing completed!'
    end

    local notify_opts = {
      hide_from_history = true,
      timeout = 1000,
      title = progress_tasks[client_key].title,
    }
    if progress_tasks[client_key].percentage then
      notify_opts.title = notify_opts.title .. ' ' .. progress_tasks[client_key].percentage .. '%'
    end

    if not (notify_record == nil) then
      notify_opts.replace = notify_record
    else
      notify_opts.on_close = function()
        progress_tasks[client_key] = nil
      end
    end
    progress_tasks[client_key].notify = notify.notify(progress.message, 'INFO', notify_opts).id
  end

  vim.lsp.handlers['$/progress'] = notify_lsp
end
