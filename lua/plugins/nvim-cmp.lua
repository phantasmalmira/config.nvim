return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "zbirenbaum/copilot-cmp",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
    },
    opts = function()
      local cmp = require("cmp")
      local sources = {
        buffer = "[Buf]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        path = "[Path]",
        copilot = "[Copilot]",
      }
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            require("copilot_cmp.comparators").prioritize,

            -- Below is the default comparitor list and order for nvim-cmp
            cmp.config.compare.offset,
            -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        window = {
          completion = {
            side_padding = 0,
            max_width = 45,
            max_height = 20,
          },
          documentation = {
            max_width = 60,
            max_height = 20,
          },
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            local icons = require("lspkind").presets.codicons
            local item_kind = item.kind
            if icons[item_kind] then
              item.kind = icons[item_kind]
            else
              item.kind = " "
            end
            item.kind = " " .. item.kind .. " "
            local source_name = sources[entry.source.name] or "[?]"
            item.menu = source_name
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
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "copilot" },
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
      require("lspkind").presets.codicons.Copilot = ""
      require("cmp").setup(opts)

      vim.cmd.highlight("CmpItemAbbrDeprecated gui=strikethrough cterm=strikethrough")
      vim.cmd.highlight("CmpItemMenu guifg=#eebebe gui=italic cterm=italic")

      vim.cmd.highlight("CmpItemKind gui=reverse cterm=reverse")
      vim.cmd.highlight("CmpItemKindCopilot guifg=#81c8be gui=reverse cterm=reverse")
      vim.cmd.highlight("CmpItemKindDefault gui=reverse cterm=reverse")
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
