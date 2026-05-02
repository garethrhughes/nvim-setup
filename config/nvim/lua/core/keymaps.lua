-- Non-plugin keymaps
-- Plugin keymaps live inside their plugin spec's keys = {} table.

local map = vim.keymap.set

-- ─── General ────────────────────────────────────────────────────────────────

-- Save with Ctrl+S (normal, insert, visual)
map({ "n", "i", "v" }, "<C-s>", "<Cmd>w<CR><Esc>", { desc = "Save file" })

-- Quit
map("n", "<leader>q", "<Cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>Q", "<Cmd>qa!<CR>", { desc = "Quit all (force)" })

-- Clear search highlight
map("n", "<Esc>", "<Cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- ─── Editing ────────────────────────────────────────────────────────────────

-- Duplicate line (VS Code: Shift+Alt+Down)
map("n", "<S-A-Down>", "<Cmd>copy .<CR>", { desc = "Duplicate line down" })
map("i", "<S-A-Down>", "<Esc><Cmd>copy .<CR>gi", { desc = "Duplicate line down" })

-- Move selected lines (handled by mini.move in visual; these cover normal mode)
map("n", "<A-Up>", "<Cmd>move .-2<CR>==", { desc = "Move line up" })
map("n", "<A-Down>", "<Cmd>move .+1<CR>==", { desc = "Move line down" })
map("v", "<A-Up>", ":move '<-2<CR>gv=gv", { desc = "Move selection up" })
map("v", "<A-Down>", ":move '>+1<CR>gv=gv", { desc = "Move selection down" })

-- Indent / de-indent in visual and keep selection
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Toggle comment with Ctrl+/ (handled by Comment.nvim but we map here for discoverability)
-- Comment.nvim maps gcc in normal and gc in visual; the <C-/> map below delegates to it.
map("n", "<C-/>", "gcc", { desc = "Toggle comment", remap = true })
map("v", "<C-/>", "gc", { desc = "Toggle comment", remap = true })

-- Better up/down on wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Down" })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Up" })

-- ─── Buffers ────────────────────────────────────────────────────────────────

map("n", "<leader>bd", "<Cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bD", "<Cmd>bdelete!<CR>", { desc = "Delete buffer (force)" })
map("n", "<S-h>", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<Cmd>bnext<CR>", { desc = "Next buffer" })

-- ─── Windows ────────────────────────────────────────────────────────────────

map("n", "<leader>wv", "<C-w>v", { desc = "Split vertical" })
map("n", "<leader>wh", "<C-w>s", { desc = "Split horizontal" })
map("n", "<leader>we", "<C-w>=", { desc = "Equal window sizes" })
map("n", "<leader>wc", "<Cmd>close<CR>", { desc = "Close window" })
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- ─── Diagnostics ────────────────────────────────────────────────────────────

map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic (float)" })

-- ─── Misc ───────────────────────────────────────────────────────────────────

-- Select all
map("n", "<C-a>", "ggVG", { desc = "Select all" })

-- Better paste in visual (don't yank replaced text)
map("v", "p", '"_dP', { desc = "Paste without yanking" })
