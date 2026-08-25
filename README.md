# Dotfiles

My personal configuration files, managed with GNU Stow, for Omarchy (Arch/Hyprland) and Ubuntu/WSL.

## 📋 Included Configurations

- **Zsh** - Shell config, Oh My Zsh, custom Headline theme
- **Helix** - Modern text editor
- **Micro** - Lightweight text editor with plugins
- **Git** - Config, aliases, and a `ds3` work identity (`includeIf` on `~/projects/ds3/`)
- **SSH** - `~/.ssh/config` host aliases (`github.com`, `ds3`)
- **Tmux** - Terminal multiplexer config
- **Claude Code** - Global `CLAUDE.md`, `settings.json`, and a custom skill
- **Hyprland-Omarchy** - Wayland compositor config (Quattro-era Lua: `monitors.lua`, `input.lua`, `bindings.lua`, `looknfeel.lua`)
- **Omarchy-Shell** - Bar layout, widgets, idle/lock timing, and a custom `santato.sysinfo` bar plugin (CPU/RAM/temp/disk)
- **Foot** - Terminal config (Alacritty-style Ctrl+Shift+C/V clipboard bindings)

## 🌿 Branches

- **`main`** - Desktop: dual monitor (DP-3 + HDMI-A-1), AMD Ryzen 7 7800X3D
- **`notebook`** - Laptop: single panel (`eDP-1`), Intel CPU

The two branches only diverge on `hyprland-omarchy/.config/hypr/monitors.lua` (monitor topology and workspace-to-monitor assignment). Everything else is shared and kept in sync by merging `main` into `notebook`.

## 🚀 Installation

### Prerequisites

```bash
# Install GNU Stow
sudo pacman -S stow  # Arch Linux
sudo apt install stow  # Ubuntu/Debian
```

### Cloning and applying configurations

```bash
git clone git@github.com:Santato7/dotfiles.git
cd dotfiles

# Apply everything
stow */

# Or specific packages
stow zsh helix git ssh
stow hyprland-omarchy omarchy-shell foot   # Omarchy only
```

### Initialization scripts

```bash
./init-omarchy.sh       # Omarchy: packages, stow, SSH keys, theme, shell, Oh My Zsh
./init-ubuntu-wsl.sh    # Ubuntu/WSL: subset of the above, no Hyprland/Omarchy packages
```

Both scripts back up any plain (non-symlink) file already at a stow target before linking, so they're safe to rerun.

## 🗂️ Structure

```text
dotfiles/
├── claude-code/        # Claude Code global config and skills
├── foot/               # Foot terminal configuration
├── git/                # Git config, aliases, ds3 work identity
├── helix/              # Helix editor configuration
├── hyprland-omarchy/   # Hyprland config for Omarchy (Quattro Lua)
├── micro/              # Micro editor configuration
├── oh-my-zsh/          # Custom Headline theme
├── omarchy-shell/      # Omarchy shell (bar/idle/plugins) configuration
├── ssh/                # SSH config (host aliases)
├── tmux/               # Tmux configuration
├── zsh/                # Zsh configuration
├── init-omarchy.sh     # Omarchy initialization script
├── init-ubuntu-wsl.sh  # Ubuntu/WSL initialization script
└── README.md           # This file
```

## ⚙️ Key Features

### Zsh

- Oh My Zsh with custom **Headline** theme
- Aliases like `gst` for git status
- Integration with zoxide, mise, bun, keychain
- Sources `~/.zshrc.local` if present (untracked - see Notes)

### Helix

- Starlight theme, relative line numbers, `lf` integration

### Hyprland (Omarchy)

- Per-branch monitor topology (see Branches above)
- Custom bindings only for what actually diverges from Omarchy's own defaults (`Super+Shift+W` → Typora, `Super+Alt+Return` → named tmux session)
- Workspace gaps, Discord/Spotify placement, and `persistent = true` on all 10 workspaces (so the bar shows 1-0) live in `looknfeel.lua`, shared across branches

### Micro

- Solarized theme, filemanager/fzf/wc plugins

### Omarchy Shell

- Bar layout (menu, workspaces, clock as `dd/MM/yyyy HH:mm`, weather, tray, network, audio, power, etc.)
- Idle/lock timing (`~/.config/omarchy/shell.json`)
- `santato.sysinfo`: custom bar plugin showing CPU %, temperature (Intel and AMD/k10temp), RAM, and disk usage, colored from the active theme's palette
- Runs on Quickshell, replacing Waybar/hypridle from pre-Quattro Omarchy

### Git / SSH

- Personal identity by default; `ds3` work identity auto-applied under `~/projects/ds3/`
- Two SSH keys (`id_ed25519`, `id_ed25519_ds3`), selected via the `ds3` Host alias

## 📝 Notes

- Company-specific secrets (VPN host/cert, etc.) live in `~/.zshrc.local`, which is **not** tracked - keeps that out of this public repo
- `init-omarchy.sh` and `init-ubuntu-wsl.sh` are idempotent: rerunning either only touches what's actually missing or out of date
- After editing anything under `omarchy-shell/.config/omarchy/plugins/`, a brand new plugin directory needs `omarchy restart shell` once (hot-reload only reliably picks up edits to already-loaded plugin files)
