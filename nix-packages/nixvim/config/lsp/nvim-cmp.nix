{
  plugins.cmp = {
    enable = true;
    settings = {
      sources = [
        { name = "nvim_lsp"; }
        { name = "luasnip"; }
        { name = "buffer"; }
        { name = "path"; }
      ];
      mapping = {
        __raw = ''
          cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<Tab>'] = cmp.mapping.confirm({ select = true }),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
          })
        '';
      };
      snippet = {
        expand = "function(args) require('luasnip').lsp_expand(args.body) end";
      };
    };
    cmdline = {
      "/" = {
        mapping = {
          __raw = "cmp.mapping.preset.cmdline()";
        };
        sources = [
          {
            name = "buffer";
          }
        ];
      };
      ":" = {
        mapping = {
          __raw = "cmp.mapping.preset.cmdline()";
        };
        sources = [
          {
            name = "path";
          }
          {
            name = "cmdline";
            option = {
              ignore_cmds = [
                "Man"
                "!"
              ];
            };
          }
        ];
      };
      
    };
  };

  plugins.cmp-nvim-lsp = {
    enable = true;
  };

  plugins.cmp-buffer = {
    enable = true;
  };

  plugins.cmp-path = {
    enable = true;
  };
}
