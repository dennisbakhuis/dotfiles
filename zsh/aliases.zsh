# My aliases

###########
# General #
###########
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  alias ls='ls --color=auto'
  alias sum='inxi -Fxxxza --no-host'
else
  alias ls='ls -G'
fi
alias sudo='sudo '
alias gpu='nvidia-smi'
alias rr='ranger'
alias ll='ls -l'
alias top='gotop --nvidia'
alias history='history -i'
alias hist='history'

#######
# Vim #
#######
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias ez='nvim ~/dotfiles/zsh/zshrc.default'
alias ea='nvim ~/dotfiles/zsh/aliases.zsh'
export EDITOR=nvim

#######
# Git #
#######
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -v'
alias gs='git status'
alias gr='git reset'

#################
# Conda Jupyter #
#################
alias ca='conda activate'
alias cel='conda env list'
alias crm='conda env remove --name'
alias jl='jupyter lab --ip=0.0.0.0'

##########
# Docker #
##########
alias dps='python3 ~/dotfiles/python/docker-pretty-print/docker-pretty-print.py'
alias dprune='docker system prune -a'

#######################
# Manjaro maintenance #
#######################
alias purge-cache='find ~/.cache/ -type f -atime +100 -delete'
alias delete-orphaned='pacman -Qtdq | pacman -Rns -'

#########
# Azure #
#########
# alias az='~/miniconda3/envs/azure-cli/bin/az'

