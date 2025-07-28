vim.api.nvim_create_user_command("Todo", function()
  local filePath = "TODO.md"
  vim.cmd("edit " .. filePath)

  vim.api.nvim_create_autocmd("BufEnter", {
    once = true,
    pattern = filePath,
    callback = function()
      local now = os.date("### Last modified: %Y-%m-%d %H::%M::%S")
      vim.api.nvim_buf_set_lines(0, 0, 1, false, { now }) -- replace first line
    end,
  })
end, { desc = "Open TODO.md file and update timestamp" })
