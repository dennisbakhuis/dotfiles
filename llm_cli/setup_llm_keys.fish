#!/usr/bin/env fish

# Post-install script to configure LLM for Anthropic Claude
# Run this after installing dotfiles to set up Claude models

set_color green
echo "=== LLM Anthropic Setup ==="
set_color normal
echo ""

# Install Anthropic plugin
set_color cyan
echo "1. Installing llm-anthropic plugin..."
set_color normal
llm install llm-anthropic
set_color green
echo "✓ llm-anthropic plugin installed"
set_color normal
echo ""

# Configure Anthropic API key
set_color cyan
echo "2. Configure Anthropic API Key"
set_color normal
echo "   Get your API key at: https://console.anthropic.com/settings/keys"
echo ""
read -P "Enter Anthropic API key: " -l anthropic_key

if test -n "$anthropic_key"
    echo "$anthropic_key" | llm keys set anthropic
    set_color green
    echo "✓ Anthropic API key configured"
    set_color normal
else
    set_color red
    echo "✗ No API key provided. Skipping setup."
    set_color normal
    exit 1
end

echo ""

# Set default model
set_color cyan
echo "3. Setting default model to Claude Sonnet 4.5..."
set_color normal
llm models default claude-sonnet-4.5
set_color green
echo "✓ Default model set to claude-sonnet-4.5"
set_color normal

echo ""
set_color green
echo "=== LLM Setup Complete ==="
set_color normal
echo ""
echo "Test your setup with:"
echo "  llm 'Hello, world!'"
echo ""
echo "For more information:"
echo "  llm --help"
echo "  https://llm.datasette.io/"
echo ""
