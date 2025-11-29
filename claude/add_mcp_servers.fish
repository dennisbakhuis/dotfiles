#!/usr/bin/env fish

# Post-install script to manually add MCP servers to Claude Code
# Run this after installing dotfiles to set up optional MCP integrations

set_color green
echo "=== Claude Code MCP Server Setup ==="
set_color normal
echo ""

# Context7 MCP Server
set_color cyan
echo "1. Context7 - AI-powered codebase context and search"
set_color normal
echo "   Provides intelligent code search and contextual understanding"
echo ""

read -P "Enter Context7 API key (or press Enter to skip): " -l context7_api_key

if test -n "$context7_api_key"
    echo "Installing Context7 MCP server globally..."
    claude mcp add --global --transport http context7 https://mcp.context7.com/mcp --header "CONTEXT7_API_KEY: $context7_api_key"
    set_color green
    echo "✓ Context7 MCP server installed globally"
    set_color normal
else
    set_color yellow
    echo "⊘ Skipped Context7"
    set_color normal
end

echo ""
set_color green
echo "=== MCP Server Setup Complete ==="
set_color normal
echo ""
