# Dotfiles

My personal configuration files organized to be used with GNU Stow.

## 📋 Included Configurations

- **Zsh** - Shell config## 🔧 Included Scripts

- **`init-omarchy.sh`** - Initialization script that removes Discord webapp and installs necessary dependencies

## 📝 Notes

- All configurations are organized following GNU Stow structure
- Files are symbolically linked to their appropriate locations
- Backup your existing configurations before applying these dotfiles
- Omarchy configurations require Omarchy system installed
- Some configurations may need system-specific adjustments
- The Headline theme includes SSH, Git, and development tools integration

## 🎨 Headline Theme

The custom theme includes:

- Visual indicators for Git status
- Custom user and host information
- Virtual environment support
- Special characters and Nerd Font icons
- Customizable clock in promptOh My Zsh and custom Headline theme
- **Helix** - Modern text editor with optimized configurations
- **Micro** - Lightweight text editor with useful plugins
- **Hyprland-Omarchy** - Wayland compositor configured for Omarchy
- **Waybar-Omarchy** - Status bar integrated with Omarchy theme
- **UWSM-Omarchy** - Universal Wayland Session Manager for Omarchy
- **Oh My Zsh** - Custom Headline theme and configurations
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
stow hyprland-omarchy
stow micro
```

### Omarchy Initialization (Optional)

```bash
# Run the Omarchy initialization script
./init-omarchy.sh
```

## 🗂️ Structure

```text
dotfiles/
├── git/                # Git configurations
├── helix/              # Helix editor configurations
├── hyprland-omarchy/   # Hyprland configurations for Omarchy
├── micro/              # Micro editor configurations
├── oh-my-zsh/          # Custom Headline theme and configurations
├── uwsm-omarchy/       # UWSM configurations for Omarchy
├── waybar-omarchy/     # Waybar configurations for Omarchy
├── zsh/                # Zsh configurations
├── init-omarchy.sh     # Omarchy initialization script
└── README.md           # This file
```

## ⚙️ Key Features

### Zsh

- Oh My Zsh with custom **Headline** theme
- Plugins: git, asdf
- Useful aliases like `gst` for git status
- Integration with tools like zoxide, mise, bun, keychain

### Helix

- Starlight theme
- Relative line numbering
- Integration with lf (file manager)
- Custom keybindings for buffer navigation

### Hyprland (Omarchy)

- Optimized dual monitor configuration (DP-1 + DVI-D-1)
- Workspaces organized by monitor
- Custom bindings for applications
- Full Omarchy integration
- Support for web apps and native Discord

### Micro

- Solarized theme
- Plugins: filemanager, fzf, wc
- Language-specific configurations
- Custom keybindings

### UWSM (Omarchy)

- Environment configuration for Wayland sessions
- Default terminal (alacritty) and editor (code) settings
- Omarchy integration with path management
- Automatic mise activation

### Waybar (Omarchy)

- Interface integrated with Omarchy theme
- Custom indicators and widgets
- System monitoring support
- Integrated Omarchy menu

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

## � Included Scripts

- **`init-omarchy.sh`** - Initialization script that removes Discord webapp and installs necessary dependencies

## �📝 Notes

- All configurations are organized following GNU Stow structure
- Files are symbolically linked to their appropriate locations
- Backup your existing configurations before applying these dotfiles
- Some configurations may need system-specific adjustments
