return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Debug: Continue / Launch",
      },
      {
        "<S-F5>",
        function()
          require("dap").restart()
        end,
        desc = "Debug: Restart",
      },
      {
        "<F6>",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Debug: Toggle Breakpoint",
      },
      {
        "<F9>",
        function()
          require("dap").step_into()
        end,
        desc = "Debug: Step into",
      },
      {
        "<S-F9>",
        function()
          require("dap").step_out()
        end,
        desc = "Debug: Step out",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "Debug: Step over",
      },
      {
        "<S-F10>",
        function()
          require("dap").step_back()
        end,
        desc = "Debug: Step back",
      },
      {
        "<F12>",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Debug: Toggle Repl",
      },
      {
        "<A-k>",
        function()
          require("dapui").eval()
        end,
      },
    },
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
      },
    },
    opts = {
      dapui = {},
    },
    config = function(_, opts)
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup(opts.dapui)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = "", texthl = "DapBreakpointRejected", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "", numhl = "" })
      require("dap.ext.vscode").load_launchjs()
    end,
  },
}
