return {
  {
    "debugloop/telescope-undo.nvim",
    lazy = true,
    keys = {
      { "<leader>fu", ":Telescope undo<CR>", desc = "Find undo history", silent = true },
    },
    config = function()
      require("telescope").load_extension("undo")
    end,
  },
}
