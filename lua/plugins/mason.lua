return {
  "mason-org/mason.nvim",
  event = "VeryLazy",
  opts = {
    ensure_installed = {
      "ast-grep",
      "stylua",
      "prettierd",
      "prettier",
      "eslint_d",
      "yaml-language-server",
      "solidity",
      "dockerfile-language-server",
      "lua-language-server",
    },
    automatic_installation = true,
  },
}
