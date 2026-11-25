return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    init = function()
      local map = vim.keymap.set
      local desc = function(d)
        return { desc = "DAP: " .. d }
      end
      local dap = require("dap")
      map("n", "<F9>", function()
        dap.continue()
      end, desc("Continue / Start"))
      map("n", "<F10>", function()
        dap.step_over()
      end, desc("Step Over"))
      map("n", "<F11>", function()
        dap.step_into()
      end, desc("Step Into"))
      map("n", "<F12>", function()
        dap.step_out()
      end, desc("Step Out"))

      map("n", "<leader>db", function()
        dap.toggle_breakpoint()
      end, desc("Toggle Breakpoint"))
      map("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, desc("Set Conditional Breakpoint"))

      map("n", "<leader>dc", function()
        dap.clear_breakpoints()
      end, desc("Clear Breakpoints"))
      map("n", "<leader>du", function()
        require("dapui").toggle()
      end, desc("Toggle DAP UI"))
      map("n", "<leader>dr", function()
        dap.repl.toggle()
      end, desc("Toggle REPL"))
      map("n", "<leader>dl", function()
        dap.run_last()
      end, desc("Run Last"))
      map("n", "<leader>de", function()
        dap.terminate()
      end, desc("Terminate"))

      vim.fn.sign_define("DapBreakpoint", {
        text = "●",
        texthl = "DiagnosticError",
        linehl = "",
        numhl = "DiagnosticError",
      })
      vim.fn.sign_define("DapBreakpointCondition", {
        text = "⊜",
        texthl = "DiagnosticWarn",
        linehl = "",
        numhl = "DiagnosticWarn",
      })
      vim.fn.sign_define("DapBreakpointRejected", {
        text = "⌀",
        texthl = "DiagnosticInfo",
        linehl = "",
        numhl = "DiagnosticInfo",
      })
      vim.fn.sign_define("DapLogPoint", {
        text = "◆",
        texthl = "DiagnosticHint",
        linehl = "",
        numhl = "DiagnosticHint",
      })
      vim.fn.sign_define("DapStopped", {
        text = "➜",
        texthl = "DiagnosticOk",
        linehl = "CursorLine",
        numhl = "CursorLineNr",
      })
    end,
    config = function()
      local dap = require("dap")

      dap.adapters.codelldb = {
        type = "executable",
        command = "codelldb",
      }

      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = true,
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {
      enabled = true,
      enabled_commands = false,
      highlight_changed_variables = true,
      highlight_new_as_changed = true,
      show_stop_reason = true,
      commented = false,
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    opts = {
      layout = {
        {
          {
            position = "left",
            size = 0.25,
            elements = {
              { id = "scopes", size = 0.4 },
              { id = "watches", size = 0.3 },
              { id = "stacks", size = 0.15 },
              { id = "breakpoints", size = 0.15 },
            },
          },
          {
            position = "bottom",
            size = 0.25,
            elements = {
              { id = "repl", size = 0.3 },
              { id = "console", size = 0.7 },
            },
          },
        },
      },
    },
    config = function(_, opts)
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup(opts)

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
}
