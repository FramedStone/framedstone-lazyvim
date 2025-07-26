return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    -- build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
      sticky = {
        "@models Using GPT-4", -- optional
        "#files",
      },
    },
    -- See Commands section for default commands if you want to lazy load on them
    keys = {
      {
        "<leader>aa",
        function()
          require("CopilotChat").toggle()
        end,
        desc = "CopilotChat: Open",
      },
    },
  },
}
