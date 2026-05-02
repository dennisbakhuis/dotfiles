# Tab completion for git_branch_delete function

# Complete branch names from both local and remote branches,
# excluding the current branch and any branches already on the command line.
function __git_branch_delete_branches
    set -l current_branch (git branch --show-current 2>/dev/null)

    # Tokens already on the command line (drop command name, skip flags).
    set -l tokens (commandline -opc)
    set -l used
    set -l first 1
    for token in $tokens
        if test $first -eq 1
            set first 0
            continue
        end
        if string match -q -- '-*' $token
            continue
        end
        set -a used $token
    end

    # Local branches
    git branch --format='%(refname:short)' 2>/dev/null | while read -l branch
        if test "$branch" = "$current_branch"
            continue
        end
        if contains -- $branch $used
            continue
        end
        echo $branch
    end

    # Remote branches (strip origin/ prefix, drop HEAD)
    git branch -r --format='%(refname:short)' 2>/dev/null | string replace 'origin/' '' | string match -v 'HEAD*' | while read -l branch
        if contains -- $branch $used
            continue
        end
        echo $branch
    end
end

# Complete flags for both function and alias
complete -c git_branch_delete -s l -l local -d 'Delete local branch only'
complete -c git_branch_delete -s r -l remote -d 'Delete remote branch only'
complete -c git_branch_delete -s f -l force -d 'Force delete branch (even if not merged)'

complete -c gbd -s l -l local -d 'Delete local branch only'
complete -c gbd -s r -l remote -d 'Delete remote branch only'
complete -c gbd -s f -l force -d 'Force delete branch (even if not merged)'

# Complete branch names for both function and alias
complete -c git_branch_delete -f -a '(__git_branch_delete_branches)' -d 'Branch name'
complete -c gbd -f -a '(__git_branch_delete_branches)' -d 'Branch name'
