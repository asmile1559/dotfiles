{
  keymaps = [
    # quit all and exit neovim
    {
      mode = "n"; # normal mode
      key = "<leader>q"; # key combination to trigger the mapping
      action = "<cmd>qa<CR>"; # command to execute when the mapping is triggered
      options.desc = "Quit all and exit neovim"; # description of the mapping
    }
    {
      mode = "n";
      key = "<leader>Q";
      action = "<cmd>qa!<CR>";
      options.desc = "Quit all and exit neovim without saving";
    }
    # save current buffer
    {
      mode = "n";
      key = "<leader>w";
      action = "<cmd>w<CR>";
      options.desc = "Save current buffer";
    }

    # window navigation
    {
      mode = "n";
      key = "<leader>sh";
      action = "<C-w>s";
      options.desc = "Split window and move to left window";
    }
    {
      mode = "n";
      key = "<leader>sv";
      action = "<C-w>v";
      options.desc = "Split window and move to right window";
    }

    # move current line up and down in visual mode
    {
      mode = "v";
      key = "J";
      action = ":m '>+1<CR>gv=gv";
      options.desc = "Move current line down";
    }
    {
      mode = "v";
      key = "K";
      action = ":m '<-2<CR>gv=gv";
      options.desc = "Move current line up";
    }

    # no highlight search
    {
      mode = "n";
      key = "<leader>nh";
      action = "<cmd>nohlsearch<CR>";
      options.desc = "No highlight search";
    }
  ];
}
