# CLAUDE.md — nvim-setup

This file is the authoritative context for any AI agent (OpenCode, Claude, etc.) working on
this repository. Read it fully before making any changes.

---

## Project Overview

A portable, git-tracked Neovim configuration targeting **macOS** and **Kubuntu**.
The config is hand-rolled Lua using `lazy.nvim` as the plugin manager.

**Primary user:** Software engineer working mainly in TypeScript/JS, Bash, Terraform/HCL,
YAML, JSON, Markdown, and Docker/Compose inside opencode and VS Code. Neovim is a
complementary terminal editor — the keymap philosophy is **VS Code hybrid**: familiar
Ctrl-based shortcuts alongside full modal Vim editing.

**Full plan:** see `plan.md` for the complete design rationale, plugin choices, and
keymap strategy.

---

## Repository Layout

```
nvim-setup/
├── plan.md           ← Design plan and rationale
├── README.md         ← Quick start for humans
├── CHEATSHEET.md     ← Printable keymap reference
├── CLAUDE.md         ← This file
├── install.sh        ← OS-detecting bootstrap (macOS/Linux)
├── uninstall.sh      ← Removes symlinks, restores backups
└── config/
    └── nvim/         ← Symlinked to ~/.config/nvim by install.sh
        ├── init.lua
        ├── lazy-lock.json   ← COMMITTED — pins plugin versions
        ├── stylua.toml
        ├── .editorconfig
        └── lua/
            ├── core/
            │   ├── options.lua
            │   ├── keymaps.lua
            │   └── autocmds.lua
            ├── lazy.lua
            └── plugins/
                ├── ui.lua
                ├── editor.lua
                ├── telescope.lua
                ├── neo-tree.lua
                ├── treesitter.lua
                ├── lsp.lua
                ├── completion.lua
                ├── formatting.lua
                ├── linting.lua
                ├── git.lua
                ├── terminal.lua
                ├── sessions.lua
                └── dap.lua      ← placeholder; debugging deferred to v2
```

---

## Key Conventions

### Lua style
- All Lua formatted with **StyLua** (`stylua.toml` at `config/nvim/stylua.toml`).
- No trailing whitespace, 2-space indent, `column_width = 120`.
- Prefer `vim.keymap.set` over `vim.api.nvim_set_keymap`.
- Use `vim.fn.stdpath()` for all paths — never hardcode `~` or `/home/...`.
- Plugin specs live in `config/nvim/lua/plugins/` — one file per concern.
- Each plugin file returns a table of lazy.nvim plugin specs.

### Plugin management
- **lazy.nvim** is the only plugin manager.
- `lazy-lock.json` is committed. After adding/updating plugins, commit the updated lockfile.
- Plugins are loaded lazily wherever possible (`event`, `ft`, `cmd`, `keys` triggers).
- No plugins are loaded at startup unless strictly necessary for the UI frame.

### Keymaps
- **Leader = `<Space>`**
- VS Code parity shortcuts (see `plan.md` keymap table) take precedence where there is no
  deep conflict with Vim idioms.
- All leader keymaps are registered with **which-key** groups so `<Space>` shows a menu.
- Non-plugin keymaps live in `core/keymaps.lua`; plugin keymaps live in `keys = {}` inside
  the plugin spec.

### LSP / tooling
- **Mason** manages all LSP server, formatter, and linter installations.
- Never hardcode binary paths — use Mason-installed binaries via `mason-lspconfig` and
  `conform.nvim` / `nvim-lint` Mason integration.
- Format on save is **on by default** and togglable via `<leader>uf` / `:FormatToggle`.
- `conform.nvim` handles formatting; `nvim-lint` handles linting on `BufWritePost`.

### Portability rules
- No OS-specific code inside `config/nvim/` Lua files. OS differences are handled in
  `install.sh` only.
- Clipboard is `unnamedplus` — install.sh ensures the correct clipboard provider is present
  on each OS.
- All plugin versions are pinned via `lazy-lock.json`.

---

## Install / Uninstall

```bash
# Bootstrap from scratch (macOS or Kubuntu)
./install.sh

# Remove symlinks and restore backup
./uninstall.sh
```

`install.sh` installs system prerequisites via brew (macOS) or apt (Linux), backs up any
existing Neovim config, creates the `~/.config/nvim` symlink, and runs a headless plugin
sync.

---

## Verification

After install, open Neovim and run:

```
:checkhealth
:Lazy
:Mason
```

- `:checkhealth` should show no errors (warnings about optional providers are acceptable).
- `:Lazy` should show all plugins installed with no errors.
- `:Mason` should list all LSP servers, formatters, and linters as installed.

Manual smoke tests:
1. Open a `.ts` file → LSP attaches, completions work, `<S-A-f>` formats.
2. Open a `.tf` file → terraformls attaches.
3. Open a `.md` file → marksman attaches, prettierd formats.
4. `<C-p>` → Telescope file picker opens.
5. `<C-b>` → Neo-tree toggles.
6. `` <C-`> `` → toggleterm opens.

---

## Ways of Working for AI Agents

### When making changes

1. **Read `plan.md` first** to understand design intent before proposing changes.
2. **Edit existing files** — never create new plugin files unless adding a wholly new
   concern. Prefer adding specs to the relevant existing `plugins/*.lua` file.
3. **Run StyLua** on any changed Lua files before committing:
   ```bash
   stylua config/nvim/lua/
   ```
4. **Test headlessly** where possible:
   ```bash
   nvim --headless "+Lazy! sync" +qa
   nvim --headless "+checkhealth" +qa 2>&1 | grep -E "ERROR|WARNING"
   ```
5. **Commit `lazy-lock.json`** whenever plugins are added, removed, or updated.

### Commit style

Conventional Commits on `main`:

```
feat: <short description>
fix: <short description>
chore: <short description>
docs: <short description>
refactor: <short description>
```

No PRs required for this personal-tooling repo. Commit directly to `main`.

### What NOT to do

- Do not add AI/Copilot plugins — AI assistance stays in opencode/VS Code.
- Do not add DAP/debugging plugins until explicitly requested (v2 scope).
- Do not add auto-session restore — sessions are manual only.
- Do not hardcode paths or OS names inside Lua config files.
- Do not skip committing `lazy-lock.json` after plugin changes.
- Do not use `vim.api.nvim_set_keymap` — use `vim.keymap.set`.

---

## Skills Available

This repo uses the OpenCode skills system. Relevant skills for ongoing work:

| Skill | When to use |
|---|---|
| `architect` | Before any significant structural change to the config layout |
| `developer` | When implementing new plugin integrations or features |
| `reviewer` | Before committing a significant batch of changes |
| `decision-log` | If a major plugin is swapped out or a pattern changes |

Invoke via opencode: the skills live in `.opencode/skills/`.

---

## Project Context Block (for skills)

```
Project: nvim-setup
Type: Personal dotfiles / Neovim configuration
Language: Lua (Neovim config), Bash (scripts)
Platforms: macOS (brew), Kubuntu (apt)
Plugin manager: lazy.nvim
Formatter: StyLua (Lua), prettierd/conform (filetypes)
Linter: nvim-lint
LSP manager: Mason + mason-lspconfig
Colorscheme: Catppuccin Mocha
Leader key: <Space>
Keymap style: VS Code hybrid + Vim modal
Sessions: manual (persistence.nvim)
Format on save: on by default, togglable
DAP: deferred (v2)
AI in nvim: none
Proposals/ADRs: not used (personal repo)
Branch strategy: commit directly to main, Conventional Commits
Compliance: none
```
