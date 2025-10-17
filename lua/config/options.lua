-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.o.guicursor = "n-v-c-i:block" -- stays as block cursor
vim.opt.fileformat = "unix"

if vim.fn.has("win32") == 1 then
  vim.o.shell = "C:/Windows/System32/wsl.exe" -- Use wsl on Windows
else
  vim.o.shell = "/usr/bin/zsh" -- Use zsh on macOS/Linux
end

-- Force conversion on file open (including existing files)
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    vim.bo.fileformat = "unix"
  end,
})
