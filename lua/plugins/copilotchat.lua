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
        "@neovim always use neovim_edit_file when modifying files are required",
        "@sequentialthinking use sequentialthinking before answering",
        "#file:/Users/leeweixuan/.config/obsidian-sync/aasdc/agents/v2/frontend-dev.yaml",
        "#file:/Users/leeweixuan/.config/obsidian-sync/aasdc/agents/v2/codebase-analyzer.yaml",
      },
      window = {
        layout = "float",
        width = 0.7,
        height = 0.7,
        relative = "editor",
        border = "single",
        row = nil,
        col = nil,
        title = "Copilot Chat",
        footer = nil,
        zindex = 1,
        blend = 0, -- 100 = full transparent
      },
    },
  },
}
