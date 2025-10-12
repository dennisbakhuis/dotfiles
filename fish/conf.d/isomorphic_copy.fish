# ====================================================================
# Isomorphic Copy Integration
# ====================================================================
# Enables seamless clipboard operations between local and remote systems
# over SSH connections. This allows you to copy/paste between Neovim,
# terminal, and system clipboard even when working on remote machines.
#
# Author: Dennis Bakhuis
# Date: 2025-10-11
# ====================================================================

# Check if isomorphic_copy is installed
set -l isomorphic_copy_path "$HOME/.tools/isomorphic_copy"

if test -d "$isomorphic_copy_path"
    # Add isomorphic_copy bin directory to PATH
    fish_add_path "$isomorphic_copy_path/bin"

    # Note: aliases are not needed as the bin directory contains
    # pbcopy and pbpaste symlinks that work directly
end