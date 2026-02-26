{
  plugins.neo-tree = {
    enable = true;
    settings = {
      close_if_last_window = false;
      enable_git_status = true;
      enable_diagnostics = true;

      open_files_do_not_replace_types = [
        "terminal"
        "trouble"
        "qf"
      ];

      open_files_use_relative_path = false;
      sort_case_insensitive = false;
      default_component_configs = {
        indent = {
          padding = 0;
          indent_size = 2;

          with_markers = true;
          ident_marker = "│";
          last_indent_marker = "└";
          highlight = "NeoTreeIndentMarker";

          with_expanders = true;
          expander_collapsed = "";
          expander_expanded = "";
          expander_highlight = "NeoTreeExpander";
        };
        icon = {
          folder_closed = "";
          folder_open = "";
          folder_empty = "";

          default = "";
          highlight = "NeoTreeFileIcon";
          use_filtered_colors = true;
        };
        modified = {
          symbol = "[+]";
          highlight = "NeoTreeModified";
        };
        name = {
          trailing_slash = false;
          use_filtered_colors = true;
          use_git_status_colors = true;
          highlight = "NeoTreeFileName";
        };
        git_status = {
          symbols = {
            added = "✚";
            modified = "";
            deleted = "✖";
            renamed = "";
            untracked = "";
            ignored = "";
            unstaged = "";
            staged = "";
            conflict = "";
          };
          file_size = {
            enable = true;
            width = 12;
            required_width = 64;
          };
          type = {
            enable = true;
            width = 10;
            required_width = 122;
          };
          last_modified = {
            enabled = true;
            width = 20; # width of the column
            required_width = 88; # min width of window required to show this column
          };
          created = {
            enabled = true;
            width = 20; # width of the column
            required_width = 110; # min width of window required to show this column
          };
          symlink_target = {
            enabled = false;
          };
        };
      };
      commands = [ ];

    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>:Neotree<cr>";
      options = {
        desc = "Toggle file explorer";
      };
    }
  ];
}
