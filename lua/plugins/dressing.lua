return {
  {
    "stevearc/dressing.nvim",
    lazy = true,
    opts = {
      select = {
        get_config = function(opts)
          if opts.kind == "codeaction" then
            return {
              backend = "nui",
              nui = {
                position = {
                  row = 1,
                  col = 0,
                },
                relative = "cursor",
                max_width = 40,
              },
            }
          end
        end,
      },
    },
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },
}
