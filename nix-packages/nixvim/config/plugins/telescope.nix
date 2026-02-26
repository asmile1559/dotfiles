{
  plugins.telescope = {
    enable = true;

    settings = {
      # defaults = {
      #   layout_strategy = "horizontal";
      #   layout_config = {
      #     horizontal = {
      #       prompt_position = "top";
      #       preview_width = 0.55;
      #       results_width = 0.8;
      #     };
      #   };
      # };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>ff";
      action.__raw = "require('telescope.builtin').find_files";
      options = {
        desc = "Find files";
      };
    }
    {
      mode = "n";
      key = "<leader>fg";
      action.__raw = "require('telescope.builtin').live_grep";
      options = {
        desc = "Live grep";
      };
    }
    {
      mode = "n";
      key = "<leader>fb";
      action.__raw = "require('telescope.builtin').buffers";
      options = {
        desc = "Find buffers";
      };
    }
    {
      mode = "n";
      key = "<leader>fh";
      action.__raw = "require('telescope.builtin').help_tags";
      options = {
        desc = "Help tags";
      };
    }
  ];
}
