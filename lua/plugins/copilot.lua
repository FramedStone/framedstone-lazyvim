return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "VeryLazy",
  build = ":Copilot auth",
  opts = {
    suggestion = { enabled = true },
    panel = { enabled = true },
  },
}
