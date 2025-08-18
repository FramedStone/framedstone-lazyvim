vim.api.nvim_create_user_command("Obsidian", function()
  local indexPath = vim.fn.expand("~/.config/obsidian-sync/README.md")
  vim.cmd("edit " .. indexPath)
end, { desc = "Open Obsidian README.md in Neovim" })
