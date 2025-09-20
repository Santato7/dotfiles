# Dotfiles

My personal configuration files organized to be used with GNU Stow.

## 📋 Included Configurations

- **Zsh** - Shell configured with Oh My Zsh and custom Headline theme
- **Helix** - Modern text editor with optimized configurations
- **Micro** - Lightweight text editor with useful plugins
- **Hyprland** - Wayland compositor with dual monitor configurations
- **Waybar** - Elegant and functional status bar
- **Git** - Basic configurations and useful aliases

## 🚀 Installation

### Prerequisites

```bash
# Install GNU Stow
sudo pacman -S stow  # Arch Linux
sudo apt install stow  # Ubuntu/Debian
```

### Cloning and applying configurations

```bash
# Clone the repository
git clone https://github.com/santato7/dotfiles.git
cd dotfiles

# Apply all configurations
stow */

# Or apply specific configurations
stow zsh
stow helix
stow hyprland
```

## 🗂️ Structure

```text
dotfiles/
├── git/           # Git configurations
├── helix/         # Helix editor configurations
├── hyprland/      # Hyprland configurations
├── micro/         # Micro editor configurations
├── waybar/        # Waybar configurations
└── zsh/           # Zsh and Oh My Zsh configurations
```

## ⚙️ Key Features

### Zsh

- Oh My Zsh with custom **Headline** theme
- Plugins: git, asdf
- Useful aliases like `gst` for git status
- Integration with tools like zoxide, mise, bun

### Helix

- Starlight theme
- Relative line numbering
- Integration with lf (file manager)
- Custom keybindings for buffer navigation

### Hyprland

- Dual monitor configuration (DP-1 + DVI-D-1)
- Workspaces organized by monitor
- Custom bindings for applications
- Integration with Omarchy

### Micro

- Solarized theme
- Plugins: filemanager, fzf, wc
- Language-specific configurations

## 🛠️ Management

### Adding new configurations

```bash
# Move existing configuration to repository
mv ~/.config/app dotfiles/app/.config/
cd dotfiles
stow app
```

### Removing configurations

```bash
# Remove symlinks
stow -D zsh
```

### Updating configurations

```bash
cd dotfiles
git pull
stow */  # Reapply all configurations
```

## 📝 Notes

- All configurations are organized following GNU Stow structure
- Files are symbolically linked to their appropriate locations
- Backup your existing configurations before applying these dotfiles
- Some configurations may need system-specific adjustments
