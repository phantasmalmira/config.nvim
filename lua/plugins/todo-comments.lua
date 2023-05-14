return {
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo",
      },
      { "<leader>xt", ":TodoTrouble<CR>", desc = "Trouble: Todo", silent = true },
      { "<leader>xT", ":TodoTrouble keywords=TODO,FIX,FIXME<CR>", desc = "Trouble: Todo problems", silent = true },
    },
    opts = {},
  },
}
