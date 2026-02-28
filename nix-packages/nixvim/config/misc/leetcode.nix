{
  plugins.leetcode = {
    enable = true;
    settings = {
      lang = "c";
      cn = {
        enabled = true;
        translator = true;
        translate_problem = true;
      };
      storage = {
        cache = "~/Coding/leetcode/cache";
        home = "~/Coding/leetcode/questions";
      };
      plugins = {
        no-standalone = false;
      };
      logging = true;
      injector = { };
      cache = {
        update_interval = 60 * 60 * 24 * 7; # one week
      };
      editor = {
        reset_previous_code = true;
        fold_imports = true;
      };
      console = {
        open_on_runcode = true;
        dor = "row";
        size = {
          width = "90%";
          height = "75%";
        };
        result = {
          size = "60%";
        };
        testcase = {
          virt_text = true;
          size = "40%";
        };

        description = {
          position = "left";
          size = "40%";
          show_status = true;
        };
      };
    };
  };
}
