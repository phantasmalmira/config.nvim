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

      vim.keymap.set(
        "n",
        "<F9>",
        dap.toggle_breakpoint,
        { noremap = true, silent = true, desc = "Debug: Toggle breakpoint" }
      )
      vim.keymap.set("n", "<F10>", dap.step_over, { noremap = true, silent = true, desc = "Debug: Step over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { noremap = true, silent = true, desc = "Debug: Step into" })
      vim.keymap.set("n", "<S-F11>", dap.step_out, { noremap = true, silent = true, desc = "Debug: Step out" })
      vim.keymap.set("n", "<F5>", dap.continue, { noremap = true, silent = true, desc = "Debug: Continue" })
      vim.keymap.set("n", "J", dapui.eval, { noremap = true, silent = true, desc = "Debug: Evaluate" })
    end,
  },
}
