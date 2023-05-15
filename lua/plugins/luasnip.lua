return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {},
    keys = {
      {
        "<Tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<Tab>"
        end,
        expr = true,
        silent = true,
        mode = "i",
        desc = "Jump to next snippet field if available",
      },
      {
        "<tab>",
        function()
          require("luasnip").jump(1)
        end,
        mode = "s",
        desc = "Jump to next snippet field",
      },
      {
        "<s-tab>",
        function()
          require("luasnip").jump(-1)
        end,
        mode = { "i", "s" },
        desc = "Jump to previous snippet field",
      },
    },
    config = function(_, opts)
      local ls = require("luasnip")
      ls.setup(opts)

      vim.api.nvim_create_autocmd({ "ModeChanged" }, {
        group = vim.api.nvim_create_augroup("ExitSnippetOnModeChange"),
        pattern = { "s:n", "i:*" },
        desc = "Exit snippet mode when changing modes",
        callback = function(evt)
          if ls.session and ls.session.current_nodes[evt.buf] and not ls.session.jump_active then
            ls.unlink_current()
          end
        end,
      })
    end,
  },
}
