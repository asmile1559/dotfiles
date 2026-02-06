{
  imports = [
    ./colorscheme.nix
    ./clipboard.nix
    ./plugins
  ];

  config = {
    opts = {
      number = true;
      colorcolumn = "80"; # 80 column line

      cursorline = true; # cursorline highlight

      expandtab = false; # use space to replace tab
      tabstop = 4; # how many space a tab use
      shiftwidth = 4; # shift width
      softtabstop = 4; # how many space when type `tab`
      # wrap line
      wrap = false;

      hlsearch = false; # highlight search
      incsearch = true;
      ignorecase = true;
      smartcase = true;

      termguicolors = true; # terminal use 24bit colors

      signcolumn = "yes"; # when to draw a sign column
    };
  };
}
