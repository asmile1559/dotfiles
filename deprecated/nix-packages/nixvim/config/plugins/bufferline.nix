{
  plugins.bufferline = {
    enable = true;
    settings = {
      # for details, see :h bufferline-configuration
      options = {
        mode = "buffers";
        style_preset = "default"; # or "powerline"
        themable = true;
        numbers = "ordinal";
        close_command.__raw = ''
          function(bufnr)
            MiniBufremove.delete(bufnr, false) -- or true for force
          end
        '';
        indicator = {
          icon = "▎";
          style = "underline";
        };
        buffer_close_icon = "󰅖";
        close_icon = "";
        modified_icon = "●";
        left_trunc_marker = "";
        right_trunc_marker = "";
        # name_formatter = ''
        #   -- name
        #   -- path
        #   -- bufnr
        #   -- buffers (tabs only)
        #   -- tabnr (tabs only)
        # '';
        max_name_length = 18;
        max_prefix_length = 15;
        trunc_name = true;
        tab_size = 18;
        diagnostics = "nvim_lsp"; # the status display in buffer line title
        diagnostics_indicator = ''
          function(count, level, diagnostics_dict, context)
            local s = ""
            for e, n in pairs(diagnostics_dict) do
              local sym = e == "error" and " "
                or (e == "warning" and " " or "" )
              if(sym ~= "") then
                s = s .. " " .. n .. sym
              end
            end
            return s
          end
        '';
        custom_filter = ''
          function(buf_number, buf_numbers)
            -- filter out filetypes you don't want to see
            if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
                return true
            end
            -- filter out by buffer name
            if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
                return true
            end
            -- filter out based on arbitrary rules
            -- e.g. filter out vim wiki buffer from tabline in your work repo
            if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
                return true
            end -- filter out by it's index number in list (don't show first buffer)
            if buf_numbers[1] ~= buf_number then
                return true
            end
          end
        '';
        offsets = [
          {
            filetype = "neo-tree";
            highlight = "Directory";
            text = "File Explorer";
            text_align = "center";
            # separator = true;
          }
        ];
        color_icon = true;
        get_element_icon = ''
          function(element)
            -- element consists of {filetype: string, path: string, extension: string, directory: string}
            -- This can be used to change how bufferline fetches the icon
            -- for an element e.g. a buffer or a tab.
            -- e.g.
            local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(element.filetype, { default = false })
            return icon, hl
          end
        '';
        show_buffer_icons = true;
        show_buffer_close_icons = true;
        show_close_icon = true;
        show_tab_indicators = true;
        show_duplicate_prefix = true;
        duplicates_across_groups = true;
        persist_buffer_sort = true;
        move_wraps_at_ends = false;
        # "slant" | "padded_slant" | "slope " | padded_slope | "thick" | "thin" | { 'any', 'any' }
        separator_style = "slope";
        enforce_regular_tabs = false;
        always_show_bufferline = true;
        auto_toggle_bufferline = true;
        hover = {
          enable = true;
          delay = 200;
          reveal = "close";
        };
        # sort_by = "id";
        sort_by = "insert_after_current";
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<Tab>";
      action = "<cmd>BufferLineCycleNext<cr>";
      options = {
        desc = "Cycle to next buffer";
      };
    }
    {
      mode = "n";
      key = "<S-Tab>";
      action = "<cmd>BufferLineCyclePrev<cr>";
      options = {
        desc = "Cycle to prev buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>bd";
      action.__raw = ''
        function()
          local buf = vim.api.nvim_get_current_buf()
          MiniBufremove.delete(buf, false) -- or true for force
        end
      '';
      options = {
        desc = "Close this buffer";
      };
    }
  ];
}
