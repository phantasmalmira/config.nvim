return {
  {
    "molecule-man/telescope-menufacture",
    lazy = true,
    config = function()
      require("telescope").load_extension("menufacture")
    end,
  },
}
