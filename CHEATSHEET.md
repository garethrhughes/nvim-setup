# Neovim Cheatsheet

> Leader key = `<Space>` · Colorscheme: Catppuccin Mocha · Font: JetBrainsMono Nerd Font

---

## 1. Survival Kit

| Action | Key |
|---|---|
| Enter Normal mode | `<Esc>` |
| Save file | `<C-s>` |
| Quit | `<leader>q` |
| Quit all (force) | `<leader>Q` |
| Undo | `u` |
| Redo | `<C-r>` |
| Clear search highlight | `<Esc>` (in Normal) |
| Command line | `:` |
| Help | `:help <topic>` |
| Which-key menu | `<Space>` (wait) |

---

## 2. Movement

### Basic

| Action | Key |
|---|---|
| Move down/up/left/right | `j` `k` `h` `l` |
| Word forward / back | `w` / `b` |
| End of word | `e` |
| Start / end of line | `0` / `$` |
| First non-blank | `^` |
| Top / middle / bottom of screen | `H` / `M` / `L` |
| Go to line N | `Ng` or `:N` |
| File start / end | `gg` / `G` |
| Scroll half-page down / up | `<C-d>` / `<C-u>` |
| Jump back / forward | `<C-o>` / `<C-i>` |
| Match bracket | `%` |

### Treesitter Text Objects

| Action | Key |
|---|---|
| Select outer / inner function | `af` / `if` |
| Select outer / inner class | `ac` / `ic` |
| Select outer / inner parameter | `aa` / `ia` |
| Select outer / inner block | `ab` / `ib` |
| Next / prev function start | `]f` / `[f` |
| Next / prev class start | `]c` / `[c` |
| Swap parameter with next | `<leader>a` |

---

## 3. VS Code Parity

| VS Code | Neovim |
|---|---|
| `Ctrl+P` Quick Open | `<C-p>` |
| `Ctrl+Shift+P` Command Palette | `<C-S-p>` |
| `Ctrl+Shift+F` Find in Files | `<C-S-f>` |
| `Ctrl+/` Toggle Comment | `<C-/>` |
| `Ctrl+B` Toggle Sidebar | `<C-b>` |
| `Ctrl+`` Toggle Terminal | `<C-`>` |
| `Ctrl+S` Save | `<C-s>` |
| `Alt+↑/↓` Move Line | `<A-Up>` / `<A-Down>` |
| `Shift+Alt+↓` Duplicate Line | `<S-A-Down>` |
| `Shift+H/L` Prev/Next Buffer | `<S-h>` / `<S-l>` |
| `F12` Go to Definition | `<F12>` or `gd` |
| `F2` Rename Symbol | `<F2>` |
| `Shift+Alt+F` Format Document | `<S-A-f>` |
| `Ctrl+.` Quick Fix | `<C-.>` |
| `Ctrl+A` Select All | `<C-a>` |

---

## 4. Leader Key Map

> Press `<Space>` and wait to see the which-key popup.

### `<leader>f` — Find (Telescope)

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (with args) |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent files |
| `<leader>fh` | Help tags |
| `<leader>fc` | Commands |
| `<leader>fk` | Keymaps |
| `<leader>fs` | Document symbols |
| `<leader>fS` | Workspace symbols |
| `<leader>fd` | Diagnostics |
| `<leader>ft` | TODOs |
| `<leader>f.` | Resume last search |
| `<leader>f"` | Registers |

### `<leader>g` — Git

| Key | Action |
|---|---|
| `<leader>gg` | Lazygit |
| `<leader>gf` | Lazygit (current file) |
| `<leader>gs` | Stage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gS` | Stage buffer |
| `<leader>gu` | Undo stage hunk |
| `<leader>gR` | Reset buffer |
| `<leader>gp` | Preview hunk |
| `<leader>gb` | Blame line |
| `<leader>gB` | Toggle line blame |
| `<leader>gd` | Diff this |
| `<leader>gv` | Diffview open |
| `<leader>gV` | Diffview close |
| `<leader>gh` | File history (Diffview) |
| `<leader>gH` | Repo history (Diffview) |
| `]h` / `[h` | Next / previous hunk |
| `ih` | (text object) select hunk |

### `<leader>l` — LSP

| Key | Action |
|---|---|
| `<leader>la` | Code action |
| `<leader>lr` | Rename symbol |
| `<leader>lh` | Hover docs |
| `<leader>ls` | Signature help |
| `<leader>lR` | References (Telescope) |
| `<leader>ld` | Definition (Telescope) |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | References |
| `gI` | Go to implementation |
| `gy` | Type definition |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>e` | Show diagnostic float |

### `<leader>b` — Buffer

| Key | Action |
|---|---|
| `<leader>bd` | Delete buffer |
| `<leader>bD` | Delete buffer (force) |
| `<leader>bp` | Toggle pin |
| `<leader>bP` | Delete non-pinned buffers |

### `<leader>w` — Window

| Key | Action |
|---|---|
| `<leader>wv` | Split vertical |
| `<leader>wh` | Split horizontal |
| `<leader>we` | Equal window sizes |
| `<leader>wc` | Close window |
| `<C-h/j/k/l>` | Navigate windows |

### `<leader>x` — Diagnostics (Trouble)

| Key | Action |
|---|---|
| `<leader>xx` | Diagnostics (all) |
| `<leader>xX` | Diagnostics (buffer) |
| `<leader>xl` | Location list |
| `<leader>xq` | Quickfix list |
| `<leader>xL` | LSP references panel |

### `<leader>t` — Terminal / Toggle

| Key | Action |
|---|---|
| `<C-`>` | Toggle terminal |
| `<leader>tt` | Terminal (horizontal) |
| `<leader>tv` | Terminal (vertical) |
| `<leader>tf` | Terminal (float) |
| `<Esc><Esc>` | Exit terminal mode |

### `<leader>u` — UI / Toggles

| Key | Action |
|---|---|
| `<leader>uf` | Toggle format on save |
| `<leader>ul` | Trigger linting |

### `<leader>q` — Sessions

| Key | Action |
|---|---|
| `<leader>qs` | Restore session (cwd) |
| `<leader>ql` | Restore last session |
| `<leader>qS` | Save session |
| `<leader>qd` | Don't save session on exit |

---

## 5. Completion

| Key | Action |
|---|---|
| `<C-Space>` | Trigger completion |
| `<C-j>` / `<C-k>` | Next / previous item |
| `<CR>` | Confirm selection |
| `<Tab>` / `<S-Tab>` | Next / prev (or jump snippet) |
| `<C-e>` | Abort |
| `<C-b>` / `<C-f>` | Scroll docs |

---

## 6. Telescope

Inside a Telescope picker:

| Key | Action |
|---|---|
| `<C-j>` / `<C-k>` | Move selection |
| `<CR>` | Open |
| `<C-q>` | Send to quickfix |
| `<Esc>` | Close |

---

## 7. Editing Helpers

### Surround (nvim-surround)

| Action | Key |
|---|---|
| Add surround | `ys<motion><char>` e.g. `ysiw"` |
| Change surround | `cs<old><new>` e.g. `cs"'` |
| Delete surround | `ds<char>` e.g. `ds"` |
| Surround visual | `S<char>` |

### Comment

| Action | Key |
|---|---|
| Toggle line comment | `gcc` or `<C-/>` |
| Toggle visual comment | `gc` or `<C-/>` |
| Block comment | `gbc` |

### Pairs (nvim-autopairs)

- Pairs auto-close on insert: `(`, `[`, `{`, `"`, `'`
- Fast-wrap: `<M-e>` to wrap word under cursor

---

## 8. Git Workflow (Quick Reference)

```
<leader>gg    → open Lazygit (full UI)
<leader>gs    → stage hunk under cursor
<leader>gp    → preview hunk diff
]h / [h       → navigate hunks
<leader>gb    → blame current line
<leader>gv    → open Diffview for staged changes
<leader>gh    → file commit history in Diffview
```

---

## 9. Troubleshooting

| Problem | Fix |
|---|---|
| Icons look wrong | Set terminal font to JetBrainsMono Nerd Font |
| LSP not attaching | `:Mason` → check server is installed · `:LspInfo` |
| Formatter not running | `:ConformInfo` · check `prettierd`/`shfmt` in Mason |
| Linter not showing | `:lua require("lint").try_lint()` · check Mason for tool |
| Plugins not loading | `:Lazy` → check for errors · run `./install.sh` again |
| Slow startup | `:Lazy profile` to find culprit |
| checkhealth errors | `:checkhealth` → follow suggested fixes |
| Reset everything | `./uninstall.sh` then `./install.sh` |
