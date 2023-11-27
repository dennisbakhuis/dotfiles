#######
# fzf #
#######
# fzf is a command-line fuzzy finder. This script will check
# if fzf is installed and if it is, it will enable it.


# Settings
ZSH_INIT_FZF=${ZSH_INIT_FZF:-"true"}    # enable fzf
PRIORITY=130                            # priority of this script


# Check if fzf is installed
if [ "$ZSH_INIT_FZF" = "true" ]; then
    if command -v fzf &> /dev/null; then
        # Check if OS is Mac or Arch
        if [ "$(uname)" = "Darwin" ]; then  # MacOs
            source "/opt/homebrew/opt/fzf/shell/completion.zsh"
            source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"

        elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then  # Arch Linux
            source "/usr/share/fzf/completion.zsh"
            source "/usr/share/fzf/key-bindings.zsh"
        fi
        
        # Use fd for fzf and make it respect .gitignore, .ignore files
        export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

        # Man pages fzf widget (use <C-h>)
        fzf-man-widget() {
            batman="man {1} | col -bx | bat --language=man --plain --color always --theme=\"Monokai Extended\""
            man -k . | sort \
                | awk -v cyan=$(tput setaf 6) -v blue=$(tput setaf 4) -v res=$(tput sgr0) -v bld=$(tput bold) '{ $1=cyan bld $1; $2=res blue;} 1' \
                | fzf  \
                -q "$1" \
                --ansi \
                --tiebreak=begin \
                --prompt=' Man > '  \
                --preview-window '50%,rounded,<50(up,85%,border-bottom)' \
                --preview "${batman}" \
                --bind "enter:execute(man {1})" \
                --bind "alt-c:+change-preview(cht.sh {1})+change-prompt(ﯽ Cheat > )" \
                --bind "alt-m:+change-preview(${batman})+change-prompt( Man > )" \
                --bind "alt-t:+change-preview(tldr --color=always {1})+change-prompt(ﳁ TLDR > )"
            zle reset-prompt
        }
        # `Ctrl-H` keybinding to launch the widget (this widget works only on zsh, don't know how to do it on bash and fish (additionaly pressing`ctrl-backspace` will trigger the widget to be executed too because both share the same keycode)
        bindkey '^h' fzf-man-widget
        zle -N fzf-man-widget
    fi
fi
