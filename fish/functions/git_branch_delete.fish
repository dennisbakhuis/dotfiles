# Git Branch Delete - Delete local and/or remote branches
#
# Usage:
#   gbd <branch_name>           # Delete both local and remote branches (if merged)
#   gbd -l <branch_name>        # Delete local branch only
#   gbd -r <branch_name>        # Delete remote branch only
#
# Flags:
#   -l, --local     Delete local branch only
#   -r, --remote    Delete remote branch only
#   -f, --force     Force delete (even if not merged)
#   (no flag)       Delete both local and remote branches (if merged)

function git_branch_delete
    set -l delete_local 1
    set -l delete_remote 1
    set -l branch_name ""
    set -l force_flag ""

    while test (count $argv) -gt 0
        switch $argv[1]
            case -l --local
                set delete_local 1
                set delete_remote 0
                set -e argv[1]
            case -r --remote
                set delete_local 0
                set delete_remote 1
                set -e argv[1]
            case -f --force
                set force_flag "-D"
                set -e argv[1]
            case '-*'
                echo "Unknown option: $argv[1]"
                echo "Usage: gbd [-l|--local] [-r|--remote] [-f|--force] <branch_name>"
                return 1
            case '*'
                set branch_name $argv[1]
                set -e argv[1]
        end
    end

    if test -z "$branch_name"
        echo "Error: Branch name is required"
        echo "Usage: gbd [-l|--local] [-r|--remote] [-f|--force] <branch_name>"
        return 1
    end

    set -l current_branch (git branch --show-current 2>/dev/null)
    if test "$branch_name" = "$current_branch"
        echo (set_color red)"Error: Cannot delete the currently checked out branch: $branch_name"(set_color normal)
        echo "Please switch to another branch first."
        return 1
    end

    if test \( "$branch_name" = "main" -o "$branch_name" = "dev" \) -a -z "$force_flag"
        echo (set_color red)"Error: Cannot delete protected branch '$branch_name' without force flag"(set_color normal)
        echo "Use -f or --force flag to force delete: "(set_color yellow)"gbd -f $branch_name"(set_color normal)
        return 1
    end

    set -l has_remote (git remote get-url origin &>/dev/null; echo $status)
    if test $has_remote -ne 0
        set delete_remote 0
    end

    if test $delete_local -eq 1
        if git show-ref --verify --quiet refs/heads/$branch_name
            echo (set_color cyan)"Deleting local branch: $branch_name"(set_color normal)

            set -l has_commits 0
            set -l upstream (git rev-parse --abbrev-ref $branch_name@{upstream} 2>/dev/null)
            if test -n "$upstream"
                set -l branch_commit (git rev-parse $branch_name)
                set -l upstream_commit (git rev-parse $upstream)
                if test "$branch_commit" != "$upstream_commit"
                    set has_commits 1
                end
            else
                set -l main_branch (git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
                if test -z "$main_branch"
                    set main_branch "master"
                end
                set -l merge_base (git merge-base $main_branch $branch_name 2>/dev/null)
                set -l branch_commit (git rev-parse $branch_name 2>/dev/null)
                if test "$merge_base" != "$branch_commit"
                    set has_commits 1
                end
            end

            if test -n "$force_flag"
                git branch $force_flag $branch_name
            else if test $has_commits -eq 0
                git branch -D $branch_name
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
        set -l remote_exists 0
        set -l tracking_exists 0

        if git ls-remote --exit-code --heads origin $branch_name &>/dev/null
            set remote_exists 1
        end

        if git show-ref --verify --quiet refs/remotes/origin/$branch_name
            set tracking_exists 1
        end

        if test $remote_exists -eq 1
            echo (set_color cyan)"Deleting remote branch: origin/$branch_name"(set_color normal)
            git push origin --delete $branch_name

            if test $status -ne 0
                echo (set_color red)"✗ Failed to delete remote branch"(set_color normal)
                return 1
            end
            echo (set_color green)"✓ Remote branch deleted successfully"(set_color normal)
        else if test $tracking_exists -eq 1
            echo (set_color yellow)"Note: Remote branch 'origin/$branch_name' not found on server"(set_color normal)
        end

        # Prune to clean up any stale tracking references
        if test $remote_exists -eq 1 -o $tracking_exists -eq 1
            echo (set_color cyan)"Cleaning up stale tracking references"(set_color normal)
            git fetch --prune --quiet 2>/dev/null
            if test $status -eq 0
                echo (set_color green)"✓ Tracking references cleaned up"(set_color normal)
            end
        end
    end
end
