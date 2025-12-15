# Dotfiles Repository Structure

## Overview

Cross-platform dotfiles for macOS, Arch Linux, and Ubuntu. The repository uses a modular design with idempotent install scripts and symlinked configurations.

## Directory Structure

```
dotfiles/
├── install.sh                 # Main installer orchestrates all components
├── install_scripts/           # Individual component installers
│   ├── fish.sh               # Shell installation
│   ├── git.sh                # Git configuration
│   ├── neovim.sh             # Neovim setup
│   └── mac_gui_apps/         # macOS GUI applications
├── fish/                      # Fish shell config (symlinked to ~/.config/fish/)
│   ├── config.fish
│   ├── conf.d/               # Modular config files
│   ├── functions/            # Custom Fish functions
│   └── completions/          # Shell completions
├── git/                       # Git config (symlinked to ~/.gitconfig)
├── nvim/                      # Neovim config (symlinked to ~/.config/nvim/)
├── tmux/                      # Tmux config (symlinked to ~/.tmux.conf)
├── ssh/                       # SSH config (symlinked to ~/.ssh/config)
├── claude/                    # Claude Code settings (symlinked to ~/.claude/)
├── llm_cli/                   # LLM CLI tool config and setup scripts
│   ├── config.toml           # LLM configuration (symlinked to ~/.config/llm/)
│   └── setup_llm_keys.fish   # Post-install helper for Anthropic setup
├── vscode/                    # VSCode settings (manual copy required)
├── alacritty/                 # Terminal emulator config (macOS/Linux specific)
└── scripts/                   # Utility scripts (Azure, testing, etc.)
```

## Configuration Organization

All configurations use **symlinks** (except VSCode, which requires manual copying):

- Fish: `~/.config/fish/` → `$DOTFILES_ROOT/fish/`
- Git: `~/.gitconfig` → `$DOTFILES_ROOT/git/gitconfig`
- Neovim: `~/.config/nvim/` → `$DOTFILES_ROOT/nvim/`
- Tmux: `~/.tmux.conf` → `$DOTFILES_ROOT/tmux/tmux.conf`
- Claude: `~/.claude/settings.json` → `$DOTFILES_ROOT/claude/settings.json`
- LLM: `~/.config/llm/config.toml` → `$DOTFILES_ROOT/llm_cli/config.toml`
- Alacritty: Platform-specific (`.macos.toml` or `.linux.toml`)

This approach means:
- Edit files in the dotfiles repo → changes apply immediately
- Easy version control of all configurations
- No need to manually sync changes

## Install Process

### Prerequisites
- Git must be installed
- macOS: Homebrew must be installed
- Linux: Standard package managers (pacman/apt)

### Installation Stages

**Stage 0** (Arch only, as root):
- Creates base user with sudo privileges
- Sets up minimal Arch system
- Run once, then switch to created user

**Stage 1** (Core CLI, all platforms):
- Installs Fish, Neovim, fzf, tmux, Git, uv, llm, etc.
- Sets up configurations via symlinks
- Applies macOS defaults (if on macOS)
- Order matters: components depend on earlier installations

**Stage 2** (macOS GUI, automatic):
- Installs Alacritty, OrbStack, FlashSpace, VSCode, etc.
- Runs automatically on macOS (no environment variable needed)
- Skipped on Linux

### Component Scripts

Each `install_scripts/*.sh` file:
1. Checks if component is already installed
2. Installs via appropriate package manager if missing
3. Backs up existing configs (timestamped)
4. Creates symlinks to dotfiles repo
5. Applies component-specific settings

## Idempotency

**The installer is fully idempotent** and safe to run multiple times:

### What Gets Checked
- ✓ Tool already installed? → Skip installation, proceed to config
- ✓ Config is already a symlink? → Remove old symlink, create new one
- ✓ Config exists but isn't a symlink? → Backup with timestamp, then symlink
- ✓ Default shell already Fish? → Skip shell change
- ✓ Fisher plugin already installed? → Skip installation

### Backup Strategy
- Existing configurations: `~/.config/fish.backup.20250129_143022/`
- Timestamped to prevent overwriting previous backups
- Original configs never destroyed without backup

### Safe Re-runs
You can safely re-run `./install.sh` to:
- Update configurations after pulling repo changes
- Repair broken symlinks
- Complete partial installations
- Add new components added to install scripts

### Example Idempotent Checks

```sh
# From fish.sh - checks before installing
if [ ! -x "$(command -v fish)" ]; then
    # Install fish
else
    # Already installed, skip
fi

# Backup existing config before symlinking
if [ -d "$HOME/.config/fish" ] && [ ! -L "$HOME/.config/fish" ]; then
    mv "$HOME/.config/fish" "$HOME/.config/fish.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Always safe to re-link (uses -sf force flag)
ln -sf $DOTFILES_ROOT/fish/config.fish $HOME/.config/fish/config.fish
```

## Platform Detection

The installer auto-detects OS and sets appropriate package managers:
- macOS: `brew install`
- Arch: `sudo pacman -S --noconfirm`
- Ubuntu: `sudo apt-get install -y`

All install scripts use `$PKG_INSTALL_NONINTERACTIVE` for automation.

## Key Design Principles

1. **Modular**: Each component is self-contained in `install_scripts/`
2. **Idempotent**: Safe to run repeatedly, checks before actions
3. **Non-destructive**: Always backs up before replacing
4. **Symlinked**: Edit in repo, changes apply immediately
5. **Cross-platform**: Single codebase for macOS/Arch/Ubuntu
6. **Ordered execution**: Components installed in dependency order

## Post-Install Configuration

Some tools require additional setup after installation:

### LLM CLI Tool

The `llm` command-line tool for interacting with Large Language Models (Claude, GPT, Gemini) is installed but requires API key configuration.

**Post-install script**: `llm_cli/setup_llm_keys.fish`

This script:
1. Installs the `llm-anthropic` plugin
2. Prompts for Anthropic API key (get from https://console.anthropic.com/settings/keys)
3. Configures the key: `llm keys set anthropic`
4. Sets default model: `llm models default claude-sonnet-4.5`

**Usage**:
```bash
fish ~/dotfiles/llm_cli/setup_llm_keys.fish
```

**Manual configuration**:
```bash
llm install llm-anthropic
llm keys set anthropic
llm models default claude-sonnet-4.5
```

### Claude Code MCP Servers

The Claude Code MCP server setup is similar - see `claude/add_mcp_servers.fish` for installing Context7 and other MCP integrations.

**Usage**:
```bash
fish ~/dotfiles/claude/add_mcp_servers.fish
```
