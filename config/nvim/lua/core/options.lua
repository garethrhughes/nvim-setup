-- Core editor options

local opt = vim.opt

-- Leader (also set in lazy.lua bootstrap, kept here for clarity)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.showmode = false -- lualine shows mode instead
opt.laststatus = 3 -- global statusline
opt.cmdheight = 1
opt.pumheight = 10
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.linebreak = true
opt.colorcolumn = "120"
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Editing
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.autoindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Files
opt.undofile = true
opt.backup = false
opt.swapfile = false
opt.autowrite = true

-- Clipboard (system clipboard via unnamedplus)
opt.clipboard = "unnamedplus"

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }
opt.shortmess:append("c")

-- Misc
opt.updatetime = 250
opt.timeoutlen = 300
opt.mouse = "a"
opt.breakindent = true
opt.confirm = true
opt.conceallevel = 0
opt.fileencoding = "utf-8"
opt.isfname:append("@-@")

-- Folding (ufo / treesitter handles this if installed)
opt.foldlevel = 99
opt.foldlevelstart = 99
