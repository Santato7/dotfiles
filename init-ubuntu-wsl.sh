#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo apt-get update

# Base packages (fzf/bat cover tools used by aliases/fzf preview in .zshrc)
sudo apt-get install -y \
  build-essential curl git stow zsh micro nano keychain tmux \
  ca-certificates gnupg wget fzf bat

# Dotfiles ready to be stowed. hyprland-omarchy/omarchy-shell are Omarchy/
# Hyprland-specific and skipped here.
cd "$SCRIPT_DIR"
stow -R git helix micro tmux zsh

# bat ships as `batcat` on Debian/Ubuntu (name clash with another package) -
# alias it as `bat` so the fzf preview alias in .zshrc works.
mkdir -p "$HOME/.local/bin"
command -v bat >/dev/null 2>&1 || ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"

# eza (not in older Ubuntu repos - use the official apt repo)
if ! command -v eza >/dev/null 2>&1; then
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt-get update
  sudo apt-get install -y eza
fi

# zoxide (official installer keeps it newer than the apt package)
command -v zoxide >/dev/null 2>&1 || curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# Helix - not in default Ubuntu repos, and no snap on WSL, so build from
# source. Runtime files land in ~/.config/helix/runtime, which this repo's
# .gitignore/.stow-local-ignore already carve out as a local, untracked dir.
if ! command -v hx >/dev/null 2>&1; then
  command -v cargo >/dev/null 2>&1 || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"

  HELIX_SRC="$HOME/.local/src/helix"
  if [[ ! -d "$HELIX_SRC" ]]; then
    mkdir -p "$(dirname "$HELIX_SRC")"
    git clone https://github.com/helix-editor/helix "$HELIX_SRC"
  fi
  (cd "$HELIX_SRC" && cargo install --path helix-term --locked --force)
  (cd "$HELIX_SRC" && hx --grammar fetch && hx --grammar build)

  mkdir -p "$HOME/.config/helix"
  rm -rf "$HOME/.config/helix/runtime"
  cp -r "$HELIX_SRC/runtime" "$HOME/.config/helix/runtime"
fi

# Docker (WSL2 here runs systemd, so docker.service can be enabled directly)
if ! command -v docker >/dev/null 2>&1; then
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo usermod -aG docker "$USER"
  sudo systemctl enable --now docker || true
  echo "Docker installed. Log out/in (or 'newgrp docker') for group membership to take effect."
fi

# mise + dev envs (go, ruby, bun, node)
command -v mise >/dev/null 2>&1 || curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"
mise use -g go ruby bun node

# Claude Code
command -v claude >/dev/null 2>&1 || curl -fsSL https://claude.ai/install.sh | bash

# GitHub CLI
if ! command -v gh >/dev/null 2>&1; then
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
  sudo chmod 644 /etc/apt/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
  sudo apt-get update
  sudo apt-get install -y gh
fi

# SSH key (one per machine, not shared)
SSH_KEY="$HOME/.ssh/id_ed25519"
if [[ ! -f "$SSH_KEY" ]]; then
  ssh-keygen -t ed25519 -C "lucas@santato.dev-$(hostname)" -f "$SSH_KEY"
  echo ""
  echo "New SSH key generated. Add the public key to GitHub/GitLab:"
  cat "$SSH_KEY.pub"
  echo ""
fi

# gh auth is an interactive login flow (browser or device code) - not
# something to run unattended here.
gh auth status >/dev/null 2>&1 || echo "Run 'gh auth login' to authenticate the GitHub CLI."

# Zsh as default shell
ZSH_PATH="$(command -v zsh)"
CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"
if [[ "$CURRENT_SHELL" != "$ZSH_PATH" ]]; then
  sudo chsh -s "$ZSH_PATH" "$USER"
fi

# Oh My Zsh (keeps existing .zshrc, e.g. from `stow zsh`)
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Headline theme - copied, not stowed, since a symlink there breaks Oh My Zsh's self-update
mkdir -p "$HOME/.oh-my-zsh/custom/themes"
cp -f "$SCRIPT_DIR/oh-my-zsh/.oh-my-zsh/custom/themes/headline.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/headline.zsh-theme"
