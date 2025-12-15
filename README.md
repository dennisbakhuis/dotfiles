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
- **llm** - Command-line tool for interacting with Large Language Models (OpenAI, Anthropic, Google Gemini)
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

## LLM CLI Tool

The `llm` command-line tool is installed for interacting with Large Language Models from the terminal.

### Post-Installation Setup

After running the installer, configure your API keys:

```bash
fish ~/dotfiles/llm_cli/setup_llm_keys.fish
```

Or manually configure individual providers:

```bash
llm keys set openai        # OpenAI (GPT-4, GPT-3.5)
llm keys set anthropic     # Anthropic (Claude)
llm keys set gemini        # Google Gemini
```

### Basic Usage

```bash
# Simple prompt
llm "Explain what Python decorators are"

# Use a specific model
llm -m gpt-4o "Write a haiku about programming"
llm -m claude-3-5-sonnet-20241022 "Explain async/await"

# Pipe input
cat file.py | llm "Explain this code"

# Multi-line prompts
llm << EOF
Review this function and suggest improvements:
$(cat my_function.py)
EOF
```

### Documentation

- Official documentation: https://llm.datasette.io/
- GitHub repository: https://github.com/simonw/llm

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
- `~/.config/llm/config.toml` → `llm_cli/config.toml`

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
