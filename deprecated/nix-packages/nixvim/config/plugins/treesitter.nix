{ pkgs, ... }:

{
  plugins.treesitter = {
    enable = true;
    highlight.enable = true;
    indent.enable = true;
    folding.enable = false;

    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      c
      cpp
      go
      rust
      java
      nix
      regex

      bash
      python
      javascript
      typescript
      lua

      html
      css

      make
      cmake
      dockerfile

      json
      xml
      yaml
      toml
    ];
  };
}
