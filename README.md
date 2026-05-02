# nvim-setup

Portable, git-tracked Neovim configuration for macOS and Kubuntu.  
Hand-rolled Lua with `lazy.nvim`. VS Code hybrid keymaps + full modal Vim editing.

---

## Prerequisites

- macOS: [Homebrew](https://brew.sh) must be installed first.
- Kubuntu/Linux: `sudo` access required for apt installs.
- A terminal emulator set to **JetBrainsMono Nerd Font** (installed automatically).

---

## Install

```bash
git clone <this-repo> ~/dotfiles/nvim-setup
cd ~/dotfiles/nvim-setup
./install.sh
```

`install.sh` will:
1. Install system packages (neovim, ripgrep, fd, fzf, node, lazygit, JetBrainsMono Nerd Font)
2. Back up any existing `~/.config/nvim`
3. Symlink `config/nvim/` → `~/.config/nvim`
4. Run a headless plugin sync

---

## Uninstall

```bash
./uninstall.sh
```

Removes the symlink and offers to restore the most recent backup.

---

## After Install

Open Neovim and run:

```
:checkhealth
:Lazy
:Mason
```

- `:checkhealth` — should show no errors (warnings about optional providers are fine)
- `:Lazy` — all plugins should be installed and green
- `:Mason` — LSP servers, formatters, and linters should auto-install on first launch

---

## Smoke Tests

| Action | Expected |
|---|---|
| Open a `.ts` file | LSP attaches, completions work, `<S-A-f>` formats |
| Open a `.tf` file | `terraformls` attaches |
| Open a `.md` file | `marksman` attaches, `prettierd` formats on save |
| `<C-p>` | Telescope file picker opens |
| `<C-b>` | Neo-tree toggles |
| `<C-`>` | Toggleterm opens |

---

## Key References

- `plan.md` — design rationale, plugin choices, keymap strategy
- `CHEATSHEET.md` — printable keymap reference
- `CLAUDE.md` — AI agent context and ways of working

---

## Languages Supported

TypeScript/JS · Bash · Terraform/HCL · YAML · JSON · Markdown · Docker/Compose · Lua

---

## Updating Plugins

```bash
nvim --headless "+Lazy! update" +qa
# Then commit the updated lockfile:
git add config/nvim/lazy-lock.json
git commit -m "chore: update plugin lockfile"
```
