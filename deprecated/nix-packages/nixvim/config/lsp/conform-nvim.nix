{ pkgs, lib, ... }:

{
  plugins.conform-nvim = {
    enable = true;
    settings = {
      formatters_by_ft = {
        lua = [ "stylua" ];
        python = [ "black" ];
        javascript = [ "prettier" ];
        typescript = [ "prettier" ];
        css = [ "prettier" ];
        html = [ "prettier" ];
        json = [ "prettier" ];
        c = [ "clang-format" ];
        cpp = [ "clang-format" ];
        sh = [ "shfmt" ];
        nix = [ "nixfmt" ];
        go = [ "gofmt" ];
        rust = [ "rustfmt" ];
        "*" = [ "codespell" ];
        "_" = [
          "squeeze_blanks"
          "trim_whitespace"
        ];
      };
      format_on_save = {
        timeoutMs = 200;
        lspFallback = true;
      };
      format_after_save = {
        timeoutMs = 200;
        lspFallback = true;
      };
      log_level = "warn";
      notify_on_error = false;
      notify_no_formatters = false;
      formatters = {
        codespell = {
          command = lib.getExe pkgs.codespell;
          args = [ "--quiet-level=2" ];
        };
        shellcheck = {
          command = lib.getExe pkgs.shellcheck;
        };
        shfmt = {
          command = lib.getExe pkgs.shfmt;
        };
        shellharden = {
          command = lib.getExe pkgs.shellharden;
        };
        squeeze_blanks = {
          command = lib.getExe' pkgs.coreutils "cat";
        };
        prettier = {
          command = lib.getExe pkgs.prettier;
        };
        black = {
          command = lib.getExe pkgs.black;
        };
        stylua = {
          command = lib.getExe pkgs.stylua;
        };
        clang-format = {
          command = "${pkgs.clang-tools}/bin/clang-format";
        };
        gofmt = {
          command = lib.getExe pkgs.go;
        };
        rustfmt = {
          command = lib.getExe pkgs.rustfmt;
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<C-S-f>";
      action.__raw = ''
        function()
          require("conform").format({ timeout_ms = 200 })
        end
      '';
      options = {
        desc = "Format file with Conform";
      };
    }
  ];
}
