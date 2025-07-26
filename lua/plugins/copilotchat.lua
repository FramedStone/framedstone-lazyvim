return {
  "CopilotChat.nvim",
  version = "v3.12.2",
  dependencies = {
    { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
    { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
  },
  opts = {
    sticky = {
      "@models Using Mistral-small",
      "#files",
    },
    remember_as_sticky = true,
  },
}
