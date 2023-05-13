return {
  {
    "natecraddock/workspaces.nvim",
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
      { "<leader>fw", ":Telescope workspaces<CR>", desc = "Find workspaces", silent = true },
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
            vim.api.nvim_command("%bw")
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
