{
  opts = {
    # display line numbers
    number = true;
    colorcolumn = "80"; # display a vertical line at column 80

    cursorline = true; # highlight the line where the cursor is located

    expandtab = true; # use spaces instead of tabs
    tabstop = 2; # a tab character is displayed as {} spaces
    shiftwidth = 2; # autoindent and smartindent use this value to determine how many spaces to use for each level of indentation
    softtabstop = 2; # when pressing <Tab> in insert mode, insert this many spaces

    autoindent = true; # copy indent from current line when starting a new line
    smartindent = true; # add extra indentation in some cases, such as after an opening curly brace

    # wrap line
    wrap = false; # do not wrap long lines

    # search
    hlsearch = true; # highlight search
    incsearch = true; # show search matches as you type
    ignorecase = true;
    smartcase = true;

    # display
    termguicolors = true; # terminal use 24bit colors

    # show the sign column (used for diagnostics, git signs, etc.)
    signcolumn = "yes"; # when to draw a sign column, for debugging and git signs

    # split behavior
    splitbelow = true; # open horizontal splits below the current window
    splitright = true; # open vertical splits to the right of the current window

    list = true; # show whitespace characters
    listchars = {
      tab = "󰌒 "; # show tabs as ▸ followed by a space
      trail = "·"; # show trailing spaces as ·
    };
  };
}
