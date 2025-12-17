#!/bin/bash
##########################
# Claude Code Settings   #
##########################
print_header "Claude Code Settings"

CLAUDE_DIR="$HOME/.claude"

# Create .claude directory if it doesn't exist
if [ ! -d "$CLAUDE_DIR" ]; then
    print_step "Creating $CLAUDE_DIR directory"
    mkdir -p "$CLAUDE_DIR"
    print_success "Created $CLAUDE_DIR directory"
fi

# Link settings.json file
if [ -f "$CLAUDE_DIR/settings.json" ] || [ -L "$CLAUDE_DIR/settings.json" ]; then
    if [ ! -L "$CLAUDE_DIR/settings.json" ]; then
        print_info "settings.json already exists (not a symlink)"
        print_step "Backing up existing settings.json to settings.json.backup"
        mv "$CLAUDE_DIR/settings.json" "$CLAUDE_DIR/settings.json.backup"
    else
        print_step "Removing existing settings.json symlink"
        rm "$CLAUDE_DIR/settings.json"
    fi
fi

print_step "Linking settings.json to $CLAUDE_DIR/settings.json"
ln -sf "$DOTFILES_ROOT/claude/settings.json" "$CLAUDE_DIR/settings.json"
print_success "Linked settings.json"

# Link CLAUDE.md file
if [ -f "$CLAUDE_DIR/CLAUDE.md" ] || [ -L "$CLAUDE_DIR/CLAUDE.md" ]; then
    if [ ! -L "$CLAUDE_DIR/CLAUDE.md" ]; then
        print_info "CLAUDE.md already exists (not a symlink)"
        print_step "Backing up existing CLAUDE.md to CLAUDE.md.backup"
        mv "$CLAUDE_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md.backup"
    else
        print_step "Removing existing CLAUDE.md symlink"
        rm "$CLAUDE_DIR/CLAUDE.md"
    fi
fi

print_step "Linking CLAUDE.md to $CLAUDE_DIR/CLAUDE.md"
ln -sf "$DOTFILES_ROOT/claude/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
print_success "Linked CLAUDE.md"

print_success "Claude Code settings configured"
