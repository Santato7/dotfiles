#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Remove preinstalled web apps we don't want
[[ -f "$HOME/.local/share/applications/Discord.desktop" ]] && omarchy webapp remove Discord

# Packages
omarchy pkg add discord keychain nano stow zsh

# Dotfiles ready to be stowed (the *-omarchy packages need updating first).
# Must run before any `omarchy install` below, since those create default
# configs (helix, oh-my-zsh) only when the target file doesn't exist yet -
# stowing first means our own configs win instead of getting shadowed.
cd "$SCRIPT_DIR"

# Some *-omarchy packages conflict with the plain config files Omarchy ships
# by default. Back those up so stow can symlink instead (a no-op once the
# target is already a symlink, so safe to rerun).
for pkg in hyprland-omarchy waybar-omarchy; do
  while IFS= read -r -d '' f; do
    target="$HOME/${f#"$SCRIPT_DIR/$pkg/"}"
    if [[ -e "$target" && ! -L "$target" ]]; then
      mv "$target" "$target.bak"
    fi
  done < <(find "$SCRIPT_DIR/$pkg" -type f -print0)
done

stow -R git helix micro zsh hyprland-omarchy waybar-omarchy

# Apps
omarchy pkg present google-chrome || omarchy install browser chrome
omarchy default browser chrome
omarchy pkg present helix || omarchy install helix
omarchy pkg present visual-studio-code-bin || omarchy install vscode
omarchy default editor code

# Theme
omarchy theme set Nord

# SSH key (one per machine, not shared)
SSH_KEY="$HOME/.ssh/id_ed25519"
if [[ ! -f "$SSH_KEY" ]]; then
  ssh-keygen -t ed25519 -C "lucas@santato.dev-$(hostname)" -f "$SSH_KEY"
  echo ""
  echo "New SSH key generated. Add the public key to GitHub/GitLab:"
  cat "$SSH_KEY.pub"
  echo ""
fi

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
