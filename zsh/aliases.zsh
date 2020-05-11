# My aliases

###########
# General #
###########
if [[ $OSTYPE == 'gnu-linux'* ]]; then
  alias ls='ls --color=auto'
else
  alias ls='ls -G'
fi

#######
# Vim #
#######
alias v='vim'
alias ez='vim ~/dotfiles/zsh/zshrc.default'
alias ea='vim ~/dotfiles/zsh/aliases.zsh'


#######
# Git #
#######
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -v'
alias gs='git status'
alias gr='git reset'

#########
# Conda #
#########
alias ca='conda activate'
alias cel='conda env list'



