-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

opt.colorcolumn = { 80 }
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

opt.termguicolors = true

opt.list = true
opt.listchars = {
  tab = "󰌒 ",
  trail = "·",
}
