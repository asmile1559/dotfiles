{
  plugins.oil = {
    enable = true;
    settings = {
      columns = [
        "icon"
        "permissions"
        "size"
        "mtime"
      ];
      delete_to_trash = true;
      win_options = {
        signcolumn = "yes:2";
      };
      keymaps = {
        "<C-h>" = false;
        "<C-s>" = false;
        "<C-t>" = false;
      };
    };

  };

  plugins.oil-git-status = {
    enable = true;
    settings = {
      show_ignored = true;
      symbols.__raw = ''
        {
          index = {
            ["!"] = "!",
            ["?"] = "?",
            ["A"] = "A",
            ["C"] = "C",
            ["D"] = "D",
            ["M"] = "M",
            ["R"] = "R",
            ["T"] = "T",
            ["U"] = "U",
            [" "] = " ",
          },
          working_tree = {
            ["!"] = "!",
            ["?"] = "?",
            ["A"] = "A",
            ["C"] = "C",
            ["D"] = "D",
            ["M"] = "M",
            ["R"] = "R",
            ["T"] = "T",
            ["U"] = "U",
            [" "] = " ",
          },
        }
      '';
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "-";
      action = "<cmd>Oil<CR>";
      options.desc = "Open parent directory in Oil";
    }
  ];
}
