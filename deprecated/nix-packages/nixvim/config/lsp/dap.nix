{ pkgs, ... }:

{
  # For more details, please refer to
  # https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
  plugins.dap = {
    enable = true;
    # configurations = {
      # c = [
      #   {
      #     name = "Launch (current file)";
      #     type = "codelldb";
      #     request = "launch";
      #     program.__raw = ''
      #       function()
      #         return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      #       end
      #     '';
      #     args = [ ];
      #     cwd.__raw = "vim.fn.getcwd()";
      #     stopAtBeginningOfMainSubprogram = false;
      #   }
      # ];
      # cpp = [
      #   {
      #     name = "Launch (current file)";
      #     type = "codelldb";
      #     request = "launch";
      #     program.__raw = ''
      #       function()
      #         return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      #       end
      #     '';
      #     args = [ ];
      #     cwd.__raw = "vim.fn.getcwd()";
      #     stopAtBeginningOfMainSubprogram = false;
      #   }
      # ];
      # rust = [
      #   {
      #     name = "Launch (current file)";
      #     type = "codelldb";
      #     request = "launch";
      #     program.__raw = ''
      #       function()
      #         return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      #       end
      #     '';
      #     args = [ ];
      #     cwd.__raw = "vim.fn.getcwd()";
      #     stopAtBeginningOfMainSubprogram = false;
      #   }
      # ];
    # };
    adapters = {
      servers = {
      };
      executables = {
        gdb = {
          command = "gdb";
          args = [
            "--interpreter=dap"
            "--eval-command"
            "set print pretty on"
          ];
        };
        lldb = {
          command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
        };
      };
    };
    settings = { };

    signs = {
      dapBreakpoint = {
        linehl = "";
        text = "";
        texthl = "DapBreakpoint";
        numhl = "DapBreakpoint";
      };
      dapBreakpointCondition = {
        linehl = "DapBreakpointCondition";
        text = "";
        texthl = "DapBreakpointCondition";
        numhl = "DapBreakpointCondition";
      };
      dapBreakpointRejected = {
        linehl = "";
        text = "";
        texthl = "DapBreakpointRejected";
        numhl = "DapBreakpointRejected";
      };
      dapStopped = {
        linehl = "DapStopped";
        text = "";
        texthl = "DapStopped";
        numhl = "DapStopped";
      };
    };

  };

  plugins.dap-virtual-text = {
    enable = true;
  };

  plugins.dap-ui = {
    enable = true;
    settings = {
      layout = [
        {
          position = "left";
          size = 0.4;
          elements = [
            {
              id = "scopes";
              size = 0.5;
            }
            {
              id = "stacks";
              size = 0.2;
            }
            {
              id = "watches";
              size = 0.15;
            }
            {
              id = "breakpoints";
              size = 0.15;
            }
          ];
        }
        {
          position = "bottom";
          size = 0.2;
          elements = [
            {
              id = "repl";
              size = 0.3;
            }
            {
              id = "console";
              size = 0.7;
            }
          ];
        }
      ];
    };
  };

  plugins.dap-lldb = {
    enable = true;
    settings = {
      codelldb_path = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
    };
  };

  plugins.dap-python = {
    enable = true;
  };

  plugins.dap-go = {
    enable = true;
  };

  extraConfigLua = ''
    local dap = require('dap')
    local dapui = require('dapui')

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    -- dap.listeners.before.event_terminated.dapui_config = function()
    --   dapui.close()
    -- end
    -- dap.listeners.before.event_exited.dapui_config = function()
    --   dapui.close()
    -- end
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>du";
      action.__raw = "require('dapui').toggle";
      options.desc = "DAP: Toggle UI";
    }
    {
      mode = "n";
      key = "<leader>dg";
      action.__raw = "require('dap').continue";
      options.desc = " Start/Continue";
    }
    {
      mode = "n";
      key = "<leader>di";
      action.__raw = "require('dap').step_into";
      options.desc = " Step Into";
    }
    {
      mode = "n";
      key = "<leader>do";
      action.__raw = "require('dap').step_over";
      options.desc = " Step Over";
    }
    {
      mode = "n";
      key = "<leader>dO";
      action.__raw = "require('dap').step_out";
      options.desc = " Step Out";
    }
    {
      mode = "n";
      key = "<leader>dq";
      action.__raw = "require('dap').close";
      options.desc = "DAP: Close Session";
    }
    {
      mode = "n";
      key = "<leader>dQ";
      action.__raw = "require('dap').terminate";
      options.desc = " Terminate";
    }
    {
      mode = "n";
      key = "<leader>dr";
      action.__raw = "require('dap').restart_frame";
      options.desc = " Restart";
    }
    {
      mode = "n";
      key = "<leader>dc";
      action.__raw = "require('dap').run_to_cursor";
      options.desc = "󰆽 Run to Cursor";
    }
    {
      mode = "n";
      key = "<leader>dR";
      action.__raw = "require('dap').repl.toggle";
      options.desc = "DAP: Toggle Repl";
    }
    {
      mode = "n";
      key = "<leader>dh";
      action.__raw = "require('dap.ui.widgets').hover";
      options.desc = "DAP: Hover";
    }
    {
      mode = "n";
      key = "<leader>db";
      action.__raw = "require('dap').toggle_breakpoint";
      options.desc = "DAP: Breakpoints";
    }
    {
      mode = "n";
      key = "<leader>dB";
      action.__raw = ''
        function()
          local input = vim.fn.input 'Condition for breakpoint:'
          require('dap').set_breakpoint(input)
        end 
      '';
      options.desc = "DAP: Condition Breakpoint";
    }
    {
      mode = "n";
      key = "<leader>dC";
      action.__raw = "require('dap').clear_breakpoints";
      options.desc = "DAP: Clear Breakpoints";
    }
  ];
}
