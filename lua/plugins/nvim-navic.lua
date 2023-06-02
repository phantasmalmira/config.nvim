return {
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    opts = {},
    init = function()
      require("configs.lsp").register_on_attach(function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, bufnr)
        end
      end)
    end,
  },
}
