vim.api.nvim_create_user_command("todo", function()
  vim.cmd("edit TODO.md")
end, { desc = "Open TODO.md file" })
