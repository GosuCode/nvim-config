--------------------------------------------------
-- LEADER (must be first)
--------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--------------------------------------------------
-- BASIC OPTIONS (sane defaults)
--------------------------------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.colorcolumn = "100"
vim.opt.textwidth = 80
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#3b0000" })

-- Show hidden files
vim.opt.wildignore = ""
