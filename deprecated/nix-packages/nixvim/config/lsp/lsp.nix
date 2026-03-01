{ pkgs, ... }:

{
  plugins.lsp = {
    enable = true;
    keymaps = {
      diagnostic = {
        "g]" = "goto_prev";
        "g[" = "goto_next";
      };
      lspBuf = {
        "gr" = "references";
        "gD" = "declaration";
        "gd" = "definition";
        "gi" = "implementation";
        "gt" = "type_definition";
      };
    };

    servers = {
      clangd = {
        enable = true;
        package = pkgs.clang-tools;
        cmd = [
          "clangd"
          "--background-index"
          "--clang-tidy"
          "--completion-style=detailed"
          "--header-insertion=iwyu"
        ];
        rootMarkers = [
          "compile_commands.json"
          "compile_flags.txt"
          ".git"
        ];
        filetypes = [
          "c"
          "cpp"
          "objc"
          "objcpp"
        ];
      };
      gopls = {
        enable = true;
        package = pkgs.gopls;
        cmd = [
          "gopls"
          "serve"
        ];
        rootMarkers = [
          "go.mod"
          "go.work"
          ".git"
        ];
        filetypes = [
          "go"
          "gomod"
          "go.work"
          "go.tmpl"
        ];
      };

      pyright = {
        enable = true;
        package = pkgs.pyright;
        rootMarkers = [
          "pyproject.toml"
          "setup.py"
          "setup.cfg"
          "requirements.txt"
          ".git"
        ];
        filetypes = [ "python" ];
      };

      rust_analyzer = {
        enable = true;
        installCargo = false;
        installRustc = false;
        cmd = [
          "rust-analyzer"
        ];
        rootMarkers = [
          "Cargo.toml"
          ".git"
        ];
        filetypes = [ "rust" ];
      };

      nixd = {
        enable = true;
        package = pkgs.nixd;
        cmd = [
          "nixd"
        ];
        rootMarkers = [
          "flake.nix"
          "default.nix"
          ".git"
        ];
        filetypes = [ "nix" ];
      };

      tsgo = {
        enable = true;
        package = pkgs.typescript-go;
        cmd = [
          "tsgo"
          "--lsp"
          "--stdio"
        ];
        filetypes = [
          "typescript"
          "javascript"
          "typescriptreact"
          "javascriptreact"
        ];
        rootMarkers = [
          "package.json"
          "tsconfig.json"
          "jsconfig.json"
          ".git"
        ];
      };
    };
  };

  # keymaps = [
  #   {
  #     mode = "n";
  #     key = "K";
  #     action = "<cmd>lua vim.lsp.buf.hover()<CR>";
  #     options.desc = "Show hover information";
  #   }
  # ];
}
