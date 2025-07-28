vim.api.nvim_create_user_command("Todo", function()
  local filePath = vim.fn.stdpath("config") .. "/TODO.md"
  vim.cmd("edit " .. filePath)
end, { desc = "Open TODO.md in Neovim config " })
