return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources[#opts.sources + 1] = nls.builtins.diagnostics.markdownlint.with({
        extra_args = { "--config", vim.fn.stdpath("config") .. "/linter-config/markdownlint.jsonc" },
      })
      opts.sources[#opts.sources + 1] = nls.builtins.formatting.prettierd.with({
        filetypes = { "html", "markdown", "css", "scss", "less", "handlebars", "markdown.mdx", "graphql", "svelte" },
      })
    end,
  },
}
