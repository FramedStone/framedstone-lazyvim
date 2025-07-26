-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.o.guicursor = "n-v-c-i:block" -- stays as block cursor
vim.opt.formatoptions:remove({ "o", "r", "c" })
