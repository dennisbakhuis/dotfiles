function aliases_info
    echo "My Aliases:"
    echo "==========="

    set -l aliases_file "$HOME/dotfiles/fish/conf.d/aliases.fish"

    if not test -f $aliases_file
        set aliases_file "$HOME/.config/fish/conf.d/aliases.fish"
    end

    set -l my_aliases
    set -l alias_comments

    for file_line in (grep -E "^\s*alias " $aliases_file)
        set -l alias_name (string replace -r "^\s*alias\s+(\w+)=.*" '$1' -- $file_line)
        set -a my_aliases $alias_name

        if string match -qr '#' -- $file_line
            set -l comment (string replace -r '^[^#]+#\s*(.*)$' '$1' -- $file_line)
            set -a alias_comments "$alias_name:$comment"
        end
    end

    for line in (alias | sort)
        set -l clean_line (string replace 'alias ' '' $line)
        set -l parts (string split -m 1 ' ' $clean_line)
        set -l name $parts[1]

        if not contains $name $my_aliases
            continue
        end

        set -l command (string trim -c "'" $parts[2])

        for comment_entry in $alias_comments
            if string match -q "$name:*" -- $comment_entry
                set command (string replace "$name:" '' -- $comment_entry)
                break
            end
        end

        printf "  "
        set_color yellow
        printf "%-15s" $name
        set_color normal
        printf " --> %s\n" $command
    end

    echo ""
    echo "Key Bindings:"
    echo "============="

    if command -v fzf &>/dev/null
        printf "  "
        set_color yellow
        printf "%-15s" "Ctrl-R"
        set_color normal
        printf " --> Search command history\n"

        printf "  "
        set_color yellow
        printf "%-15s" "Ctrl-T"
        set_color normal
        printf " --> Search files\n"
    end

    if command -v tmux &>/dev/null
        echo ""
        printf "  "
        set_color cyan
        printf "Tmux (prefix: Ctrl-b)\n"
        set_color normal

        printf "  "
        set_color yellow
        printf "%-15s" "|"
        set_color normal
        printf " --> Split horizontally\n"

        printf "  "
        set_color yellow
        printf "%-15s" "-"
        set_color normal
        printf " --> Split vertically\n"

        printf "  "
        set_color yellow
        printf "%-15s" "h/j/k/l"
        set_color normal
        printf " --> Navigate panes\n"

        printf "  "
        set_color yellow
        printf "%-15s" "c"
        set_color normal
        printf " --> Create new window\n"

        printf "  "
        set_color yellow
        printf "%-15s" "n/p"
        set_color normal
        printf " --> Next/Previous window\n"
    end

    if type -q zoxide
        echo ""
        printf "  "
        set_color cyan
        printf "Zoxide\n"
        set_color normal

        printf "  "
        set_color yellow
        printf "%-15s" "z <query>"
        set_color normal
        printf " --> Jump to directory\n"

        printf "  "
        set_color yellow
        printf "%-15s" "zi <query>"
        set_color normal
        printf " --> Interactive directory selection\n"
    end
end
