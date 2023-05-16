return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonUpdate", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    event = { "VeryLazy" },
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    build = ":MasonToolsInstall",
    cmd = { "MasonToolsInstall", "MasonToolsUpdate" },
    opts = {
      ensure_installed = {
        "gitui",
        "stylua",
        "rustfmt",
      },
    },
  },
}
