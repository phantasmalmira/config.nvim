return {
  {
    "mrjones2014/smart-splits.nvim",
    opts = {},
    lazy = false,
    config = function(_, opts)
      local smart_splits = require("smart-splits")
      smart_splits.setup(opts)

      vim.keymap.set(
        "n",
        "<C-H>",
        smart_splits.move_cursor_left,
        { silent = true, desc = "Smart split: Move cursor left" }
      )
      vim.keymap.set(
        "n",
        "<C-J>",
        smart_splits.move_cursor_down,
        { silent = true, desc = "Smart split: Move cursor down" }
      )
      vim.keymap.set("n", "<C-K>", smart_splits.move_cursor_up, { silent = true, desc = "Smart split: Move cursor up" })
      vim.keymap.set(
        "n",
        "<C-L>",
        smart_splits.move_cursor_left,
        { silent = true, desc = "Smart split: Move cursor right" }
      )
    end,
  },
}
