return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    build = "make tiktoken",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
      {
        "ravitemer/mcphub.nvim",
        build = "npm install -g mcp-hub@latest",
        config = function()
          require("mcphub").setup({
            extensions = {
              copilotchat = {
                enabled = true,
                convert_tools_to_functions = true,
                convert_resources_to_functions = true,
                add_mcp_prefix = false,
              },
            },
            auto_approve = true,
            auto_toggle_mcp_servers = true,
          })
        end,
      },
    },
    keys = {
      { "<leader>aa", "<cmd>CopilotChatToggle<cr>", desc = "Open Copilot Chat" },
    },
    opts = {
      sticky = {
        "$gpt-4.1",
        "@context7",
        "@neovim always use edit files",
        "@mcphub",
        "@brave_search_brave_web_search",
        "@brave_search_brave_local_search",
        "@sequentialthinking use sequentialthinking before answering",
        "#file:.github/copilot-instructions.md",
      },
      window = {
        layout = "vertical",
        width = 0.5,
        height = 0.5,
        relative = "editor",
        border = "single",
        row = nil,
        col = nil,
        title = "Copilot Chat",
        footer = nil,
        zindex = 1,
      },
    },
  },
}
