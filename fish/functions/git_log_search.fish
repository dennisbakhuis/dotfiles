function git_log_search
    if not command -v fzf &>/dev/null
        echo "Error: fzf is not installed"
        return 1
    end

    if not git rev-parse --git-dir &>/dev/null
        echo "Error: not in a git repository"
        return 1
    end

    set -l selected (git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" --abbrev-commit $argv |
        fzf --ansi --no-sort --reverse --tiebreak=index \
            --preview 'git show --color=always {1}' \
            --bind 'ctrl-/:toggle-preview' \
            --header 'Press CTRL-/ to toggle preview' |
        awk '{print $1}')

    if test -n "$selected"
        git show $selected
    end
end
