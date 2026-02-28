return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'black' },
        javascript = { 'prettier', stop_at_first = true },
        typescript = { 'prettier', stop_at_first = true },
        css = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        rust = { 'rustfmt', lsp_format = "fallback" },
        go = { 'gofmt' },
        ["*"] = { 'codespell' },
        ["_"] = { 'trim_whitespace' },
      },
    },
  }
}
