-- Autocommands

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ─── Yank highlight ─────────────────────────────────────────────────────────
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- ─── Resize splits on window resize ─────────────────────────────────────────
augroup("ResizeSplits", { clear = true })
autocmd("VimResized", {
  group = "ResizeSplits",
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- ─── Close certain windows with q ───────────────────────────────────────────
augroup("QuickClose", { clear = true })
autocmd("FileType", {
  group = "QuickClose",
  pattern = { "help", "lspinfo", "man", "notify", "qf", "startuptime", "checkhealth" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
})

-- ─── Restore cursor position ─────────────────────────────────────────────────
augroup("RestoreCursor", { clear = true })
autocmd("BufReadPost", {
  group = "RestoreCursor",
  callback = function()
    -- Skip filetypes where starting at line 1 is the right behaviour.
    local skip = { "gitcommit", "gitrebase", "svn", "hgcommit" }
    if vim.tbl_contains(skip, vim.bo.filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ─── Filetype overrides ──────────────────────────────────────────────────────
augroup("FiletypeOverrides", { clear = true })

-- Use 4-space indent for Python
autocmd("FileType", {
  group = "FiletypeOverrides",
  pattern = "python",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})

-- Wrap and spell in Markdown
autocmd("FileType", {
  group = "FiletypeOverrides",
  pattern = { "markdown", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_gb"
  end,
})

-- Trailing-whitespace trimming is handled by conform.nvim formatters
-- (prettierd, stylua, shfmt, etc.) on save.
