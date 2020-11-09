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

#######
# Vim #
#######
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias ez='nvim ~/dotfiles/zsh/zshrc.default'
alias ea='nvim ~/dotfiles/zsh/aliases.zsh'

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
alias cce='conda create --name'
alias jl='jupyter lab'






