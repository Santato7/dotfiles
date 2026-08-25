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
- **Hyprland-Omarchy** - Wayland compositor configured for Omarchy (Quattro Lua config)
- **Omarchy-Shell** - Bar layout, widgets, and idle/lock timing for the Omarchy shell (Quickshell)
- **Foot** - Terminal config (Alacritty-style Ctrl+Shift+C/V clipboard bindings)
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
stow omarchy-shell
stow foot
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
├── foot/               # Foot terminal configuration
├── git/                # Git configurations
├── helix/              # Helix editor configurations
├── hyprland-omarchy/   # Hyprland configurations for Omarchy (Quattro Lua config)
├── micro/              # Micro editor configurations
├── oh-my-zsh/          # Custom Headline theme and configurations
├── omarchy-shell/      # Omarchy shell (bar/idle) configuration
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

- Optimized dual monitor configuration (DP-3 + HDMI-A-1)
- Workspaces organized by monitor
- Custom bindings for applications not already covered by Omarchy's defaults
- Full Omarchy integration (Quattro-era Lua config: `monitors.lua`, `input.lua`, `bindings.lua`)
- Support for web apps and native Discord

### Micro

- Solarized theme
- Plugins: filemanager, fzf, wc
- Language-specific configurations
- Custom keybindings

### Omarchy Shell

- Bar layout (menu, workspaces, clock, weather, tray, network, audio, power, etc.)
- Idle/lock timing (`~/.config/omarchy/shell.json`)
- Runs on Quickshell, replacing Waybar/hypridle from pre-Quattro Omarchy

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
