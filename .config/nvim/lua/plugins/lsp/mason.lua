return {
  {
    "mason-org/mason-lspconfig.nvim",
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "gopls",
        "ts_ls",
        "clangd",
        "pyright",
      },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "mason-org/mason.nvim",
    event = "VeryLazy",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    },
  }
}
