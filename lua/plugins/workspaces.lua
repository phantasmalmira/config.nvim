return {
  {
    "natecraddock/workspaces.nvim",
    cmd = {
      "WorkspacesAdd",
      "WorkspacesRemove",
      "WorkspacesRename",
      "WorkspacesList",
      "WorkspacesOpen",
    },
    config = function(_, opts)
      local workspaces = require("workspaces")
      workspaces.setup(opts)
      local telescope = require("telescope")
      telescope.load_extension("workspaces")
    end,
  },
}
