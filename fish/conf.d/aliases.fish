# Fish Shell Aliases
# Author: Dennis Bakhuis
# Date: 2025-11-20

# Source custom functions
source $HOME/dotfiles/fish/functions/aliases_info.fish
source $HOME/dotfiles/fish/functions/git_branches.fish
source $HOME/dotfiles/fish/functions/git_branch_delete.fish
source $HOME/dotfiles/fish/functions/git_log_search.fish

###########
# General #
###########
alias reload='exec fish'  # Reload Fish shell
alias aliases='aliases_info'  # Show aliases and key bindings

#######
# Git #
#######
if command -v git &>/dev/null
    alias g='git'
    alias ga='git add'
    alias gc='git commit'
    alias gs='git status'
    alias gb='git_branches'  # Show branches with merge status and activity
    alias gbd='git_branch_delete'  # Delete local and/or remote branches
    alias gl='git_log_search'  # Search git log with fzf
end

##########
# Neovim #
##########
if command -v nvim &>/dev/null
    alias v='nvim'
end

# Use lsd instead of ls
if command -v lsd &>/dev/null
    alias ls='lsd --group-directories-first --icon=always'
    alias l='ls'
    alias ll='lsd -lA --group-directories-first --icon=always'
    alias lt='lsd --tree --depth=2 --group-directories-first --icon=always'
    alias tree='lsd --tree --group-directories-first --icon=always'
end

if command -v macmon &>/dev/null
    alias mtop='macmon'  # Mac specialized htop
end

##########
# Python #
##########
alias jl='jupyter lab --ip=0.0.0.0'

if command -v uv &>/dev/null
    function virtual_environment
        if not test -d .venv
            echo "Creating virtual environment..."
            uv venv
        end
        source .venv/bin/activate.fish
    end

    function virtual_environment_deactivate
        if test -n "$VIRTUAL_ENV"
            deactivate
            echo "Virtual environment deactivated"
        else
            echo "No active virtual environment found"
        end
    end

    alias ve='virtual_environment'  # Enter python virtual environment
    alias ved='virtual_environment_deactivate'  # Deactivate python virtual environment
end

###########
# Kubectl #
###########
alias k='kubectl'
alias kd='kubectl describe'
alias kg='kubectl get'
alias kl='kubectl logs'
alias kubeshell='kubectl run -i --rm --tty ubuntu --image=ubuntu -- bash'  # Open shell within k8s cluster

##########
# Docker #
##########
alias dprune='docker system prune -a'
