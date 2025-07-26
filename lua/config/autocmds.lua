-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    if vim.bo.fileformat == "dos" then
      vim.bo.fileformat = "unix"
      vim.notify("Line endings converted: CRLF → LF", vim.log.levels.INFO)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "o" })
  end,
})

vim.schedule(function()
  local notify = require("lazyvim.util").notify

  if not vim.env.REPOSITORY_PATH or vim.env.REPOSITORY_PATH == "" then
    local input = vim.fn.input("Set REPOSITORY_PATH (optional): ", "", "dir")
    if input and input ~= "" then
      vim.env.REPOSITORY_PATH = input
      notify({
        msg = "REPOSITORY_PATH set to:\n" .. input,
        level = "info",
      })
    else
      notify({
        msg = "REPOSITORY_PATH not set (left blank)",
        level = "warn",
      })
    end
  else
    notify({
      msg = "REPOSITORY_PATH is already set:\n" .. vim.env.REPOSITORY_PATH,
      level = "info",
    })
  end
end)
