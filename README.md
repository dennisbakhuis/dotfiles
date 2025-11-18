# Dotfiles
Author: Dennis Bakhuis

Cross-platform dotfiles for macOS, Arch Linux, and Ubuntu. Includes configuration for Fish shell, Neovim, tmux, Git, and various CLI tools.
Note: these are my preferred defaults. Use at your own risk.

## Prerequisites

Before installing, it is assumed that you have the following already installed/available:

### macOS Only
- **Homebrew** must be installed
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```

### All Systems
- **Git** must be installed
  ```bash
  # Arch Linux
  sudo pacman -S git

  # Ubuntu
  sudo apt-get install git

  # macOS (if Xcode Command Line Tools not installed)
  xcode-select --install
  ```

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Run the installer:
   ```bash
   ./install.sh
   ```

### Idempotency

The installer is fully idempotent and can be safely run multiple times on the same system. It will:
- Skip installation of tools that are already installed
- Backup existing configuration files before replacing them (timestamped backups)
- Safely handle existing symlinks from previous installations
- Only change the default shell if it's not already set to Fish

This means you can:
- Re-run the installer after updating this repository to get new configurations
- Run it on systems with partial installations
- Run it on systems that have existing configurations (they will be backed up)

### Special Cases

#### Arch Linux - First Time Setup (as root)
If you're setting up a fresh Arch system, first run as root to set up the base system:
```bash
sudo ./install.sh  # Creates base user and system setup
```
Then run again as the created user:
```bash
./install.sh  # Installs dotfiles and tools
```

#### macOS GUI Applications
On macOS, Stage 2 (GUI applications) installs automatically when you run the installer. No additional environment variables are needed.

## What Gets Installed

### Stage 1 (Core CLI Environment)
**All Platforms:**
- **Fish shell** with Starship prompt, eza, and Fisher plugin manager
  - Includes **fzf.fish plugin** for enhanced fuzzy finding (Ctrl+R history, Ctrl+Alt+F files, etc.)
- **Neovim** with Node.js, npm, and cmake
- **fzf** with ripgrep, bat, and fd
- **Git** configuration
- **tmux** terminal multiplexer
- **SSH** configuration
- **Neofetch/Zeitfetch** (system info, displayed on login shells only)
- **uv** - Fast Python package and project manager
- **isomorphic_copy** - Seamless clipboard over SSH
- **gitui** - Blazing fast terminal UI for git

**macOS Only:**
- **macOS system defaults** (Dock, Finder, screenshots, etc.)

### Stage 2 (macOS GUI Applications - Automatic)
**macOS only (automatically installed):**
- **Alacritty** - Terminal emulator with GPU acceleration
- **OrbStack** - Fast, lightweight Docker/Linux container runtime
- **FlashSpace** - Blazingly fast virtual workspace manager

## Configuration Structure

Configurations are symlinked to your home directory:
- `~/.config/fish/` → `fish/`
- `~/.config/nvim` → `nvim/`
- `~/.tmux.conf` → `tmux/tmux.conf`
- `~/.gitconfig` → `git/gitconfig`
- `~/.config/alacritty/alacritty.toml` → `alacritty/alacritty.macos.toml` (macOS) or `alacritty/alacritty.linux.toml` (Linux)
- `~/.config/flashspace/profiles.toml` → `flashspace/profiles.toml` (macOS only)
- `~/.config/flashspace/settings.toml` → `flashspace/settings.toml` (macOS only)

## Supported Systems

- **macOS** (Intel and Apple Silicon)
- **Arch Linux** (including ARM variants)
- **Ubuntu** (and Debian-based distributions)
