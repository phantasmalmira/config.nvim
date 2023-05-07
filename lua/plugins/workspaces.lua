return {
  {
    "natecraddock/workspaces.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    event = { "VeryLazy" },
    cmd = {
      "WorkspacesAdd",
      "WorkspacesAddDir",
      "WorkspacesRemove",
      "WorkspacesRemoveDir",
      "WorkspacesRename",
      "WorkspacesList",
      "WorkspacesListDir",
      "WorkspacesOpen",
      "WorkspacesSyncDirs",
    },
    keys = {
      { "<leader>fw", ":Telescope workspaces<CR>", desc = "Find workspaces" },
    },
    opts = {
      hooks = {
        open_pre = {
          function()
            local workspaces = require("workspaces")
            local current_workspace = workspaces.name()
            if current_workspace then
              local persistence = require("persistence")
              persistence.save()
              persistence.stop()
            end
          end,
        },
        open = {
          function()
            local persistence = require("persistence")
            persistence.load()
            persistence.start()
          end,
        },
      },
    },
    config = function(_, opts)
      require("workspaces").setup(opts)
      require("telescope").load_extension("workspaces")
    end,
  },
}
