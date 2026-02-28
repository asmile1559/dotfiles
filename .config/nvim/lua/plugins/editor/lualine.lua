return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.theme = "auto"
      opts.options.globalstatus = true

      opts.sections = opts.sections or {}

      opts.sections.lualine_a = { "mode" }
      opts.sections.lualine_b = { "branch" }
      opts.sections.lualine_c = { "filename", "diff" }
      opts.sections.lualine_x = {
        "diagnostics",
        {
          function()
            local msg = ""
            local buf_ft = vim.bo.filetype
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if next(clients) == nil then
              return msg
            end
            for _, client in ipairs(clients) do
              local filetypes = client.config.filetypes
              if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                return client.name
              end
            end
            return msg
          end,
          color = { fg = "#ffffff" },
          icon = " ",
        },
        "encoding",
        "fileformat",
        "filetype",
      }

      opts.sections.lualine_y = {
        {
          "aerial",
          sep = " ) ",
          depth = nil,
          dense = false,
          dense_sep = ".",
          colored = true,
          cond = function()
            local buf_size_limit = 1024 * 1024
            if vim.api.nvim_buf_get_offset(0, vim.api.nvim_buf_line_count(0)) > buf_size_limit then
              return false
            end
            return true
          end,
        },

      }

      opts.sections.lualine_z = { "location" }

      return opts
    end,
  },
}
