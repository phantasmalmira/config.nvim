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
    opts = {
      hooks = {
        open = function()
          local persistence = require("persistence")
          persistence.load()
          persistence.start()
        end,
        open_pre = function()
          local persistence = require("persistence")
          persistence.stop()
          persistence.save()
        end,
      },
    },
    config = function(_, opts)
      local workspaces = require("workspaces")
      workspaces.setup(opts)
      local telescope = require("telescope")
      telescope.load_extension("workspaces")
    end,
  },
}
