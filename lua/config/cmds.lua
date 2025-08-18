vim.api.nvim_create_user_command("Obsidian", function()
  local indexPath = vim.fn.expand("~/.config/obsidian-sync/README.md")
  vim.cmd("edit " .. indexPath)
end, { desc = "Open Obsidian README.md in Neovim" })

vim.api.nvim_create_user_command("Config", function()
  local indexPath = vim.fn.expand("~/.config/nvim/init.lua")
  vim.cmd("edit " .. indexPath)
end, { desc = "Open Obsidian config file (init.lua) in Neovim" })
