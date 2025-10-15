return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = true,
  keys = {
    -- { "<leader>a", nil, desc = "AI/Claude Code" },
    { "<leader>aaa", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    -- { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    -- { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    -- { "<leader>ac", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    -- { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    -- { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    -- { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    -- {
    --   "<leader>af",
    --   "<cmd>ClaudeCodeTreeAdd<cr>",
    --   desc = "Add file",
    --   ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
    -- },
    -- Diff management
    { "<leader>ga", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>gr", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
  opts = {
    terminal = {
      split_side = "right", -- "left" or "right"
      split_width_percentage = 0.4,
      provider = "auto", -- "auto", "snacks", "native", "external", "none", or custom provider table
      auto_close = true,
      snacks_win_opts = {
        -- position = "float",
        -- width = 0.8,
        -- height = 0.8,
      }, -- Opts to pass to `Snacks.terminal.open()` - see Floating Window section below
    },
  },
}
