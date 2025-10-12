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
end

##########
# Neovim #
##########
if command -v nvim &>/dev/null
    alias v='nvim'
end

# Use eza instead of ls
if command -v eza &>/dev/null
    alias ls='eza --color=always --group-directories-first --icons'
    alias ll='eza -la --icons --octal-permissions --group-directories-first'
    alias l='eza -bGF --header --git --color=always --group-directories-first --icons'
    alias llm='eza -lbGd --header --git --sort=modified --reverse --color=always --group-directories-first --icons'
    alias la='eza --long --all --group --group-directories-first'
    alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons'
    alias lt='eza --tree --level=2 --color=always --group-directories-first --icons'
    alias tree='eza --tree --color=always --group-directories-first --icons'
end

##########
# Python #
##########
alias jl='jupyter lab --ip=0.0.0.0'

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
