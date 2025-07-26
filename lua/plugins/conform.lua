-- ~/.config/nvim/lua/plugins/conform.lua
return {
  "stevearc/conform.nvim",
  opts = function()
    return {
      formatters_by_ft = {
        lua = { "ast-grep", "stylua" },
        javascript = { "eslint_d", "ast-grep", "prettierd", stop_after_first = true },
        javascriptreact = { "eslint_d", "ast-grep", "prettierd", stop_after_first = true },
        typescript = { "eslint_d", "ast-grep", "prettierd", stop_after_first = true },
        typescriptreact = { "eslint_d", "ast-grep", "prettierd", stop_after_first = true },
        json = { "prettierd" },
      },
      formatters = {
        prettierd = {
          single_quote = true,
        },
      },
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function(args)
          require("conform").format({ bufnr = args.buf })
        end,
      }),
    }
  end,
}
