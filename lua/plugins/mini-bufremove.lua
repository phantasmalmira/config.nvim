return {
  {
    "echasnovski/mini.bufremove",
    opts = {},
    keys = {
      {
        "<leader>bd",
        function()
          require("mini.bufremove").delete(0, false)
        end,
        desc = "Delete buffer",
        silent = true,
      },
      {
        "<leader>bD",
        function()
          require("mini.bufremove").delete(0, true)
        end,
        desc = "Delete buffer (force)",
        silent = true,
      },
      {
        "<leader>bw",
        function()
          require("mini.bufremove").wipeout(0, false)
        end,
        desc = "Wipeout buffer",
        silent = true,
      },
      {
        "<leader>bW",
        function()
          require("mini.bufremove").wipeout(0, true)
        end,
        desc = "Wipeout buffer (force)",
        silent = true,
      },
      {
        "<leader>bo",
        function()
          local bufs = vim.api.nvim_list_bufs()
          local cur_buf = vim.api.nvim_get_current_buf()
          local mbr = require("mini.bufremove")

          for _, buf in pairs(bufs) do
            if buf ~= cur_buf and vim.api.nvim_buf_get_option(buf, "buftype") == "" then
              mbr.delete(buf, false)
            end
          end
        end,
        desc = "Delete all other buffers",
        silent = true,
      },
    },
    config = function(_, opts)
      require("mini.bufremove").setup(opts)
    end,
  },
}
