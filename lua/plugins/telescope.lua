return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = {
      "Telescope",
    },
    keys = {
      {
        "<leader><leader>",
        function()
          require("telescope").extensions.menufacture.find_files()
        end,
        desc = "Find files",
        silent = true,
      },
      {
        "<leader>fg",
        function()
          require("telescope").extensions.menufacture.live_grep()
        end,
        desc = "Grep files",
        silent = true,
      },
      {
        "<leader>ff",
        function()
          require("telescope").extensions.menufacture.find_files()
        end,
        desc = "Find files",
        silent = true,
      },
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Find files",
        silent = true,
      },
      {
        "<leader>/",
        function()
          require("telescope.builtin").current_buffer_fuzzy_find()
        end,
        desc = "Find in buffer",
        silent = true,
      },
      {
        "<leader>fr",
        function()
          require("telescope.builtin").resume()
        end,
        desc = "Find resume",
        silent = true,
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "natecraddock/workspaces.nvim",
      "debugloop/telescope-undo.nvim",
      "molecule-man/telescope-menufacture",
    },
    opts = {},
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    lazy = true,
    build = (function()
      local build_cmd =
        '"cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"'
      if vim.fn.has("win32") then
        return "cmd /c " .. build_cmd
      else
        return "sh -c " .. build_cmd
      end
    end)(),
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },
}
