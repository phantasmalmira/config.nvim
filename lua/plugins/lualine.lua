return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.section_separators = { left = "", right = "" }
      opts.options.component_separators = { left = "", right = "" }
      opts.sections.lualine_a[1] = {
        "mode",
        fmt = function(str)
          return str:sub(1, 1)
        end,
        separator = { left = " ", right = "" },
      }
      opts.sections.lualine_z = {
        {
          function()
            return " " .. os.date("%R")
          end,
          separator = { left = " ", right = " " },
        },
      }
    end,
  },
}
