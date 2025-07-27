local function loadEnvFile(filePath)
  local file = io.open(filePath, "r")
  if not file then
    return
  end

  for line in file:lines() do
    local key, value = line:match("^%s*([%w_]+)%s*=%s*(.+)%s*$")
    if key and value and os.getenv(key) == nil then
      vim.fn.setenv(key, value)
    end
  end

  file:close()
end

return function()
  local envPath = vim.fn.stdpath("config") .. "/.env"
  loadEnvFile(envPath)
end
