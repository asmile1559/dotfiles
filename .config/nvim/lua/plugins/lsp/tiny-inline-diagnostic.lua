return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup({
        preset = "modern",
        options = {
          show_source = {
            enabled = true,
            if_many = false,
          },
          show_code = true,
          set_arrow_to_diag_color = true,
          softwrap = 30,
          add_messages = {
            messages = true,
            display_count = true,
          },
          multilines = {
            enabled = true,
            trim_wihtespaces = true,
            tabstop = 2,
          },
          enable_on_insert = true,
          enabled_on_select = false,
          overflow = {
            mode = "wrap",
            padding = 0,
          },
          break_line = {
            enabled = true,
            after = 30,
          },
          virt_texts = {
            priority = 2048,
          },
        },
      })
      vim.diagnostic.config({ virtual_text = false })
    end,
  },
}
