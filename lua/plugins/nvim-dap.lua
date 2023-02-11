return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-telescope/telescope-dap.nvim",
      "rcarriga/nvim-dap-ui",
    },
    ft = { "dart" },
    config = function(_, _)
      local dap = require("dap")
      vim.api.nvim_set_hl(0, "DapBreakpoint", { link = "DiagnosticSignError" })
      vim.api.nvim_set_hl(0, "DapLogPoint", { link = "DiagnosticSignInfo" })
      vim.api.nvim_set_hl(0, "DapStopped", { link = "DiagnosticSignInfo" })

      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint", numhl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "ﳁ", texthl = "DapBreakpoint", numhl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpoint", numhl = "DapBreakpoint" })
      vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint", numhl = "DapLogPoint" })
      vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", numhl = "DapStopped" })

      local Utils = require("utils")

      vim.keymap.set(
        "n",
        "<F9>",
        dap.toggle_breakpoint,
        { noremap = true, silent = true, desc = "Debug: Toggle breakpoint" }
      )
      local function is_thread_paused()
        return dap.session() ~= nil and dap.session().stopped_thread_id ~= nil
      end
      Utils.condexpr_keymap_set(
        "n",
        is_thread_paused,
        "<F10>",
        '<Cmd>lua require("dap").step_over()<CR>',
        { noremap = true, silent = true, desc = "Debug: Step over" }
      )
      Utils.condexpr_keymap_set(
        "n",
        is_thread_paused,
        "<F11>",
        '<Cmd>lua require("dap").step_into()<CR>',
        { noremap = true, silent = true, desc = "Debug: Step into" }
      )
      Utils.condexpr_keymap_set(
        "n",
        is_thread_paused,
        "<S-F11>",
        '<Cmd>lua require("dap").step_out()<CR>',
        { noremap = true, silent = true, desc = "Debug: Step out" }
      )
      vim.keymap.set("n", "<F5>", dap.continue, { noremap = true, silent = true, desc = "Debug: Continue" })
      vim.keymap.set("n", "<F6>", dap.restart, { noremap = true, silent = true, desc = "Debug: Restart" })
      vim.keymap.set("n", "<S-F5>", dap.run_to_cursor, { noremap = true, silent = true, desc = "Debug: Run to cursor" })
      vim.keymap.set("n", "<F7>", dap.repl.toggle, { noremap = true, silent = true, desc = "Debug: Toggle Repl" })

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dap.repl.open({
          height = 10,
        })
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dap.repl.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dap.repl.close()
      end

      Utils.condexpr_keymap_set(
        "n",
        is_thread_paused,
        "J",
        '<Cmd>lua require("dap.ui.widgets").hover()<CR>',
        { noremap = true, silent = true, desc = "Debug: Evaluate" }
      )
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = "dap-float*",
        callback = function(ev)
          vim.keymap.set("n", "q", function()
            vim.api.nvim_buf_delete(ev.buf, {})
          end, {
            buffer = ev.buf,
            remap = true,
          })
        end,
      })
      vim.api.nvim_create_autocmd({ "WinLeave" }, {
        pattern = "dap-hover-*",
        callback = function(ev)
          vim.api.nvim_buf_delete(ev.buf, {})
        end,
      })
    end,
  },
}
