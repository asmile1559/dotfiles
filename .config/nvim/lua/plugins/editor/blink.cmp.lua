return {
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = { 'rafamadriz/friendly-snippets' },

    -- use a release tag to download pre-built binaries
    version = '1.*',
    opts = {
      keymap = {
        ['<Tab>'] = {
          function(cmp)
            if cmp.is_menu_visible() then
              return cmp.accept()
            else
              return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", true)
            end
          end,
        },

        ['<S-Tab>'] = {
          function(cmp)
            if cmp.is_menu_visible() then
              return cmp.select_prev()
            else
              return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-d>", true, false, true), "n", true)
            end
          end,
        },
      },
      sources = {
        default = { 'lsp', 'buffer', 'path' },
      }
    }
  }
}
