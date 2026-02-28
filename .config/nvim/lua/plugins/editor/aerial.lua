return {
  {
    'stevearc/aerial.nvim',
    opts = {
      icons = {
        File = "󰈙 ",
        Module = " ",
        Namespace = " ",
        Package = " ",
        Class = " ",
        Method = "󰆧 ",
        Property = " ",
        Field = "󰜢 ",
        Constructor = " ",
        Enum = "󰒻 ",
        Interface = " ",
        Function = "󰊕 ",
        Variable = " ",
        Constant = "󰏿 ",
        String = "󰉾 ",
        Number = "󰎠 ",
        Array = "󰅪 ",
        Object = "󰅩 ",
        Key = "󰜢 ",
        Null = "NULL",
        EnumMember = " ",
        Struct = "󰌗 ",
        Event = "",
        Operator = "󰆕 ",
        TypeParameter = "",
      },
    },
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
  }
}
