# Fish Shell Aliases
# Author: Dennis Bakhuis
# Date: 2025-10-10

###########
# General #
###########
alias hist='history'

######
# Git #
######
if command -v git &>/dev/null
    alias g='git'
    alias ga='git add'
    alias gaa='git add --all'
    alias gc='git commit'
    alias gs='git status'
    alias gu='git for-each-ref --sort=-committerdate refs/heads/ refs/remotes/ --format="%(committerdate:relative) %(refname:short) - %(contents:subject)"'
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
    alias ll='lsd -lA --group-directories-first --icon=always'
    alias l='lsd -lF --group-directories-first --icon=always'
    alias llm='lsd -lA --group-directories-first --icon=always --timesort --reverse'
    alias la='lsd --long --all --group-directories-first'
    alias lx='lsd -lA --group-directories-first --icon=always --total-size'
    alias lt='lsd --tree --depth=2 --group-directories-first --icon=always'
    alias tree='lsd --tree --group-directories-first --icon=always'
end

if command -v macmon &>/dev/null
    alias mtop='macmon'
end

##########
# Python #
##########
alias jl='jupyter lab --ip=0.0.0.0'

# uv shortcuts for quick virtual environment creation and activation
if command -v uv &>/dev/null
    # Smart venv function: creates .venv if it doesn't exist, then activates
    function ve
        if not test -d .venv
            echo "Creating virtual environment..."
            uv venv
        end
        source .venv/bin/activate.fish
    end

    # Deactivate virtual environment
    function ved
        if test -n "$VIRTUAL_ENV"
            deactivate
            echo "Virtual environment deactivated"
        else
            echo "No active virtual environment found"
        end
    end

    # Shorter alias
    alias venv='ve'
end

###########
# Kubectl #
###########
alias k='kubectl'
alias kd='kubectl describe'
alias kg='kubectl get'
alias kl='kubectl logs'

##########
# Docker #
##########
alias dprune='docker system prune -a'

##########
# TenneT #
##########
alias main='kubectl config use-context intelligent-document-checker-dpe-dev-aks'
alias ydigital='kubectl config use-context tennet-idc-aks'
alias models='kubectl config use-context tennet-idc-aml-models-aks'
alias argoprod='argo server -n argo --configmap argo-argo-workflows-workflow-controller-configmap --auth-mode=server --secure=false'
alias kubeshell='kubectl run -i --rm --tty ubuntu --image=ubuntu -- bash'
