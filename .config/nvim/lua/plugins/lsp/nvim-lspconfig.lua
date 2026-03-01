return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
        update_in_insert = true,
        float = {
          wrap = true,
          max_width = 80,
        },
      },
    },
  },
}
