{
  plugins.tiny-inline-diagnostic = {
    enable = true;
    settings = {
      options = {
        show_source = {
          enable = true;
          if_many = true;
        };
        multilines.enabled = true;
        softwrap = 30;
        break_line = {
          enabled = true;
          after = 30;
        };
        add_messages = {
          message = true;
          display_count = true;
        };
        set_arrow_to_diag_color = true;
        enable_on_insert = true;
      };
      preset = "classic";
      virt_texts = {
        priority = 2048;
      };
    };
  };
}
