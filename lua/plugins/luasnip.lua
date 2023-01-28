return {
  {
    "L3MON4D3/LuaSnip",
    config = function(_, opts)
      local ls = require("luasnip")
      ls.setup(opts)

      -- Remove the current snippet when leaving the insert mode
      local unlinkgrp = vim.api.nvim_create_augroup("UnlinkSnippetOnModeChange", { clear = true })
      vim.api.nvim_create_autocmd("ModeChanged", {
        group = unlinkgrp,
        pattern = { "s:n", "i:*" },
        desc = "Forget the current snippet when leaving the insert mode",
        callback = function(evt)
          if ls.session and ls.session.current_nodes[evt.buf] and not ls.session.jump_active then
            ls.unlink_current()
          end
        end,
      })
    end,
  },
}
