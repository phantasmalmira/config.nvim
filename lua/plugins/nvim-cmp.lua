return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
    },
    opts = function()
      local cmp = require("cmp")
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        window = {
          col_offset = -3,
          side_padding = 0,
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(_, item)
            local icons = require("lspkind").presets.codicons
            local item_kind = item.kind
            if icons[item_kind] then
              item.kind = icons[item_kind]
            else
              item.kind = " "
            end
            item.kind = " " .. item.kind .. " "
            item.menu = item_kind
            return item
          end,
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-s>"] = cmp.mapping.complete(),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        experimental = {
          ghost_text = {
            hl_group = "LspCodeLens",
          },
        },
      }
    end,
    config = function(_, opts)
      require("cmp").setup(opts)

      vim.cmd.highlight("CmpItemAbbrDeprecated gui=reverse cterm=reverse")
      vim.cmd.highlight("CmpItemAbbrMatch gui=reverse cterm=reverse")
      vim.cmd.highlight("CmpItemAbbrMatchFuzzy gui=reverse cterm=reverse")
      vim.cmd.highlight("CmpItemMenu gui=reverse cterm=reverse")

      vim.cmd.highlight("CmpItemKindField gui=reverse cterm=reverse")
      vim.cmd.highlight("CmpItemKindProperty gui=reverse cterm=reverse")
      vim.cmd.highlight("CmpItemKindEvent gui=reverse cterm=reverse")

      vim.cmd.highlight("CmpItemKindText gui=reverse cterm=reverse")
      vim.cmd.highlight("CmpItemKindEnum gui=reverse cterm=reverse")
      vim.cmd.highlight("CmpItemKindKeyword gui=reverse cterm=reverse")

      vim.cmd.highlight("CmpItemKindConstant gui=reverse cterm=reverse")
      vim.cmd.highlight("CmpItemKindConstructor gui=reverse cterm=reverse")
      vim.cmd.highlight("CmpItemKindReference gui=reverse cterm=reverse")

      vim.cmd.highlight("CmpItemKindFunction gui=reverse cterm=reverse")
      vim.cmd.highlight("CmpItemKindStruct gui=reverse cterm=reverse")
      vim.cmd.highlight("CmpItemKindClass gui=reverse cterm=reverse")
      vim.cmd.highlight("CmpItemKindModule gui=reverse cterm=reverse")
      vim.cmd.highlight("CmpItemKindOperator gui=reverse cterm=reverse")

      vim.cmd.highlight("CmpItemKindVariable gui=reverse cterm=reverse")
      vim.cmd.highlight("CmpItemKindFile gui=reverse cterm=reverse")

      vim.cmd.highlight("CmpItemKindUnit gui=reverse cterm=reverse")
      vim.cmd.highlight("CmpItemKindSnippet gui=reverse cterm=reverse")
      vim.cmd.highlight("CmpItemKindFolder gui=reverse cterm=reverse")

      vim.cmd.highlight("CmpItemKindMethod gui=reverse cterm=reverse")
      vim.cmd.highlight("CmpItemKindValue gui=reverse cterm=reverse")
      vim.cmd.highlight("CmpItemKindEnumMember gui=reverse cterm=reverse")

      vim.cmd.highlight("CmpItemKindInterface gui=reverse cterm=reverse")
      vim.cmd.highlight("CmpItemKindColor gui=reverse cterm=reverse")
      vim.cmd.highlight("CmpItemKindTypeParameter gui=reverse cterm=reverse")
    end,
  },
}
