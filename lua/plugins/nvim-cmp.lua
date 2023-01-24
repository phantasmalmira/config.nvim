return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      local appended_source = {
        { name = "copilot" },
        unpack(opts.sources),
      }
      opts.sources = cmp.config.sources(appended_source)
      opts.formatting = {
        unpack(opts.formatting or {}),
        fields = { "kind", "abbr", "menu" },
        format = function(_, item)
          local icons = require("lazyvim.config").icons.kinds
          local item_kind = item.kind
          if icons[item_kind] then
            item.kind = icons[item_kind]
          else
            item.kind = " "
          end
          item.menu = item_kind
          return item
        end,
      }
      opts.window = opts.window or {}
      opts.window.completion = {
        border = "rounded",
        scrollbar = "║",
      }
      opts.window.documentation = {
        border = "rounded",
        scrollbar = "║",
      }
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
      vim.api.nvim_set_hl(0, "CmpItemMenu", { link = "String" })
    end,
  },
}
