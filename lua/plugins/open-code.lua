return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    -- Recommended for `ask()` and `select()`.
    -- Required for `toggle()`.
    { "folke/snacks.nvim", opts = { input = {}, picker = {} } },
  },
   config = function()
     -- Configurable type: "right", "left", or "float"
     vim.g.opencode_type = "right"
     -- Configurable width for left/right (percentage of screen)
     vim.g.opencode_width = 0.5

     local type = vim.g.opencode_type
     local win_opts = {
       position = type,
       enter = true,
     }
     if type == "float" then
       win_opts.relative = "editor"
       win_opts.row = 0.1
       win_opts.col = 0.1
       win_opts.width = 0.7
       win_opts.height = 0.7
       win_opts.border = "single"
     else
       win_opts.width = vim.g.opencode_width
     end

     vim.g.opencode_opts = {
       terminal = {
         win = vim.tbl_deep_extend("force", {
           wo = { winbar = "" },
           bo = { filetype = "opencode_terminal" },
         }, win_opts),
       },
     }

    -- Required for `vim.g.opencode_opts.auto_reload`
    vim.opt.autoread = true


  end,
}
