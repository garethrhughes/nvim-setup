#!/usr/bin/env bash
# install.sh — Bootstrap portable Neovim config on macOS or Kubuntu
# Usage: ./install.sh
# Re-running is safe: all steps are idempotent.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG_SRC="${REPO_DIR}/config/nvim"
NVIM_CONFIG_DST="${HOME}/.config/nvim"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

# ─── Helpers ────────────────────────────────────────────────────────────────

log()  { printf '\033[1;34m[nvim-setup]\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m[nvim-setup]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[nvim-setup]\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m[nvim-setup]\033[0m ERROR: %s\n' "$*" >&2; exit 1; }

has() { command -v "$1" &>/dev/null; }

backup() {
  local path="$1"
  if [[ -e "$path" || -L "$path" ]]; then
    local backup="${path}.bak.${TIMESTAMP}"
    log "Backing up ${path} → ${backup}"
    mv "$path" "$backup"
  fi
}

# ─── Detect OS ───────────────────────────────────────────────────────────────

OS="$(uname -s)"
case "$OS" in
  Darwin) PLATFORM="macos" ;;
  Linux)
    if grep -qi "ubuntu\|debian" /etc/os-release 2>/dev/null; then
      PLATFORM="linux"
    else
      warn "Unsupported Linux distribution. Proceeding with apt-based install — adjust manually if needed."
      PLATFORM="linux"
    fi
    ;;
  *) die "Unsupported OS: ${OS}" ;;
esac

case "$(uname -m)" in
  x86_64|amd64) ARCH="x86_64" ;;
  aarch64|arm64) ARCH="arm64" ;;
  *) die "Unsupported architecture: $(uname -m)" ;;
esac

log "Detected platform: ${PLATFORM} (${ARCH})"

# ─── Install prerequisites ───────────────────────────────────────────────────

if [[ "$PLATFORM" == "macos" ]]; then
  if ! has brew; then
    die "Homebrew not found. Install it first: https://brew.sh"
  fi

  log "Installing prerequisites via Homebrew..."
  brew update --quiet

  BREW_PACKAGES=(
    neovim
    git
    ripgrep
    fd
    fzf
    node
    python3
    unzip
    curl
    lazygit
    wget
    tree-sitter-cli
  )

  for pkg in "${BREW_PACKAGES[@]}"; do
    if brew list --formula "$pkg" &>/dev/null; then
      ok "${pkg} already installed"
    else
      log "Installing ${pkg}..."
      brew install "$pkg"
    fi
  done

  # Nerd Font
  if ! brew list --cask font-jetbrains-mono-nerd-font &>/dev/null; then
    log "Installing JetBrainsMono Nerd Font..."
    brew install --cask font-jetbrains-mono-nerd-font
  else
    ok "JetBrainsMono Nerd Font already installed"
  fi

elif [[ "$PLATFORM" == "linux" ]]; then
  log "Installing prerequisites via apt..."
  sudo apt-get update -qq

  APT_PACKAGES=(
    git
    curl
    unzip
    wget
    python3
    python3-pip
    xclip
    wl-clipboard
    fd-find
    fzf
    ripgrep
    build-essential
  )

  sudo apt-get install -y "${APT_PACKAGES[@]}"

  # Node via NodeSource (apt version is often outdated)
  if ! has node || [[ "$(node --version | cut -d. -f1 | tr -d v)" -lt 18 ]]; then
    log "Installing Node.js 20 via NodeSource..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
  else
    ok "Node.js $(node --version) already installed"
  fi

  _install_nvim_linux() {
    local tmp asset
    tmp="$(mktemp -d)"
    asset="nvim-linux-${ARCH}.tar.gz"
    curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/${asset}" \
      -o "${tmp}/nvim.tar.gz"
    tar -xzf "${tmp}/nvim.tar.gz" -C "${tmp}"
    sudo install -m 755 "${tmp}/nvim-linux-${ARCH}/bin/nvim" /usr/local/bin/nvim
    rm -rf "$tmp"
  }

  # Neovim: install from GitHub releases if system version is too old
  if has nvim; then
    NVIM_VER="$(nvim --version | head -1 | grep -oP '\d+\.\d+' | head -1)"
    NVIM_MAJOR="$(echo "$NVIM_VER" | cut -d. -f1)"
    NVIM_MINOR="$(echo "$NVIM_VER" | cut -d. -f2)"
    if [[ "$NVIM_MAJOR" -gt 0 ]] || [[ "$NVIM_MINOR" -ge 10 ]]; then
      ok "Neovim ${NVIM_VER} already installed"
    else
      warn "Neovim ${NVIM_VER} is too old (need >= 0.10). Upgrading from GitHub releases..."
      _install_nvim_linux
    fi
  else
    log "Installing Neovim from GitHub releases..."
    _install_nvim_linux
  fi

  # Lazygit
  if ! has lazygit; then
    log "Installing lazygit..."
    LAZYGIT_VERSION="$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
      | grep '"tag_name"' | cut -d'"' -f4 | tr -d v)"
    tmp="$(mktemp -d)"
    curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_linux_${ARCH}.tar.gz" \
      -o "${tmp}/lazygit.tar.gz"
    tar -xzf "${tmp}/lazygit.tar.gz" -C "${tmp}"
    sudo install -m 755 "${tmp}/lazygit" /usr/local/bin/lazygit
    rm -rf "$tmp"
  else
    ok "lazygit already installed"
  fi

  # Nerd Font (JetBrainsMono)
  FONT_DIR="${HOME}/.local/share/fonts"
  if fc-list 2>/dev/null | grep -qi "JetBrainsMono"; then
    ok "JetBrainsMono Nerd Font already installed"
  else
    log "Installing JetBrainsMono Nerd Font..."
    mkdir -p "$FONT_DIR"
    tmp="$(mktemp -d)"
    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
    curl -fsSL "$FONT_URL" -o "${tmp}/JetBrainsMono.tar.xz"
    tar -xJf "${tmp}/JetBrainsMono.tar.xz" -C "$FONT_DIR"
    fc-cache -fv "$FONT_DIR" &>/dev/null
    rm -rf "$tmp"
    ok "JetBrainsMono Nerd Font installed"
  fi
fi

# ─── Back up existing Neovim state ──────────────────────────────────────────

log "Checking for existing Neovim config..."
backup "${NVIM_CONFIG_DST}"
backup "${HOME}/.local/share/nvim"
backup "${HOME}/.local/state/nvim"
backup "${HOME}/.cache/nvim"

# ─── Symlink config ───────────────────────────────────────────────────────────

mkdir -p "${HOME}/.config"
log "Symlinking ${NVIM_CONFIG_SRC} → ${NVIM_CONFIG_DST}"
ln -s "${NVIM_CONFIG_SRC}" "${NVIM_CONFIG_DST}"
ok "Symlink created"

# ─── Plugin sync ─────────────────────────────────────────────────────────────

log "Syncing plugins (headless)..."
nvim --headless "+Lazy! sync" +qa 2>&1 || warn "Lazy sync reported warnings — check :Lazy after first launch"
ok "Plugin sync complete"

# ─── Done ─────────────────────────────────────────────────────────────────────

cat <<'EOF'

╭─────────────────────────────────────────────────────────────────╮
│                  nvim-setup install complete                     │
│                                                                 │
│  Next steps:                                                    │
│    1. Set your terminal font to: JetBrainsMono Nerd Font        │
│    2. Open Neovim:  nvim                                        │
│       (first launch installs Mason packages — give it a minute) │
│    3. Run:  :Mason   (verify LSP servers/formatters installed)  │
│    4. Run:  :checkhealth                                        │
│    5. Run:  :Lazy    (verify all plugins loaded)                │
│                                                                 │
│  See CHEATSHEET.md for the full keymap reference.               │
╰─────────────────────────────────────────────────────────────────╯

EOF
