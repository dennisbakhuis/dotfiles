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
- **tmux** terminal multiplexer (TPM plugins installed automatically)
- **SSH** configuration
- **Neofetch/Fastfetch** (system info, displayed on login shells only)
- **uv** - Fast Python package and project manager
- **Claude Code** - Anthropic's CLI coding assistant (`claude -p "..."` for non-interactive prompts)
- **isomorphic_copy** - Seamless clipboard over SSH
- **gitui** - Blazing fast terminal UI for git

**macOS Only:**
- **macOS system defaults** (Dock, Finder, screenshots, etc.)

### Stage 2 (macOS GUI Applications - Automatic)
**macOS only (automatically installed):**
- **Alacritty** - Terminal emulator with GPU acceleration
- **OrbStack** - Fast, lightweight Docker/Linux container runtime
- **FlashSpace** - Blazingly fast virtual workspace manager

## Fish Shell

Fish is configured with Starship prompt, zoxide for smart navigation, and extensive fzf integration.

### Key Features
- **fzf shortcuts:**
  - `Ctrl+R` - Search command history
  - `Ctrl+T` - Search files
  - `Alt+C` - Change directory (interactive)
  - `Ctrl+Alt+F` - Search files (fzf.fish)
  - `Ctrl+Alt+L` - Search git log
  - `Ctrl+Alt+S` - Search git status

- **Zoxide (smart cd):**
  - `z <dir>` - Jump to frequent/recent directory
  - `zi <dir>` - Interactive directory selection

- **Git aliases:**
  - `gb` - Show branches with merge status
  - `gbd` - Delete branches (local/remote)
  - `gbs` - Switch/create branch
  - `gl` - Search git log with fzf

- **Other:**
  - `aliases` - Show all aliases and keybindings
  - `ve` / `ved` - Enter/exit Python virtual environment (uses uv)
  - `ls` → `lsd` with icons and colors

## tmux

Config lives in `tmux/tmux.conf`; plugins are managed by [TPM](https://github.com/tmux-plugins/tpm).
`install_scripts/tmux.sh` installs TPM and all declared plugins headlessly, so `prefix + I` is not needed on a fresh machine.

### Layout and theme
- One session (`scratch`, started by Alacritty); one window per project.
- Status bar on top, always visible: an amber `^B` badge while the prefix is active, the window list, Claude sessions waiting for input, the host when over SSH, and a clock only in macOS full screen (when the menu bar clock is hidden). It shares the terminal background.
- Each window tab shows the state of the Claude sessions inside it with Nerd Font icons: cog running, lock wants a permission, speech bubble waiting for an answer, check finished but not looked at yet, moon idle, warning error.
- Deep-sea navy theme shared with Alacritty (`#001728` background, cyan `#0db9d7` accent, green running, amber waiting, red error). The palette is listed at the top of the theme block in `tmux/tmux.conf`.

### Keys (prefix `Ctrl-b`)
- `Tab` - throwaway shell popup in the current folder
- `g` - gitui popup
- `t` - directory tree popup (`q` closes)
- `Backspace` - last window
- `|` / `-` - split, `h/j/k/l` - move between panes, `H/J/K/L` - resize
- `r` - reload config

### Plugins
- **tmux-sensible** - sane defaults
- **tmux-resurrect** + **tmux-continuum** - save windows, folders and layout every 15 minutes and restore them when tmux starts (e.g. after a reboot). Claude sessions are not restarted: run `claude --continue` in each window. `prefix Ctrl-s` / `prefix Ctrl-r` save and restore by hand.
### Claude session marks
The marks on the window tabs and the "N waiting" count come from a small hook script, not a plugin:
- `scripts/claude-tmux-status.sh` is called by Claude Code hooks (declared in `claude/settings.json`: SessionStart, UserPromptSubmit, PreToolUse, PostToolUse, Notification, Stop, StopFailure, SessionEnd) and stores the session state on its tmux pane (`@pane_status`, `@pane_wait_reason`).
- `tmux/tmux.conf` reads those options in the window tab format; tmux hooks on window switch and terminal focus turn a finished session's check into idle once you look at it; `scripts/tmux-status-right.sh` counts waiting sessions and clears marks left by a Claude that was killed.
- Nothing extra to install: it works on any machine with these dotfiles and tmux. Sessions started before the hooks were added need a restart.

## Configuration Structure

Configurations are symlinked to your home directory:
- `~/.config/fish/` → `fish/`
- `~/.config/nvim` → `nvim/`
- `~/.tmux.conf` → `tmux/tmux.conf`
- `~/.gitconfig` → `git/gitconfig`
- `~/.config/alacritty/alacritty.toml` → `alacritty/alacritty.macos.toml` (macOS) or `alacritty/alacritty.linux.toml` (Linux)
- `~/.config/flashspace/profiles.toml` → `flashspace/profiles.toml` (macOS only)
- `~/.config/flashspace/settings.toml` → `flashspace/settings.toml` (macOS only)
- `~/.claude/settings.json` → `claude/settings.json`
- `~/.claude/CLAUDE.md` → `claude/CLAUDE.md`

## VSCode

VSCode configurations include project-wide diagnostics, custom keybindings, and formatter settings.

### Key Features
- **Project-wide diagnostics** - See problems in all files (Python, TypeScript/JavaScript)
- **Format on save** - Black (Python), Prettier (JS/TS/JSON)
- **Custom terminal shortcuts:**
  - `cmd+\` - Toggle terminal open/close
  - `cmd+option+\` - Cycle through terminal sessions
  - `ctrl+shift+` - New terminal

**Note:** VSCode settings are in `vscode/` but need to be manually copied to your VSCode settings location.

## Claude Code

Claude Code settings and global instructions are automatically symlinked during installation.

### Notification Chime

A `Notification` hook in `claude/settings.json` plays `Glass.aiff` (macOS `afplay`) when Claude Code is waiting for input. It's guarded by a toggle file so you can flip it on/off without editing settings:

```fish
touch ~/.claude-chime   # enable
rm ~/.claude-chime      # disable
```

No restart needed. On Linux, swap `afplay /System/Library/Sounds/Glass.aiff` for `paplay /usr/share/sounds/freedesktop/stereo/message.oga`.

### Optional: MCP Server Setup

After installing dotfiles, you can optionally set up MCP (Model Context Protocol) servers for enhanced Claude Code functionality:

```fish
~/dotfiles/claude/add_mcp_servers.fish
```

This interactive script will help you configure:
- **Context7** - AI-powered codebase context and search (requires API key)

The script also provides recommendations for other useful MCP servers including filesystem, GitHub, Brave Search, PostgreSQL, Puppeteer, and Slack integrations.

## Supported Systems

- **macOS** (Intel and Apple Silicon)
- **Arch Linux** (including ARM variants)
- **Ubuntu** (and Debian-based distributions)
