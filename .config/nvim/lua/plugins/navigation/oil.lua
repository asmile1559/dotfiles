return {
  {
    'stevearc/oil.nvim',
    -- Optional dependencies
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    lazy = false,
    opts = {
      columns = {
        "icon",
        "permissions",
        "size",
        "mtime"
      },
      delete_to_trash = true,
      win_options = {
        signcolumn = "yes:2",
      },
    },
    config = function(_, opts)
      local oil = require("oil")
      oil.setup(opts)
      vim.keymap.set("n", "-", oil.open, { desc = "Open parent directory" })
    end,
  },
  {
    "refractalize/oil-git-status.nvim",
    dependencies = { "stevearc/oil.nvim", },
    config = true,
  },
}
