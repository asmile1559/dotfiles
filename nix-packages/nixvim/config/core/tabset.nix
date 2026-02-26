{
  extraConfigLua = ''
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "nix", "javascript", "typescript", "css", "html", "json", "sh" },
      callback = function()
        vim.bo.expandtab = true
        vim.bo.shiftwidth = 2
        vim.bo.tabstop = 2
        vim.bo.softtabstop = 2
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "c", "cpp", "rust", "python" },
      callback = function()
        vim.bo.expandtab = true
        vim.bo.shiftwidth = 4
        vim.bo.tabstop = 4
        vim.bo.softtabstop = 4
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "go" },
      callback = function()
        vim.bo.expandtab = false
        vim.bo.shiftwidth = 4
        vim.bo.tabstop = 4
        vim.bo.softtabstop = -1
      end,
    })
  '';
}
