return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    lazy = true,
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release ; cmake --build build --config Release ; cmake --install build --prefix build",
    config = function(_, _)
      require("telescope").load_extension("fzf")
    end,
  },
}
