return {
  {
    "folke/noice.nvim",
    cond = function()
      return not vim.g.neovide
    end,
    opts = function(_, opts)
      opts.lsp = opts.lsp or {}
      opts.lsp.override = {
        -- override the default lsp markdown formatter with Noice
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        -- override the lsp markdown formatter with Noice
        ["vim.lsp.util.stylize_markdown"] = true,
        -- override cmp documentation with Noice (needs the other options to work)
        ["cmp.entry.get_documentation"] = true,
      }
    end,
  },
}
