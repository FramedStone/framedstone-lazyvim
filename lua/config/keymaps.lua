-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.g.mapleader = " "
vim.opt.timeoutlen = 300 -- timeout triggers

-- vim.keymap.set("n", "<leader>fe", vim.cmd.Ex) -- default directory explorer
vim.keymap.set("n", "<leader>dh", vim.cmd.nohl) -- no highlight
vim.keymap.set("i", "<leader>jk", "<Esc>") -- change to normal mode
vim.keymap.set("n", "<leader>bb", "<C-^>") -- switch back and forth between last edited files

-- search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = false
vim.opt.signcolumn = "yes"

-- split windows
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.keymap.set("n", "<leader>sv", "<C-w>v") -- split vertically
vim.keymap.set("n", "<leader>sh", "<C-w>s") -- split horizontally
vim.keymap.set("n", "<leader>sc", "<cmd>close<CR>") -- close current split
-- vim.keymap.set("n", "<leader>wm", ":MaximizerToggle<CR>") -- close current split

-- tabs management
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>") -- open new tab
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>") -- close current tab
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>") -- go to next tab
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>") -- go to previous tab

-- move line of codes
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("x", "p", '"_dP') -- doesn't copy the pasted line
vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "Q", "<nop>")

-- find and replace for all strings
vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

-- file explorer
-- vim.keymap.set("n", "<leader>fe", "<cmd>NvimTreeToggle<CR>")

-- clipboard
vim.opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- lsp suggestion navigation
vim.api.nvim_set_keymap("i", "<C-j>", "<C-n>", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-k>", "<C-p>", { noremap = true })

-- undotree
vim.keymap.set("n", "<leader>ut", ":UndotreeToggle<CR>") -- close current split

-- gitsigns
vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", {})

-- claude-fzf-history
vim.keymap.set("n", "<leader>ah", "<cmd>ClaudeHistory<cr>", {})

-- opencode
vim.keymap.set("n", "<leader>aaa", function() require("opencode").toggle() end, { desc = "Toggle opencode window" })
