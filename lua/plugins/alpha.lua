return {
  {
    "goolord/alpha-nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.buttons.val = {
        dashboard.button("n", "  > New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button(
          "c",
          "  > Continue previous session",
          ":lua require('persistence').load({last = true})<CR>"
        ),
        dashboard.button("w", "  > Workspaces", ":Telescope workspaces<CR>"),
        dashboard.button("f", "  > Find files", ":Telescope find_files<CR>"),
        dashboard.button("g", "  > Grep files", ":Telescope live_grep<CR>"),
        dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
        dashboard.button("l", "  > Lazy", ":Lazy<CR>"),
      }
      dashboard.section.footer.val = {
        require("lazy.stats").stats().startuptime,
      }
      return dashboard
    end,
    config = function(_, dashboard)
      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
}
