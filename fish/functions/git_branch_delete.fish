# Git Branch Delete - Delete local and/or remote branches
#
# Usage:
#   gbd <branch_name>           # Delete local branch only
#   gbd -r <branch_name>        # Delete remote branch only
#   gbd -a <branch_name>        # Delete both local and remote branches
#
# Flags:
#   -r, --remote    Delete remote branch only
#   -a, --all       Delete both local and remote branches
#   (no flag)       Delete local branch only

function git_branch_delete
    set -l delete_local 1
    set -l delete_remote 0
    set -l branch_name ""
    set -l force_flag ""

    while test (count $argv) -gt 0
        switch $argv[1]
            case -r --remote
                set delete_local 0
                set delete_remote 1
                set -e argv[1]
            case -a --all
                set delete_local 1
                set delete_remote 1
                set -e argv[1]
            case -f --force
                set force_flag "-D"
                set -e argv[1]
            case '-*'
                echo "Unknown option: $argv[1]"
                echo "Usage: gbd [-r|--remote] [-a|--all] [-f|--force] <branch_name>"
                return 1
            case '*'
                set branch_name $argv[1]
                set -e argv[1]
        end
    end

    if test -z "$branch_name"
        echo "Error: Branch name is required"
        echo "Usage: gbd [-r|--remote] [-a|--all] [-f|--force] <branch_name>"
        return 1
    end

    set -l current_branch (git branch --show-current 2>/dev/null)
    if test "$branch_name" = "$current_branch"
        echo (set_color red)"Error: Cannot delete the currently checked out branch: $branch_name"(set_color normal)
        echo "Please switch to another branch first."
        return 1
    end

    if test $delete_local -eq 1
        if git show-ref --verify --quiet refs/heads/$branch_name
            echo (set_color cyan)"Deleting local branch: $branch_name"(set_color normal)
            if test -n "$force_flag"
                git branch $force_flag $branch_name
            else
                git branch -d $branch_name
            end

            if test $status -eq 0
                echo (set_color green)"✓ Local branch deleted successfully"(set_color normal)
            else
                echo (set_color red)"✗ Failed to delete local branch"(set_color normal)
                echo (set_color yellow)"Tip: Use -f flag to force delete if the branch is not fully merged"(set_color normal)
                return 1
            end
        else
            echo (set_color yellow)"Warning: Local branch '$branch_name' does not exist"(set_color normal)
        end
    end

    if test $delete_remote -eq 1
        if git ls-remote --exit-code --heads origin $branch_name &>/dev/null
            echo (set_color cyan)"Deleting remote branch: origin/$branch_name"(set_color normal)
            git push origin --delete $branch_name

            if test $status -eq 0
                echo (set_color green)"✓ Remote branch deleted successfully"(set_color normal)
            else
                echo (set_color red)"✗ Failed to delete remote branch"(set_color normal)
                return 1
            end
        else
            echo (set_color yellow)"Warning: Remote branch 'origin/$branch_name' does not exist"(set_color normal)
        end
    end

    echo (set_color green)"Done!"(set_color normal)
end
