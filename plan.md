# Plan: Portable Neovim Setup

## Goal

A single git-tracked Neovim configuration that works identically on **macOS** and **Kubuntu**,
optimised for an opencode/VS Code user who wants Vim modal editing alongside familiar
VS Code-style shortcuts.

**Languages targeted:** TypeScript/JS, Bash, Terraform/HCL, YAML, JSON, Markdown, Docker/Compose.

---

## Repo Layout

```
nvim-setup/
├── plan.md                       ← this file
├── README.md                     ← quick start + link to cheatsheet
├── CHEATSHEET.md                 ← keymap reference (printable)
├── install.sh                    ← OS-detecting bootstrap (macOS/Linux)
├── uninstall.sh                  ← removes symlinks, restores backups
└── config/
    └── nvim/
        ├── init.lua              ← entry: loads core/, then lazy
        ├── lazy-lock.json        ← committed; pins plugin versions
        ├── stylua.toml           ← Lua formatter config
        ├── .editorconfig
        └── lua/
            ├── core/
            │   ├── options.lua   ← vim.opt settings
            │   ├── keymaps.lua   ← non-plugin keymaps
            │   └── autocmds.lua  ← filetype rules, yank-highlight, etc.
            ├── lazy.lua          ← bootstraps lazy.nvim
            └── plugins/
                ├── ui.lua             ← catppuccin, lualine, bufferline, noice
                ├── editor.lua         ← which-key, mini.*, comment, surround, autopairs
                ├── telescope.lua      ← fuzzy finder + extensions
                ├── neo-tree.lua       ← file explorer
                ├── treesitter.lua     ← parsers + textobjects
                ├── lsp.lua            ← mason, lspconfig, mason-lspconfig
                ├── completion.lua     ← nvim-cmp + LuaSnip
                ├── formatting.lua     ← conform.nvim (format-on-save, :FormatToggle)
                ├── linting.lua        ← nvim-lint
                ├── git.lua            ← gitsigns, diffview, lazygit
                ├── terminal.lua       ← toggleterm
                ├── sessions.lua       ← persistence.nvim (manual restore)
                └── dap.lua            ← placeholder; debugging deferred to v2
```

---

## install.sh Behaviour

1. Detect OS (`uname`) → macOS (brew) or Linux (apt).
2. Install prerequisites if missing:
   - `neovim` (>= 0.10), `git`, `ripgrep`, `fd-find`, `fzf`, `node`, `npm`,
     `python3`, `unzip`, `curl`, `lazygit`
   - Nerd Font: JetBrainsMono Nerd Font via brew cask (macOS) or direct download to
     `~/.local/share/fonts` + `fc-cache` (Linux).
   - Clipboard: `xclip` or `wl-clipboard` on Linux.
3. Back up existing `~/.config/nvim`, `~/.local/share/nvim`, `~/.local/state/nvim`
   to `*.bak.<timestamp>`.
4. Symlink `config/nvim` → `~/.config/nvim`.
5. Run `nvim --headless "+Lazy! sync" +qa` to install all plugins.
6. Print next steps: set terminal font, run `:checkhealth`.

`uninstall.sh` removes the symlink and restores the most recent backup.

---

## Plugin Set

All plugins are pinned via `lazy-lock.json` committed to the repo, ensuring identical
versions on macOS and Kubuntu.

| Concern | Plugin |
|---|---|
| Plugin manager | `folke/lazy.nvim` |
| Colorscheme | `catppuccin/nvim` (mocha) |
| Statusline | `nvim-lualine/lualine.nvim` |
| Bufferline (tabs) | `akinsho/bufferline.nvim` |
| Icons | `nvim-tree/nvim-web-devicons` |
| Notifications/cmdline | `folke/noice.nvim` + `rcarriga/nvim-notify` |
| Keymap discovery | `folke/which-key.nvim` |
| File explorer | `nvim-neo-tree/neo-tree.nvim` |
| Fuzzy finder | `nvim-telescope/telescope.nvim` + fzf-native + live-grep-args |
| Treesitter | `nvim-treesitter/nvim-treesitter` + textobjects |
| LSP | `neovim/nvim-lspconfig` + `williamboman/mason.nvim` + mason-lspconfig |
| Completion | `hrsh7th/nvim-cmp` + LuaSnip + cmp sources |
| Formatting | `stevearc/conform.nvim` |
| Linting | `mfussenegger/nvim-lint` |
| Git | `lewis6991/gitsigns.nvim` + `sindrets/diffview.nvim` + `kdheepak/lazygit.nvim` |
| Comments | `numToStr/Comment.nvim` |
| Editing helpers | `windwp/nvim-autopairs`, `kylechui/nvim-surround`, `echasnovski/mini.ai`, `mini.move` |
| Indent guides | `lukas-reineke/indent-blankline.nvim` |
| Terminal | `akinsho/toggleterm.nvim` |
| Sessions | `folke/persistence.nvim` |
| TODO highlights | `folke/todo-comments.nvim` |
| Diagnostics list | `folke/trouble.nvim` |
| DAP (deferred) | placeholder only in v1 |

---

## LSP / Tooling Matrix

Mason auto-installs all of the following:

| Language | LSP | Formatter | Linter |
|---|---|---|---|
| TypeScript/JS | `vtsls` | `prettierd` | `eslint_d` |
| Bash | `bashls` | `shfmt` | `shellcheck` |
| Terraform/HCL | `terraformls` | `terraform fmt` (via conform) | `tflint` |
| YAML | `yamlls` + schemastore | `prettierd` | — |
| JSON | `jsonls` + schemastore | `prettierd` | — |
| Markdown | `marksman` | `prettierd` | `markdownlint-cli2` |
| Docker/Compose | `dockerls` + `docker_compose_language_service` | — | `hadolint` |
| Lua (own config) | `lua_ls` | `stylua` | — |

---

## Keymap Strategy — VS Code Hybrid

**Leader = `<Space>`**

### VS Code parity

| VS Code action | Neovim keymap |
|---|---|
| Command palette | `<C-S-p>` → Telescope commands |
| Quick open file | `<C-p>` → Telescope find_files |
| Find in files | `<C-S-f>` → Telescope live_grep |
| Toggle comment | `<C-/>` (normal + visual) |
| Toggle sidebar | `<C-b>` → Neo-tree |
| Toggle terminal | `<C-`>` → toggleterm |
| Save | `<C-s>` |
| Move line up/down | `<A-Up>` / `<A-Down>` (mini.move) |
| Duplicate line | `<S-A-Down>` |
| Go to definition | `gd` + `<F12>` |
| Rename symbol | `<F2>` |
| Format document | `<S-A-f>` |
| Quick fix | `<C-.>` |

### Leader groups (which-key)

| Prefix | Group |
|---|---|
| `<leader>f` | find (telescope) |
| `<leader>g` | git |
| `<leader>l` | lsp |
| `<leader>b` | buffer |
| `<leader>w` | window |
| `<leader>x` | diagnostics / trouble |
| `<leader>t` | terminal / toggle |
| `<leader>u` | ui toggles (format, wrap, etc.) |
| `<leader>q` | sessions (quit / persist) |

---

## Defaults Locked In

| Decision | Default |
|---|---|
| Branch strategy | Commit directly to `main` with Conventional Commits |
| Proposals / ADRs | Skipped — personal tooling repo |
| DAP / debugging | Deferred to v2 |
| Session restore | Manual only (`<leader>qs`, `<leader>ql`) |
| Format on save | On by default; toggle via `<leader>uf` / `:FormatToggle` |

---

## Portability

- `lazy-lock.json` committed → identical plugin versions on both OSes.
- No hardcoded paths; `vim.fn.stdpath()` used everywhere.
- Mason installs LSPs into `~/.local/share/nvim/mason` (cross-platform).
- Clipboard uses `unnamedplus`; install.sh ensures `xclip`/`wl-clipboard` on Linux.
- Font install handled per-OS in `install.sh`.

---

## Commit Strategy

```
chore: add plan.md
feat: scaffold neovim config (init.lua, core, lazy bootstrap)
feat: add UI plugins (catppuccin, lualine, bufferline, neo-tree, which-key, noice)
feat: add editor plugins (telescope, treesitter, comment, surround, autopairs, mini)
feat: add LSP, completion, formatting, linting stack
feat: add git, terminal, sessions
feat: add install/uninstall scripts
docs: add README and CHEATSHEET
```
