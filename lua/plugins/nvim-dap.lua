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

      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end

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
      Utils.condexpr_keymap_set(
        "n",
        is_thread_paused,
        "J",
        '<Cmd>lua require("dap").eval()<CR>',
        { noremap = true, silent = true, desc = "Debug: Evaluate" }
      )
    end,
  },
}
