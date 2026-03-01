{
  imports = [
    ./conform-nvim.nix
    ./dap.nix
    ./lsp.nix
    ./lspkind.nix
    ./luasnip.nix
    ./nvim-cmp.nix
    ./tiny-inline-diagnostic.nix
  ];

  extraConfigLua = ''
    vim.diagnostic.config({
      update_in_insert = true,
    })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      callback = function()
        vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
    end,
    })
  '';

}
