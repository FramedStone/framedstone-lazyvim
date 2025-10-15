return {
  "pittcat/claude-fzf.nvim",
  dependencies = {
    "ibhagwan/fzf-lua",
    "coder/claudecode.nvim",
  },
  opts = {
    auto_context = true,
    batch_size = 10,
  },
  cmd = {
    "ClaudeFzf",
    "ClaudeFzfFiles",
    "ClaudeFzfGrep",
    "ClaudeFzfBuffers",
    "ClaudeFzfGitFiles",
    "ClaudeFzfDirectory",
  },
  keys = {
    { "<leader>af", "<cmd>ClaudeFzfFiles<cr>", desc = "Claude: Add files" },
    { "<leader>as", "<cmd>ClaudeFzfGrep<cr>", desc = "Claude: Search and add" },
    { "<leader>ab", "<cmd>ClaudeFzfBuffers<cr>", desc = "Claude: Add buffers" },
    -- { "<leader>cgf", "<cmd>ClaudeFzfGitFiles<cr>", desc = "Claude: Add Git files" },
    -- { "<leader>cd", "<cmd>ClaudeFzfDirectory<cr>", desc = "Claude: Add directory files" },
  },
}
