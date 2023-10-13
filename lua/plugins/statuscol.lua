return {
  {
    "luukvbaal/statuscol.nvim",
    event = { "VeryLazy" },
    opts = function()
      local builtin = require("statuscol.builtin")
      return {
        relculright = true,
        ft_ignore = {
          "neo-tree",
          "dapui_scopes",
          "dapui_breakpoints",
          "dapui_stacks",
          "dapui_watches",
          "dap-repl",
          "dapui_console",
          "alpha",
        },
        segments = {
          { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
          {
            sign = { name = { "Diagnostic", "Dap" }, maxwidth = 1 },
            click = "v:lua.ScSa",
          },
          { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
          {
            sign = { namespace = { "gitsigns" }, maxwidth = 1, auto = true },
            click = "v:lua.ScSa",
          },
        },
      }
    end,
  },
}
