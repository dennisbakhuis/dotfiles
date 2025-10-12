# Neovim Configuration

A minimal, sensible Neovim configuration using Lua and lazy.nvim plugin manager.

## Features

- **Plugin Manager**: lazy.nvim (auto-installs on first run)
- **Theme**: Tokyo Night (matches Alacritty theme)
- **Fuzzy Finder**: Telescope with fzf
- **Syntax Highlighting**: Treesitter
- **Status Line**: Lualine
- **Git Integration**: Gitsigns
- **Editor Enhancements**: Comment, Autopairs, Surround, Indent guides, Which-key

## Structure

```
nvim/
├── init.lua              # Entry point
├── lua/
│   ├── config/
│   │   ├── options.lua   # Vim options
│   │   ├── keymaps.lua   # Key mappings
│   │   └── autocmds.lua  # Autocommands
│   └── plugins/
│       ├── colorscheme.lua
│       ├── treesitter.lua
│       ├── telescope.lua
│       ├── lualine.lua
│       └── editor.lua
└── README.md
```

## Key Mappings

**Leader key**: `<Space>`

### General
- `<Space>w` - Save file
- `<Space>q` - Quit
- `<Space>Q` - Quit all
- `jk` / `kj` - Exit insert mode
- `<Esc>` - Clear search highlights

### Navigation
- `<C-h/j/k/l>` - Move between windows
- `<S-h>` / `<S-l>` - Previous/next buffer
- `<C-arrows>` - Resize windows
- `<A-j>` / `<A-k>` - Move lines up/down

### File Explorer
- `<Space>e` - Open file explorer (Netrw)

### Telescope (Fuzzy Finder)
- `<Space>ff` - Find files
- `<Space>fg` - Live grep
- `<Space>fb` - Find buffers
- `<Space>fh` - Help tags
- `<Space>fr` - Recent files
- `<Space>fc` - Find word under cursor

### Splits & Tabs
- `<Space>sv` - Split vertically
- `<Space>sh` - Split horizontally
- `<Space>se` - Make splits equal size
- `<Space>sx` - Close current split
- `<Space>to` - New tab
- `<Space>tx` - Close tab
- `<Space>tn` / `<Space>tp` - Next/previous tab

### Git
- `]c` / `[c` - Next/previous hunk
- `<Space>hs` - Stage hunk
- `<Space>hr` - Reset hunk
- `<Space>hp` - Preview hunk
- `<Space>hb` - Blame line

### Terminal
- `<Space>tt` - Open terminal
- `<Esc>` - Exit terminal mode
- `<C-h/j/k/l>` - Navigate from terminal

### Editing
- `<` / `>` - Indent/dedent (stays in visual mode)
- `<Space>d` - Delete without yanking
- `gcc` - Comment line (Comment.nvim)
- `gc` - Comment selection (Comment.nvim)

## First Run

On first startup, lazy.nvim will automatically:
1. Install itself
2. Install all configured plugins
3. Install Treesitter parsers

This may take a minute. After installation completes, restart Neovim.

## Requirements

- Neovim >= 0.9.0
- Git
- A Nerd Font (for icons)
- ripgrep (for Telescope live_grep)
- fd (for Telescope find_files)
- Node.js (for Treesitter)

All requirements are installed by the main dotfiles installer.